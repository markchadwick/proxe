package proxe.graphics;

import flash.MovieClip;

import proxe.graphics.Graphics;

class FlashGraphics extends Graphics {
    private var flash:MovieClip;
    private var shapeVerts:Int;
    
    private var fillColor:Int;
    private var strokeColor:Int;
    
    public function new() {
        super();
        flash = flash.Lib.current;
    }
    
    public function beginShape(fillColor:Int, strokeColor:Int) {
        this.fillColor = fillColor;
        this.strokeColor = strokeColor;
        
        flash.beginFill(fillColor, 90);
        shapeVerts = 0;
    }
    
    public function vertex(x:Int, y:Int, ?z:Int) {
        if(shapeVerts == 0) {
            flash.moveTo(x, y);
        } else {
            flash.lineTo(x, y);
        }
        shapeVerts++;
    }
    
    public function endShape() {
        flash.endFill();
    }
}
