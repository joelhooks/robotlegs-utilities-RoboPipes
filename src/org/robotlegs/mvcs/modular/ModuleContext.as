package org.robotlegs.mvcs.modular
{
    import flash.display.DisplayObjectContainer;
    import flash.events.IEventDispatcher;
    
    import org.robotlegs.base.ContextBase;
    import org.robotlegs.base.EventMap;
    import org.robotlegs.base.ModuleMap;
    import org.robotlegs.core.ICommandMap;
    import org.robotlegs.core.IContext;
    import org.robotlegs.core.IEventMap;
    import org.robotlegs.core.IInjector;
    import org.robotlegs.core.IMediatorMap;
    import org.robotlegs.core.IModuleContext;
    import org.robotlegs.core.IModuleMap;
    import org.robotlegs.core.IReflector;
    import org.robotlegs.core.IViewMap;
    import org.robotlegs.mvcs.Context;
    import org.robotlegs.utilities.pipes.plumbing.ModuleJunction;
    
    public class ModuleContext extends Context implements IModuleContext
    {
        protected var _moduleMap:IModuleMap;
        protected var moduleJunction:ModuleJunction;
        
        protected var _name:String;

        public function get name():String
        {
            return _name;
        }

        public function set name(value:String):void
        {
            if(_name != value)
            {
                _name = value;
                mapInjections();
                if(moduleMap)
                    registerModule();
            }
        }
     
        public function ModuleContext(moduleMap:IModuleMap = null, name:String = "", parentInjector:IInjector=null)
        {
            if(parentInjector)
            {
                injector = parentInjector.createChild();
            }
            _moduleMap = moduleMap;
            _name = name;
            registerModule();
        }
        
        protected function registerModule():void
        {
            if(name)
                moduleJunction = moduleMap.registerContext(this, name);
        }
        
        [Bindable]
        public function set moduleMap(value:IModuleMap):void
        {
            
            if(_moduleMap != value)
            {
                _moduleMap = value;
                if(name)
                    registerModule();
            }
            
        }
        
        public function get moduleMap():IModuleMap
        {
            return _moduleMap ||= new ModuleMap();
        }
        
        override protected function mapInjections():void
        {
            super.mapInjections();
            injector.mapValue(IModuleMap, moduleMap);
            injector.mapValue(ModuleJunction, moduleJunction);
        }  
        
        override protected function checkAutoStartup():void
        {
            if (name && moduleMap)
            {
                super.checkAutoStartup();
            }
        }
    }
}