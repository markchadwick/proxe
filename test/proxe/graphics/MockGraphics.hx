package proxe.graphics;

import proxe.Sprite;
import proxe.graphics.Graphics;


class MockGraphics extends Graphics {
    public var sprite:Sprite;

    public var width:Int;
    public var height:Int;

    public function new(sprite:Sprite, width:Int, height:int) {
        this.sprite = sprite;
        this.width = width;
        this.height = height;
    }

    ////////////////////////////////////////////////////////////////////////////
    // Permission-busters

    public function getVertices() : Array<Array<Float>> {
        return vertices;
    }

    public function drawVertices(verticies:Array<Array<Float>>,
        openShapeType:ShapeType, closeShapeType:ShapeClosingType) {

        
    }
}
