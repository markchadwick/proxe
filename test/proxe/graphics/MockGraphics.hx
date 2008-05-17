package proxe.graphics;

import proxe.Sprite;
import proxe.graphics.Graphics;


class MockGraphics extends Graphics {
    public var sprite:Sprite;

    public function new(sprite:Sprite) {
        this.sprite = sprite;
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
