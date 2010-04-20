package org.robotlegs.core
{
    import org.robotlegs.utilities.pipes.plumbing.ModuleJunction;

    public interface IModuleMap
    {
        function registerContext(context:IContext,named:String,autoPlumb:Boolean=true):ModuleJunction;
    }
}