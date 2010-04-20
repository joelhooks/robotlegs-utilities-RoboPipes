package org.robotlegs.utilities.pipes.events
{
    import flash.events.Event;
    
    import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeMessage;
    
    public class PipeMessageEvent extends Event
    {
        private var _message:IPipeMessage;

        public function get message():IPipeMessage
        {
            return _message;
        }
        
        public function PipeMessageEvent(type:String, message:IPipeMessage, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, bubbles, cancelable);
            
            _message = message;
        }
        
        override public function clone():Event
        {
            return new PipeMessageEvent(type,message,bubbles,cancelable);
        }
    }
}