/*
 PureMVC AS3/MultiCore Utility – Pipes
 Copyright (c) 2008 Cliff Hall<cliff.hall@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
 */
package org.puremvc.as3.multicore.utilities.pipes.messages
{
	
	/**
	 * Filter Control Message.
	 * <P>
	 * A special message type for controlling the behavior of a Filter.</P>
	 * <P> 
	 * The <code>FilterControlMessage.SET_PARAMS</code> message type tells the Filter
	 * to retrieve the filter parameters object.</P> 
	 * 
	 * <P> 
	 * The <code>FilterControlMessage.SET_FILTER</code> message type tells the Filter
	 * to retrieve the filter function.</P>
	 * 
	 * <P> 
	 * The <code>FilterControlMessage.BYPASS</code> message type tells the Filter
	 * that it should go into Bypass mode operation, passing all normal
	 * messages through unfiltered.</P>
	 * 
	 * <P>
	 * The <code>FilterControlMessage.FILTER</code> message type tells the Filter
	 * that it should go into Filtering mode operation, filtering all
	 * normal normal messages before writing out. This is the default
	 * mode of operation and so this message type need only be sent to
	 * cancel a previous  <code>FilterControlMessage.BYPASS</code> message.</P>
	 * 
	 * <P>
	 * The Filter only acts on a control message if it is targeted 
	 * to this named filter instance. Otherwise it writes the message
	 * through to its output unchanged.</P>
	 */ 
	public class FilterControlMessage extends Message
	{
		/**
		 * Message type base URI
		 */
		protected static const BASE:String  = Message.BASE+'filter-control/';
		
		/**
		 * Set filter parameters.
		 */ 
		public static const SET_PARAMS:String 	= BASE+'setparams';
		
		/**
		 * Set filter function.
		 */ 
		public static const SET_FILTER:String 	= BASE+'setfilter';

		/**
		 * Toggle to filter bypass mode.
		 */
		public static const BYPASS:String 		= BASE+'bypass';
		
		/**
		 * Toggle to filtering mode. (default behavior).
		 */
		public static const FILTER:String  		= BASE+'filter';


		// Constructor
		public function FilterControlMessage( type:String, name:String, filter:Function=null, params:Object=null )
		{
			super( type );
			setName( name );
			setFilter( filter );
			setParams( params );
		}

		/**
		 * Set the target filter name.
		 */
		public function setName( name:String ):void
		{
			this.name = name;
		}
		
		/**
		 * Get the target filter name.
		 */
		public function getName( ):String
		{
			return this.name;
		}
		
		/**
		 * Set the filter function.
		 */
		public function setFilter( filter:Function ):void
		{
			this.filter = filter;
		}
		
		/**
		 * Get the filter function.
		 */
		public function getFilter( ):Function
		{
			return this.filter;
		}
		
		/**
		 * Set the parameters object.
		 */
		public function setParams( params:Object ):void
		{
			this.params = params;
		}
		
		/**
		 * Get the parameters object.
		 */
		public function getParams( ):Object
		{
			return this.params;
		}
		
		protected var params:Object;
		protected var filter:Function;
		protected var name:String;
	}
}