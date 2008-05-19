package proxe.graphics;

import flash.Lib;
import flash.display.MovieClip;

import proxe.Applet;
import proxe.graphics.Graphics3D;

class FlashGraphics extends Graphics3D {

    private var flash:MovieClip;
    private var graphics:flash.display.Graphics;

    public function new(width:Int, height:Int, applet:Applet, ?path:String) {
        this.width = width;
        this.height = height;
        
        this.parent = applet;
        
        createMovie(width, height);
        
        defaults();
    }

    /**
     * Clears the current drawing surface
     */
    public function clear() {
        graphics.clear();
    }

    ////////////////////////////////////////////////////////////////////////////
    // Private Methods
    
    private function createMovie(width:Int, height:Int, ?parent:MovieClip) {
        if(parent == null) {
            parent = Lib.current;
        }
        
        flash = new MovieClip();
        parent.addChild(flash);
        
        graphics = flash.graphics;
    }
}
