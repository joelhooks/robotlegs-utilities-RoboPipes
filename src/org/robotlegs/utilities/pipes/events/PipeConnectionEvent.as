package org.robotlegs.utilities.pipes.events
{
    import flash.events.Event;
    
    import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeFitting;
    import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeMessage;
    
    public class PipeConnectionEvent extends Event
    {
        public static const ACCEPT_INPUT_PIPE:String 	= 'acceptInputPipe';
        public static const ACCEPT_OUTPUT_PIPE:String 	= 'acceptOutputPipe';
        
        private var _pipeName:String;

        public function get pipeName():String
        {
            return _pipeName;
        }

        private var _pipeFitting:IPipeFitting;

        public function get pipeFitting():IPipeFitting
        {
            return _pipeFitting;
        }

        public function set pipeFitting(value:IPipeFitting):void
        {
            _pipeFitting = value;
        }
        
        
        public function PipeConnectionEvent(type:String, pipeName:String, pipeFitting:IPipeFitting, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, bubbles, cancelable);
            _pipeName = pipeName;
            _pipeFitting = pipeFitting;
        }

        override public function clone():Event
        {
            return new PipeConnectionEvent(type,pipeName,pipeFitting,bubbles,cancelable);
        }
    }
}