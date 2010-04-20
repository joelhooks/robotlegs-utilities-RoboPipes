/*
 PureMVC AS3/MultiCore Utility – Pipes
 Copyright (c) 2008 Cliff Hall<cliff.hall@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
 */
package org.puremvc.as3.multicore.utilities.pipes.interfaces
{
	/** 
	 * Pipe Message Interface.
	 * <P>
	 * <code>IPipeMessage</code>s are objects written intoto a Pipeline, 
	 * composed of <code>IPipeFitting</code>s. The message is passed from 
	 * one fitting to the next in syncrhonous fashion.</P> 
	 * <P>
	 * Depending on type, messages may be handled  differently by the 
	 * fittings.</P>
	 */
	public interface IPipeMessage
	{
		// Get the type of this message
		function getType():String;

		// Set the type of this message
		function setType(type:String):void;
		
		// Get the priority of this message
		function getPriority():int;

		// Set the priority of this message
		function setPriority(priority:int):void;
		
		// Get the header of this message
		function getHeader():Object;

		// Set the header of this message
		function setHeader(header:Object):void;
		
		// Get the body of this message
		function getBody():Object;

		// Set the body of this message
		function setBody(body:Object):void;
	}
}