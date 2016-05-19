/*
Feathers
Copyright 2012-2016 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.core
{
	/**
	 * If a Feathers component may receive focus, it may be associated with a
	 * display object on the native stage. The focus manager will automatically
	 * pass focus to the native focus.
	 * 
	 * @see ../../../help/focus.html
	 */
	public interface INativeFocusOwner extends IFocusDisplayObject
	{
		/**
		 * A display object on the native stage that is given focus when this
		 * Feathers display object is given focus by a focus manager.
		 * 
		 * <p>This property may return <code>null</code>. When it returns
		 * <code>null</code>, the focus manager should treat this display object
		 * like any other display object that may receive focus but doesn't
		 * implement <code>INativeFocusOwner</code>.</p>
		 * 
		 * <p>This property must return a
		 * <code>flash.display.InteractiveObject</code> or an object with an
		 * <code>assignFocus()</code> public method.</p>
		 */
		function get nativeFocus():Object;
	}
}
