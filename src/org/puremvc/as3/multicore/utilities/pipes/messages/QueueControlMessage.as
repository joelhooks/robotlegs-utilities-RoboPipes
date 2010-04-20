/*
 PureMVC AS3/MultiCore Utility – Pipes
 Copyright (c) 2008 Cliff Hall<cliff.hall@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
 */
package org.puremvc.as3.multicore.utilities.pipes.messages
{
	/**
	 * Queue Control Message.
	 * <P>
	 * A special message for controlling the behavior of a Queue.</P>
	 * <P>
	 * When written to a pipeline containing a Queue, the type
	 * of the message is interpreted and acted upon by the Queue.</P>
	 * <P>
	 * Unlike filters, multiple serially connected queues aren't 
	 * very useful and so they do not require a name. If multiple
	 * queues are connected serially, the message will be acted 
	 * upon by the first queue only.</P>
	 */ 
	public class QueueControlMessage extends Message
	{
		protected static const BASE:String  = Message.BASE+'/queue/'; 

		/**
		 * Flush the queue.
		 */
		public static const FLUSH:String 	= BASE+'flush';
		
		/**
		 * Toggle to sort-by-priority operation mode.
		 */
		public static const SORT:String  	= BASE+'sort';
		
		/**
		 * Toggle to FIFO operation mode (default behavior).
		 */
		public static const FIFO:String  	= BASE+'fifo';

		// Constructor
		public function QueueControlMessage( type:String )
		{
			super( type  );
		}

	}
}