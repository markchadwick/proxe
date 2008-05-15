package proxe.graphics;

import flash.Lib;
import flash.display.MovieClip;

import proxe.Color;
import proxe.graphics.Graphics;

class FlashGraphics extends Graphics {
    private var flash:MovieClip;
    private var graphics : flash.display.Graphics;
    
    private var shapeVerts:Int;
    
    public var fillColor:Color;
    public var strokeColor:Color;
    public var strokeWeight:Float;
    
    public function new() {
        super();
        
        flash = createMovieClip();
        graphics = flash.graphics;
    }
    
    /**
     * TODO: closures would be perfect here for restoring state variables
     */
    public function background(backgroundColor:Color) {
        graphics.clear();
        
        var origFillColor:Color = this.fillColor;
        var origStrokeColor:Color = this.strokeColor;
        
        fillColor = backgroundColor;
        rect(0, 0, 400, 300);
        
        fillColor = origFillColor;
        strokeColor = origStrokeColor;
    }
    
    public function rect(x:Float, y:Float, width:Float, height:Float) {
        graphics.lineStyle(1, 0x000000);
        graphics.beginFill(rgb(fillColor), alpha(fillColor));
        graphics.drawRect(x, y, width, height);
        graphics.endFill();
    }
    

    private function createMovieClip(?parent:MovieClip) : MovieClip {
        if(parent == null) {
            parent = Lib.current;
        }
        var mc:MovieClip = new MovieClip();
        parent.addChild(mc);
        return mc;
    }
    
    
    private inline function rgb(color:Color):Int {
        return (color.red << 16) | (color.green << 8) | color.blue;
    }
    
    private inline function alpha(color:Color) : Float {
        return cast(color.alpha, Float)/255.0;
    }
}
