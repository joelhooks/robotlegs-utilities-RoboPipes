package org.robotlegs.mvcs.modular
{
    import flash.display.Sprite;
    
    import org.robotlegs.base.ModuleMap;
    import org.robotlegs.core.IInjector;
    import org.robotlegs.core.IModuleMap;
    
    public class NoViewModuleContext extends ModuleContext
    {
        public function NoViewModuleContext(moduleMap:IModuleMap=null, name:String="", parentInjector:IInjector=null)
        {
            super(moduleMap, name, parentInjector);
        }
        
        override protected function mapInjections():void
        {
            _contextView = new Sprite();
            super.mapInjections();
        }
    }
}