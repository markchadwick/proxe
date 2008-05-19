package proxe.graphics;

import flash.Lib;
import flash.display.MovieClip;

import proxe.Applet;
import proxe.Color;
import proxe.Vertex;
import proxe.graphics.Graphics;

class FlashGraphics extends Graphics {
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

    public function drawVertices() {
        if(currentShapeClosingType == CLOSE && !fillColor.equals(Color.NONE)) {
            graphics.beginFill(rgb(fillColor), alpha(fillColor));
        }

        if(!strokeColor.equals(Color.NONE)) {
            graphics.lineStyle(strokeWidth, rgb(strokeColor), alpha(strokeColor));
        } else {
            graphics.lineStyle();
        }
        
        var vertsDrawn:Int = 0;
        
        for(vertex in vertices) {
            if(vertsDrawn == 0) {
                graphics.moveTo(vertex.x, vertex.y);
            } else {
                graphics.lineTo(vertex.x, vertex.y);
            }
            vertsDrawn++;
        }
        
        graphics.endFill();
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
    
    private inline function rgb(color:Color):Int {
        return (color.red << 16) | (color.green << 8) | color.blue;
    }
    
    private inline function alpha(color:Color) : Float {
        return cast(color.alpha, Float)/255.0;
    }
}