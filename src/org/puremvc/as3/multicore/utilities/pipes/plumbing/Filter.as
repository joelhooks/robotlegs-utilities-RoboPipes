/*
 PureMVC AS3/MultiCore Utility – Pipes
 Copyright (c) 2008 Cliff Hall<cliff.hall@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
 */
package org.puremvc.as3.multicore.utilities.pipes.plumbing
{
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeFitting;
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeMessage;
	import org.puremvc.as3.multicore.utilities.pipes.messages.FilterControlMessage;
	import org.puremvc.as3.multicore.utilities.pipes.messages.Message;
	
	/**
	 * Pipe Filter.
	 * <P>
	 * Filters may modify the contents of messages before writing them to 
	 * their output pipe fitting. They may also have their parameters and
	 * filter function passed to them by control message, as well as having
	 * their Bypass/Filter operation mode toggled via control message.</p>  
	 */ 
	public class Filter extends Pipe
	{
		
		/**
		 * Constructor.
		 * <P>
		 * Optionally connect the output and set the parameters.</P>
		 */
		public function Filter( name:String, output:IPipeFitting=null, filter:Function=null, params:Object=null ) 
		{
			super( output );
			this.name = name;
			if ( filter != null ) setFilter( filter );
			if ( params != null ) setParams( params );
		}

		/**
		 * Handle the incoming message.
		 * <P>
		 * If message type is normal, filter the message (unless in BYPASS mode)
		 * and write the result to the output pipe fitting if the filter 
		 * operation is successful.</P>
		 * 
		 * <P> 
		 * The FilterControlMessage.SET_PARAMS message type tells the Filter
		 * that the message class is FilterControlMessage, which it 
		 * casts the message to in order to retrieve the filter parameters
		 * object if the message is addressed to this filter.</P> 
		 * 
		 * <P> 
		 * The FilterControlMessage.SET_FILTER message type tells the Filter
		 * that the message class is FilterControlMessage, which it 
		 * casts the message to in order to retrieve the filter function.</P>
		 * 
		 * <P> 
		 * The FilterControlMessage.BYPASS message type tells the Filter
		 * that it should go into Bypass mode operation, passing all normal
		 * messages through unfiltered.</P>
		 * 
		 * <P>
		 * The FilterControlMessage.FILTER message type tells the Filter
		 * that it should go into Filtering mode operation, filtering all
		 * normal normal messages before writing out. This is the default
		 * mode of operation and so this message type need only be sent to
		 * cancel a previous BYPASS message.</P>
		 * 
		 * <P>
		 * The Filter only acts on the control message if it is targeted 
		 * to this named filter instance. Otherwise it writes through to the
		 * output.</P>
		 * 
		 * @return Boolean True if the filter process does not throw an error and subsequent operations 
		 * in the pipeline succede.
		 */
		override public function write( message:IPipeMessage ):Boolean
		{
			var outputMessage:IPipeMessage;
			var success:Boolean = true;

			// Filter normal messages
			switch ( message.getType())
			{
				case  Message.NORMAL: 	
					try {
						if ( mode == FilterControlMessage.FILTER ) {
							outputMessage = applyFilter( message );
						} else {
							outputMessage = message;
						}
						success = output.write( outputMessage );
					} catch (e:Error) {
						success = false;
					}
					break;
				
				// Accept parameters from control message 
				case FilterControlMessage.SET_PARAMS:
					if (isTarget(message)) 					{
						setParams( FilterControlMessage(message).getParams() );
					} else {
						success = output.write( outputMessage );
					}
					break;

				// Accept filter function from control message 
				case FilterControlMessage.SET_FILTER:
					if (isTarget(message)){
						setFilter( FilterControlMessage(message).getFilter() );
					} else {
						success = output.write( outputMessage );
					}
					
					break;

				// Toggle between Filter or Bypass operational modes
				case FilterControlMessage.BYPASS:
				case FilterControlMessage.FILTER:
					if (isTarget(message)){
						mode = FilterControlMessage(message).getType();
					} else {
						success = output.write( outputMessage );
					}
					break;
				
				// Write control messages for other fittings through
				default:	
					success = output.write( outputMessage );
			}
			return success;			
		}
		
		/**
		 * Is the message directed at this filter instance?
		 */
		protected function isTarget(m:IPipeMessage):Boolean
		{
			return ( FilterControlMessage(m).getName() == this.name );
		}
		
		/**
		 * Set the Filter parameters.
		 * <P>
		 * This can be an object can contain whatever arbitrary 
		 * properties and values your filter method requires to
		 * operate.</P>
		 * 
		 * @param params the parameters object
		 */
		public function setParams( params:Object ):void
		{
			this.params = params;
		}

		/**
		 * Set the Filter function.
		 * <P>
		 * It must accept two arguments; an IPipeMessage, 
		 * and a parameter Object, which can contain whatever 
		 * arbitrary properties and values your filter method 
		 * requires.</P>
		 * 
		 * @param filter the filter function. 
		 */
		public function setFilter( filter:Function ):void
		{
			this.filter = filter;
		}
		
		/**
		 * Filter the message.
		 */
		protected function applyFilter( message:IPipeMessage ):IPipeMessage
		{
			filter.apply( this, [ message, params ] );
			return message;
		}
		
		protected var mode:String = FilterControlMessage.FILTER;
		protected var filter:Function = function(message:IPipeMessage, params:Object):void{return;};
		protected var params:Object = {};
		protected var name:String;

	}
}