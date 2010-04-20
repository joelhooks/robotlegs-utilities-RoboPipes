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
    import org.robotlegs.core.IReflector;
    import org.robotlegs.core.IViewMap;
    import org.robotlegs.mvcs.Context;
    import org.robotlegs.utilities.pipes.plumbing.ModuleJunction;
    
    public class ModuleContext extends Context implements IModuleContext
    {
        protected var _moduleMap:ModuleMap;
        protected var moduleJunction:ModuleJunction;
        
        private var _name:String;

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
                registerModule();
            }
        }

        
        public function ModuleContext(moduleMap:ModuleMap = null, name:String = "", injector:IInjector=null)
        {
            super();
            if(injector)
            {
                this.injector = injector.createChild();
            }
            _moduleMap = moduleMap;
            _name = name;
            registerModule();
        }
        
        protected function registerModule():void
        {
            if(name)
                moduleJunction = this.moduleMap.registerContext(this, name);
        }
        
        public function set moduleMap(value:ModuleMap):void
        {
            _moduleMap = value;
        }
        
        public function get moduleMap():ModuleMap
        {
            return _moduleMap ||= new ModuleMap();
        }
        
        override protected function mapInjections():void
        {
            injector.mapValue(IReflector, reflector);
            injector.mapValue(IInjector, injector);
            injector.mapValue(IEventDispatcher, eventDispatcher);
            injector.mapValue(DisplayObjectContainer, contextView);
            injector.mapValue(ICommandMap, commandMap);
            injector.mapValue(IMediatorMap, mediatorMap);
            injector.mapValue(IViewMap, viewMap);
            injector.mapClass(IEventMap, EventMap);
            injector.mapValue(ModuleMap, moduleMap);
            injector.mapValue(ModuleJunction, moduleJunction);
        }
        
        
    }
}