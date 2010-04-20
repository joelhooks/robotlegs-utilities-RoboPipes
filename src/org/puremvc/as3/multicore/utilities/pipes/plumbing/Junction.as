/*
 PureMVC AS3/MultiCore Utility – Pipes
 Copyright (c) 2008 Cliff Hall<cliff.hall@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
 */
package org.puremvc.as3.multicore.utilities.pipes.plumbing
{
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeFitting;
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeMessage;
	
	/**
	 * Pipe Junction.
	 * 
	 * <P>
	 * Manages Pipes for a Module. 
	 * 
	 * <P>
	 * When you register a Pipe with a Junction, it is 
	 * declared as being an INPUT pipe or an OUTPUT pipe.</P> 
	 * 
	 * <P>
	 * You can retrieve or remove a registered Pipe by name, 
	 * check to see if a Pipe with a given name exists,or if 
	 * it exists AND is an INPUT or an OUTPUT Pipe.</P> 
	 * 
	 * <P>
	 * You can send an <code>IPipeMessage</code> on a named INPUT Pipe 
	 * or add a <code>PipeListener</code> to registered INPUT Pipe.</P>
	 */
	public class Junction
	{
		/**
		 *  INPUT Pipe Type
		 */
		public static const INPUT:String 	= 'input';
		/**
		 *  OUTPUT Pipe Type
		 */
		public static const OUTPUT:String 	= 'output';
		
		// Constructor. 
		public function Junction( )
		{
		}

		/**
		 * Register a pipe with the junction.
		 * <P>
		 * Pipes are registered by unique name and type,
		 * which must be either <code>Junction.INPUT</code>
		 * or <code>Junction.OUTPUT</code>.</P>
 		 * <P>
		 * NOTE: You cannot have an INPUT pipe and an OUTPUT
		 * pipe registered with the same name. All pipe names
		 * must be unique regardless of type.</P>
		 * 
		 * @return Boolean true if successfully registered. false if another pipe exists by that name.
		 */
		public function registerPipe( name:String, type:String, pipe:IPipeFitting ):Boolean
		{ 
			var success:Boolean = true;
			if ( pipesMap[name] == null )
			{
				pipesMap[name] = pipe;
				pipeTypesMap[name] = type;
				switch (type) {
					case INPUT:
						inputPipes.push(name);	
						break;						
					case OUTPUT:
						outputPipes.push(name);	
						break;					
					default:	
						success=false;
				}
			} else {
				success=false;
			}
			return success;
		}
		
		/**
		 * Does this junction have a pipe by this name?
		 * 
		 * @param name the pipe to check for 
		 * @return Boolean whether as pipe is registered with that name.
		 */ 
		public function hasPipe( name:String ):Boolean
		{
			return ( pipesMap[ name ] != null );
		}
		
		/**
		 * Does this junction have an INPUT pipe by this name?
		 * 
		 * @param name the pipe to check for 
		 * @return Boolean whether an INPUT pipe is registered with that name.
		 */ 
		public function hasInputPipe( name:String ):Boolean
		{
			return ( hasPipe(name) && (pipeTypesMap[name] == INPUT) );
		}

		/**
		 * Does this junction have an OUTPUT pipe by this name?
		 * 
		 * @param name the pipe to check for 
		 * @return Boolean whether an OUTPUT pipe is registered with that name.
		 */ 
		public function hasOutputPipe( name:String ):Boolean
		{
			return ( hasPipe(name) && (pipeTypesMap[name] == OUTPUT) );
		}

		/**
		 * Remove the pipe with this name if it is registered.
		 * <P>
		 * NOTE: You cannot have an INPUT pipe and an OUTPUT
		 * pipe registered with the same name. All pipe names
		 * must be unique regardless of type.</P>
		 * 
		 * @param name the pipe to remove
		 */
		public function removePipe( name:String ):void 
		{
			if ( hasPipe(name) ) 
			{
				var type:String = pipeTypesMap[name];
				var pipesList:Array;
				switch (type) {
					case INPUT:
						pipesList = inputPipes;
						break;						
					case OUTPUT:
						pipesList = outputPipes;	
						break;					
				}
				for (var i:int=0;i<pipesList.length;i++){
					if (pipesList[i] == name){
						pipesList.splice(i, 1);
						break;
					}
				}
				delete pipesMap[name];
				delete pipeTypesMap[name];
			}
		}

		/**
		 * Retrieve the named pipe.
		 * 
		 * @param name the pipe to retrieve
		 * @return IPipeFitting the pipe registered by the given name if it exists
		 */
		public function retrievePipe( name:String ):IPipeFitting 
		{
			return pipesMap[name]  as IPipeFitting;
		}

		/**
		 * Add a PipeListener to an INPUT pipe.
		 * <P>
		 * NOTE: there can only be one PipeListener per pipe,
		 * and the listener function must accept an IPipeMessage
		 * as its sole argument.</P> 
		 * 
		 * @param name the INPUT pipe to add a PipeListener to
		 * @param context the calling context or 'this' object  
		 * @param listener the function on the context to call
		 */
		public function addPipeListener( inputPipeName:String, context:Object, listener:Function ):Boolean 
		{
			var success:Boolean=false;
			if ( hasInputPipe(inputPipeName) )
			{
				var pipe:IPipeFitting = pipesMap[inputPipeName] as IPipeFitting;
				success = pipe.connect( new PipeListener(context, listener) );
			} 
			return success;
		}
		
		/**
		 * Send a message on an OUTPUT pipe.
		 * 
		 * @param name the OUTPUT pipe to send the message on
		 * @param message the IPipeMessage to send  
		 */
		public function sendMessage( outputPipeName:String, message:IPipeMessage ):Boolean 
		{
			var success:Boolean=false;
			if ( hasOutputPipe(outputPipeName) )
			{
				var pipe:IPipeFitting = pipesMap[outputPipeName] as IPipeFitting;
				success = pipe.write(message);
			} 
			return success;
		}

		/**
		 *  The names of the INPUT pipes
		 */
		protected var inputPipes:Array = new Array();
		
		/**
		 *  The names of the OUTPUT pipes
		 */
		protected var outputPipes:Array = new Array();
		
		/** 
		 * The map of pipe names to their pipes
		 */
		protected var pipesMap:Array = new Array();
		
		/**
		 * The map of pipe names to their types
		 */
		protected var pipeTypesMap:Array = new Array();

	}
}
