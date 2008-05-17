package proxe.graphics;

import flash.Lib;
import flash.display.MovieClip;

import proxe.Color;
import proxe.Sprite;
import proxe.graphics.Graphics;

class FlashGraphics extends Graphics {
    private var flash:MovieClip;
    private var graphics : flash.display.Graphics;
 
    private var sprite:Sprite;
    
    public function new(sprite:Sprite) {
        this.sprite = sprite;
        
        flash = createMovieClip();
        graphics = flash.graphics;
    }
    
    /**
     * TODO: closures would be perfect here for restoring state variables
     * TODO: Actual Width and Height
     */
    public function background(backgroundColor:Color) {
        graphics.clear();
        
        var origFillColor:Color = this.fillColor;
        var origStrokeColor:Color = this.strokeColor;
        
        strokeColor = Color.NONE;
        fillColor = backgroundColor;
        rect(-1, -1, 401, 301);
        
        fillColor = origFillColor;
        strokeColor = origStrokeColor;
    }

    public function drawVertices(verticies:Array<Array<Float>>,
        openShapeType:ShapeType, closeShapeType:ShapeClosingType) {

        if(closeShapeType == CLOSE && !fillColor.equals(Color.NONE)) {
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
                graphics.moveTo(vertex[0], vertex[1]);
            } else {
                graphics.lineTo(vertex[0], vertex[1]);
            }
            vertsDrawn++;
        }

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
