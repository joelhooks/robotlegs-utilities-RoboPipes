/*
 PureMVC AS3/MultiCore Utility – Pipes
 Copyright (c) 2008 Cliff Hall<cliff.hall@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
 */
package org.puremvc.as3.multicore.utilities.pipes.plumbing
{
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeFitting;
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeMessage;
	import org.puremvc.as3.multicore.utilities.pipes.messages.Message;
	import org.puremvc.as3.multicore.utilities.pipes.messages.QueueControlMessage;
	
	/** 
	 * Pipe Queue.
	 * <P>
	 * The Queue always stores inbound messages until you send it
	 * a FLUSH control message, at which point it writes its buffer 
	 * to the output pipe fitting. The Queue can be sent a SORT 
	 * control message to go into sort-by-priority mode or a FIFO 
	 * control message to cancel sort mode and return the
	 * default mode of operation, FIFO.</P>
	 * 
	 * <P>
	 * NOTE: There can effectively be only one Queue on a given 
	 * pipeline, since the first Queue acts on any queue control 
	 * message. Multiple queues in one pipeline are of dubious 
	 * use, and so having to name them would make their operation 
	 * more complex than need be.</P> 
	 */
	public class Queue extends Pipe
	{
		public function Queue( output:IPipeFitting=null )
		{
			super( output );
		}
		
		/**
		 * Handle the incoming message.
		 * <P>
		 * Normal messages are enqueued.</P>
		 * <P>
		 * The FLUSH message type tells the Queue to write all 
		 * stored messages to the ouptut PipeFitting, then 
		 * return to normal enqueing operation.</P>
		 * <P>
		 * The SORT message type tells the Queue to sort all 
		 * <I>subsequent</I> incoming messages by priority. If there
		 * are unflushed messages in the queue, they will not be
		 * sorted unless a new message is sent before the next FLUSH.
		 * Sorting-by-priority behavior continues even after a FLUSH, 
		 * and can be turned off by sending a FIFO message, which is 
		 * the default behavior for enqueue/dequeue.</P> 
		 */ 
		override public function write( message:IPipeMessage ):Boolean
		{
			var success:Boolean = true;
			switch ( message.getType() )	
			{
				// Store normal messages
				case Message.NORMAL:
					this.store( message );
					break;
					
				// Flush the queue
				case QueueControlMessage.FLUSH:
					success = this.flush();		
					break;

				// Put Queue into Priority Sort or FIFO mode 
				// Subsequent messages written to the queue
				// will be affected. Sorted messages cannot
				// be put back into FIFO order!
				case QueueControlMessage.SORT:
				case QueueControlMessage.FIFO:
					mode = message.getType();
					break;
			}
			return success;
		} 
		
		/**
		 * Store a message.
		 * @param message the IPipeMessage to enqueue.
		 * @return int the new count of messages in the queue
		 */
		protected function store( message:IPipeMessage ):void
		{
			messages.push( message );
			if (mode == QueueControlMessage.SORT ) messages.sort( sortMessagesByPriority );
		}


		/**
		 * Sort the Messages by priority.
		 */
		protected function sortMessagesByPriority(msgA:IPipeMessage, msgB:IPipeMessage):Number
		{
			var num:Number = 0;
			if ( msgA.getPriority() < msgB.getPriority() ) num = -1;
			if ( msgA.getPriority() > msgB.getPriority() ) num = 1;
			return num;
		}
		
		/**
		 * Flush the queue.
		 * <P>
		 * NOTE: This empties the queue.</P>
		 * @return Boolean true if all messages written successfully.
		 */
		protected function flush():Boolean
		{
			var success:Boolean=true;
			var message:IPipeMessage = messages.shift() as IPipeMessage;
			while ( message != null ) 
			{
				var ok:Boolean = output.write( message );
				if ( !ok ) success = false;
				message = messages.shift() as IPipeMessage;
			} 
			return success;
		}

		protected var mode:String = QueueControlMessage.SORT;
		protected var messages:Array = new Array();
	}
}