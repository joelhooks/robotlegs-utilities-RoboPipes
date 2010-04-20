package org.robotlegs.utilities.pipes.plumbing
{
    import flash.events.IEventDispatcher;
    
    import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeFitting;
    import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeMessage;
    import org.puremvc.as3.multicore.utilities.pipes.plumbing.PipeListener;
    import org.robotlegs.utilities.pipes.events.PipeMessageEvent;

    public class ModuleJunction
    {
        public static const INPUT:String 	= 'input';
        public static const OUTPUT:String 	= 'output';
        
        public static const STDIN_PIPE:String = "standardInputPipe";
        public static const STDOUT_PIPE:String = "standardOutputPipe";
        
        protected var globalDispatcher:IEventDispatcher;
        protected var localDispatcher:IEventDispatcher;
        
        protected var inputPipes:Array = [];
        protected var outputPipes:Array = [];
        
        protected var pipesMap:Array = [];
        protected var pipeTypesMap:Array = [];
        
        public function ModuleJunction(globalDispatcher:IEventDispatcher, localDispatcher:IEventDispatcher)
        {
            this.globalDispatcher = globalDispatcher;
            this.localDispatcher = localDispatcher;
        }

        public function registerPipe( name:String, type:String, pipe:IPipeFitting ):Boolean
        { 
            var success:Boolean = true;
            if ( pipesMap[name] == null )
            {
                pipesMap[name] = pipe;
                pipeTypesMap[name] = type;
                switch (type) {
                    case INPUT:
                        inputPipes.push(name);	
                        break;						
                    case OUTPUT:
                        outputPipes.push(name);	
                        break;					
                    default:	
                        success=false;
                }
            } else {
                success=false;
            }
            return success;
        }
        
        public function hasPipe( name:String ):Boolean
        {
            return ( pipesMap[ name ] != null );
        }
        
        public function hasInputPipe( name:String ):Boolean
        {
            return ( hasPipe(name) && (pipeTypesMap[name] == INPUT) );
        }
        
        public function hasOutputPipe( name:String ):Boolean
        {
            return ( hasPipe(name) && (pipeTypesMap[name] == OUTPUT) );
        }
        
        public function removePipe( name:String ):void 
        {
            if ( hasPipe(name) ) 
            {
                var type:String = pipeTypesMap[name];
                var pipesList:Array;
                switch (type) {
                    case INPUT:
                        pipesList = inputPipes;
                        break;						
                    case OUTPUT:
                        pipesList = outputPipes;	
                        break;					
                }
                for (var i:int=0;i<pipesList.length;i++){
                    if (pipesList[i] == name){
                        pipesList.splice(i, 1);
                        break;
                    }
                }
                delete pipesMap[name];
                delete pipeTypesMap[name];
            }
        }
        
        public function retrievePipe( name:String ):IPipeFitting 
        {
            return pipesMap[name]  as IPipeFitting;
        }
        
        public function addPipeListener( inputPipeName:String, context:Object, listener:Function ):Boolean 
        {
            var success:Boolean=false;
            if ( hasInputPipe(inputPipeName) )
            {
                var pipe:IPipeFitting = pipesMap[inputPipeName] as IPipeFitting;
                success = pipe.connect( new PipeListener(context, listener) );
            } 
            return success;
        }
        
        public function sendMessage( outputPipeName:String, message:IPipeMessage ):Boolean 
        {
            var success:Boolean=false;
            if ( hasOutputPipe(outputPipeName) )
            {
                var pipe:IPipeFitting = pipesMap[outputPipeName] as IPipeFitting;
                success = pipe.write(message);
            } 
            return success;
        }
        
        public function handlePipeMessage(message:IPipeMessage):void
        {
            localDispatcher.dispatchEvent(new PipeMessageEvent(PipeMessageEvent.MESSAGE_DISPATCHED, message));
        }
        
        protected var _name:String;
        public function get name():String
        {
            return _name;
        }
        public function set name(value:String):void
        {
            _name=value;
        }
    }
}