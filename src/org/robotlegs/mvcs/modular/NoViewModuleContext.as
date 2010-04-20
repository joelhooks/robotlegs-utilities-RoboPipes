package org.robotlegs.mvcs.modular
{
    import flash.display.Sprite;
    
    import org.robotlegs.base.ModuleMap;
    import org.robotlegs.core.IInjector;
    
    public class NoViewModuleContext extends ModuleContext
    {
        public function NoViewModuleContext(moduleMap:ModuleMap=null, name:String="", injector:IInjector=null)
        {
            super(moduleMap, name, injector);
            contextView = new Sprite();
        }
    }
}