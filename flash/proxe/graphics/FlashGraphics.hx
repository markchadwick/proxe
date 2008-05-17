package proxe.graphics;

import flash.Lib;
import flash.events.Event;
import flash.display.MovieClip;

import proxe.Color;
import proxe.Sprite;
import proxe.graphics.Graphics;

class FlashGraphics extends Graphics {
    private var flash:MovieClip;
    private var graphics : flash.display.Graphics;
 
    private var sprite:Sprite;

    private var width:Int;
    private var height:Int;
    
    public function new(sprite:Sprite, width:Int, height:Int) {
        this.sprite = sprite;

        this.width = width;
        this.height = height;
        
        flash = createMovieClip(width, height);
        graphics = flash.graphics;
    }

    public function play() {
        var me = this;
        flash.Lib.current.addEventListener(Event.ENTER_FRAME, function(_) {
            me.sprite.draw();
        });
        flash.play();
    }

    public function stop() {
        flash.stop();
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

        rect(0, 0, width, height);
        
        fillColor = origFillColor;
        strokeColor = origStrokeColor;
    }

    public function drawEllipse(x:Float, y:Float, width:Float, height:Float) {
        if(!fillColor.equals(Color.NONE)) {
            graphics.beginFill(rgb(fillColor), alpha(fillColor));
        }

        if(!strokeColor.equals(Color.NONE)) {
            graphics.lineStyle(strokeWidth, rgb(strokeColor), alpha(strokeColor));
        } else {
            graphics.lineStyle();
        }

        graphics.drawEllipse(x, y, width, height);
        graphics.endFill();
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

    public function point(x:Float, y:Float, ?z:Float) {
        var oldFill:Color = fillColor;
        var oldStroke:Color = strokeColor;

        fillColor = strokeColor;
        strokeColor = Color.NONE;
        rect(x, y, 1, 1);

        fillColor = oldFill;
        strokeColor = oldStroke;
    }
    

    private function createMovieClip(width:Int, height:Int, ?parent:MovieClip) : MovieClip {
        if(parent == null) {
            parent = Lib.current;
        }
        var mc:MovieClip = new MovieClip();
        //mc.width = width;
        //mc.height = height;
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
