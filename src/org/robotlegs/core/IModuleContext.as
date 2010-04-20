package org.robotlegs.core
{
    public interface IModuleContext
    {
        
    function get name():String;

    function set name(value:String):void;

    function set moduleMap(value:IModuleMap):void;

    function get moduleMap():IModuleMap;
    }
}