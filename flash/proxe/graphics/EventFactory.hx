package proxe.graphics;

import proxe.Applet;

class EventFactory {

    public static function bindEvents(applet:Applet) {
        flash.Lib.current.stage.addEventListener(
            MouseEvent.MOUSE_MOVE,
            applet.mouseMovedEvent);
            
		flash.Lib.current.stage.addEventListener(
            MouseEvent.MOUSE_DOWN,
            applet.mousePressedEvent);
            
		flash.Lib.current.stage.addEventListener(
            MouseEvent.MOUSE_UP,
            applet.mouseReleasedEvent);
            
		flash.Lib.current.stage.addEventListener(
            KeyboardEvent.KEY_DOWN,
            applet.keyTypedEvent); 
            
		flash.Lib.current.stage.addEventListener(
            KeyboardEvent.KEY_UP,
            applet.keyReleasedEvent); 
    }
}