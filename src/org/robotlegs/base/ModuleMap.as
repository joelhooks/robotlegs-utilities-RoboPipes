package org.robotlegs.base
{
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;
    import flash.utils.Dictionary;
    import flash.utils.getQualifiedClassName;
    
    import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeFitting;
    import org.puremvc.as3.multicore.utilities.pipes.plumbing.Pipe;
    import org.puremvc.as3.multicore.utilities.pipes.plumbing.TeeMerge;
    import org.puremvc.as3.multicore.utilities.pipes.plumbing.TeeSplit;
    import org.robotlegs.core.IContext;
    import org.robotlegs.utilities.pipes.plumbing.ModuleJunction;

    public class ModuleMap
    {
        protected var eventDispatcher:IEventDispatcher;
        
        protected var m_mappings:Dictionary;
        
        public function ModuleMap()
        {
            eventDispatcher = new EventDispatcher();
            m_mappings = new Dictionary();
        }
        
        public function registerContext(context:IContext, named:String, autoPlumb:Boolean=true):ModuleJunction
        {
            var junction:ModuleJunction = addJunction(context, named);
            if(autoPlumb)
                plumbJunction(junction);
            return junction;
        }
        
        protected function addJunction(forContext:IContext, named:String = ""):ModuleJunction
        {
            m_mappings[forContext] = new ModuleJunction(eventDispatcher,forContext.eventDispatcher);
            m_mappings[forContext].name = named;
            
            return m_mappings[forContext];
        }
        
        protected function plumbJunction(junction:ModuleJunction):void
        {
            // Create the STDOUT splitting tee for communicating from the Shell to all modules 
            var outTee:TeeSplit = new TeeSplit();
            junction.registerPipe( ModuleJunction.STDOUT_PIPE,  ModuleJunction.OUTPUT, outTee );
            
            // The STDIN merging tee for communicating to the Shell from all modules 
            var inTee:TeeMerge = new TeeMerge();
            junction.registerPipe( ModuleJunction.STDIN_PIPE,  ModuleJunction.INPUT, inTee );
            junction.addPipeListener( ModuleJunction.STDIN_PIPE, this, junction.handlePipeMessage );
            
            for(var key:Object in m_mappings)
            {
                if(m_mappings[key] is ModuleJunction && m_mappings[key] != junction)
                    connectJunctions(m_mappings[key],junction);
            }
        }
        
        protected function connectJunctions(junctionOne:ModuleJunction, junctionTwo:ModuleJunction):void
        {
            // Shell-to-DoodadModule Dedicted OUTPUT
            var junctionOneToJunctionTwo:IPipeFitting = new Pipe();
            junctionOne.registerPipe( junctionTwo.name, ModuleJunction.OUTPUT, junctionOneToJunctionTwo ); 
            
            // Tee Shell-to-DoodadModule Dedicated OUTPUT [and] Shell STDOUT [into] Doodad STDIN
            var junctionTwoInTee:TeeMerge = junctionTwo.retrievePipe(ModuleJunction.STDIN_PIPE) as TeeMerge;
            junctionTwoInTee.connectInput( junctionOneToJunctionTwo );
            junctionTwoInTee.connectInput( junctionOne.retrievePipe(ModuleJunction.STDOUT_PIPE) );
            
            // Connect DoodadModule STDOUT to Shell STDIN
            var junctionTwoToJunctionOne:Pipe = new Pipe();
            var junctionOneInTee:TeeMerge = junctionOne.retrievePipe(ModuleJunction.STDIN_PIPE) as TeeMerge;
            junctionOneInTee.connectInput( junctionTwoToJunctionOne );
        }
    }
}