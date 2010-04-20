/*
 PureMVC AS3/MultiCore Utility – Pipes
 Copyright (c) 2008 Cliff Hall<cliff.hall@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
 */
package org.puremvc.as3.multicore.utilities.pipes.messages
{
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeMessage;
	/**
	 * Pipe Message.
	 * <P>
	 * Messages travelling through a Pipeline can
	 * be filtered, and queued. In a queue, they may
	 * be sorted by priority. Based on type, they 
	 * may used as control messages to modify the
	 * behavior of filter or queue fittings connected
	 * to the pipleline into which they are written.</P>
	 */ 
	public class Message implements IPipeMessage
	{

		// High priority Messages can be sorted to the front of the queue 
		public static const PRIORITY_HIGH:int = 1;
		// Medium priority Messages are the default
		public static const PRIORITY_MED:int = 5;
		// Low priority Messages can be sorted to the back of the queue 
		public static const PRIORITY_LOW:int = 10;
		
		/**
		 * Normal Message type.
		 */
		protected static const BASE:String = 'http://puremvc.org/namespaces/pipes/messages/';
		public static const NORMAL:String = BASE+'normal/';
		
		// TBD: Messages in a queue can be sorted by priority.
		protected var priority:int;

		// Messages can be handled differently according to type
		protected var type:String;
		
		// Header properties describe any meta data about the message for the recipient
		protected var header:Object;

		// Body of the message is the precious cargo
		protected var body:Object;

		// Constructor
		public function Message( type:String, header:Object=null, body:Object=null, priority:int=5 )
		{
			setType( type );
			setHeader( header );
			setBody( body );
			setPriority( priority );
		}
		
		// Get the type of this message
		public function getType():String
		{
			return this.type;
		}
		
		// Set the type of this message
		public function setType( type:String ):void
		{
			this.type = type;
		}
		
		// Get the priority of this message
		public function getPriority():int
		{
			return priority;
		}

		// Set the priority of this message
		public function setPriority( priority:int ):void
		{
			this.priority = priority;
		}
		
		// Get the header of this message
		public function getHeader():Object
		{
			return header;
		}

		// Set the header of this message
		public function setHeader( header:Object ):void
		{
			this.header = header;
		}
		
		// Get the body of this message
		public function getBody():Object
		{
			return body;
		}

		// Set the body of this message
		public function setBody( body:Object ):void
		{
			this.body = body;
		}

	}
}