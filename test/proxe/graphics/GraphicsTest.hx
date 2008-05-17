package proxe.graphics;

import haxe.unit.TestCase;

import proxe.Sprite;
import proxe.graphics.Graphics;
import proxe.graphics.MockGraphics;


class GraphicsTest extends TestCase {

    var sprite:Sprite;
    var graphics:MockGraphics;

    var width:Int;
    var height:Int;

    public function setup() {
        width = 100;
        height = 100;
        
        sprite = new Sprite();
        sprite.size(width, height, MOCK);

        graphics = cast(sprite.graphics, MockGraphics);
    }

    ////////////////////////////////////////////////////////////////////////////
    // Vertex Methods

    public function testBeginShapeCurrentGraphicsType() {
        graphics.beginShape(LINES);
        assertEquals(LINES, graphics.currentShapeType);
    }

    public function testBeginShapeNoType() {
        graphics.beginShape();
        assertEquals(POLYGON, graphics.currentShapeType);
    }

    public function testBeginShapeNestingFails() {
        graphics.beginShape();

        try {
            graphics.beginShape();
        } catch (e:Dynamic) {
            assertTrue(true);
            return;
        }

        assertTrue(false);
    }

    public function testEndShapeOrphanFails() {
        try {
            graphics.endShape();
        } catch (e:Dynamic) {
            assertTrue(true);
            return;
        }
        
        assertTrue(false);
    }

    public function testVertexDepthSimple() {
        graphics.beginShape(POINTS);
        assertEquals(0, graphics.vertexDepth);

        graphics.vertex(10, 10);
        assertEquals(1, graphics.vertexDepth);

        graphics.vertex(20, 20);
        assertEquals(2, graphics.vertexDepth);

        graphics.endShape();
        assertEquals(0, graphics.vertexDepth);
    }

    public function testEndShapePoints() {
        graphics.beginShape(POINTS);
        graphics.vertex(0, 0);
        graphics.vertex(width, 0);
        graphics.vertex(width, height);
        graphics.vertex(0, height);
        graphics.endShape();

        assertEquals(4, graphics.getVertices().length);
    }
   

    ////////////////////////////////////////////////////////////////////////////
    // Shape Methods

    public function testTriangle() {
        graphics.triangle(0, 0,
            width, 0,
            0, height);

        assertEquals(4, graphics.getVertices().length);
    }
}
