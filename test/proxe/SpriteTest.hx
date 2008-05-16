package proxe;

import neko.vm.Thread;
import haxe.Timer;
import haxe.unit.TestCase;

import proxe.Sprite;
import proxe.MockSprite;
import proxe.graphics.Graphics;
import proxe.graphics.MockGraphics;

class SpriteTest extends TestCase {
    static var SLEEP_TIME:Float = 0.1;
    var sprite:MockSprite;
    
    public function setup() {
        sprite = new MockSprite();
        sprite.graphicsClass = "proxe.graphics.MockGraphics";
    }
    
    public function tearDown() {
        sprite.stop();
    }

    ////////////////////////////////////////////////////////////////////////////
    // Default Value Tests

    public function testDefaultWidthAndHeight() {
        var s:MockSprite = new MockSprite();

        assertEquals(100, s.width);
        assertEquals(100, s.height);
    }

    public function testDefaultFramesPerSecond() {
        var s:Sprite = new Sprite();

        assertEquals(60, s.framesPerSecond);
    }

    public function testDefaultGraphicsClass() {
        var s:Sprite = new Sprite();

        assertEquals("proxe.graphics.Graphics", s.graphicsClass);
    }

    public function testDefaultLooping() {
        assertFalse(sprite.isLooping());
    }
    
    public function testFrameCount() {
        assertEquals(0, sprite.frameCount);
    }
    
    public function testScreen() {
        assertTrue(sprite.screen != null);
    }

    ////////////////////////////////////////////////////////////////////////////
    // "Structure" Tests -- http://processing.org/reference/index.html

    public function testSetupSize() {
        sprite.size(800, 600);
        
        assertEquals(800, sprite.width);
        assertEquals(600, sprite.height);
    }

    public function testSetupGraphicsWithGraphicsType() {
        sprite.size(100, 200, MOCK);

        assertTrue( sprite.graphics != null );
        assertEquals(MockGraphics, Type.getClass(sprite.graphics));
    }

    public function testSetupGraphicsWithString() {
        sprite.size(100, 200, "proxe.graphics.MockGraphics");

        assertTrue(sprite.graphics != null);
        assertEquals(MockGraphics, Type.getClass(sprite.graphics));
    }

    public function testSetupDefaultGraphics() {
        sprite.graphicsClass = "proxe.graphics.MockGraphics";
        sprite.size(100, 200);
        
        assertEquals(MockGraphics, Type.getClass(sprite.graphics));
    }

    public function testSetupNullGraphics() {
        sprite.size(100, 200);
        assertEquals(MockGraphics, Type.getClass(sprite.graphics));
    }
    
    public function testSetupUnknownGraphics() {
        try {
            sprite.size(100, 200, "Unknown Graphics");
            assertTrue(false);
        } catch (e:Dynamic) {
            assertTrue(true);
        }
        
    }

    public function testLoop() {
        var me = this;
        
        var t = Thread.create(function() {
            me.sprite.init();
        });
        
        assertTrue(sprite.isLooping());
        neko.Sys.sleep(SLEEP_TIME);
        
        sprite.stop();
        
        assertEquals(1, sprite.setupCount);
        assertTrue( sprite.drawCount > 1 );
    }
    
    public function testPauseLoop() {
        var me = this;
        
        var t = Thread.create(function() {
            me.sprite.init();
        });
        
        neko.Sys.sleep(SLEEP_TIME);
        sprite.noLoop();
        
        var drawCount = sprite.drawCount;
        assertTrue(drawCount > 1);
        neko.Sys.sleep(SLEEP_TIME);
        assertEquals(drawCount, sprite.drawCount);
    }
    
    public function testPauseAndResume() {
        var me = this;
        
        var t = Thread.create(function() {
            me.sprite.init();
        });
        
        neko.Sys.sleep(SLEEP_TIME);
        sprite.noLoop();
        
        // Pause
        var drawCount = sprite.drawCount;
        assertTrue(drawCount > 1);
        neko.Sys.sleep(SLEEP_TIME);
        assertEquals(drawCount, sprite.drawCount);
        
        // Resume
        Thread.create(function() {
            me.sprite.loop();
        });
        neko.Sys.sleep(SLEEP_TIME);
        assertTrue(drawCount < sprite.drawCount);
    }

    public function testLoopDisabledWithoutSetup() {
        assertFalse(sprite.isLooping());
        assertEquals(null, sprite.drawCount);
        assertEquals(null, sprite.setupCount);
    }
    
    public function testDelay() {
        var t = Timer.stamp();
        sprite.delay(100);
        assertTrue((Timer.stamp() - t) > 100);
    }
    
    ////////////////////////////////////////////////////////////////////////////
    // Shape Methods - 2D
    
    public function testTriangle() {
        sprite.triangle(0, 0, 0, sprite.width, sprite.height, 0);
    }
    
    public function testLine2D() {
        sprite.line(0, 0, sprite.width, sprite.height);
    }
    
    public function testLine3D() {
        sprite.line(0, 0, 10, sprite.width, sprite.height, -10);
    }
    
    public function testArc() {
        sprite.arc(
            sprite.width/2, sprite.height/2,
            sprite.width/4, sprite.height/4,
            0, Math.PI);
    }
    
    public function testPoint2D() {
        sprite.point(10, 10);
    }
    
    public function testPoint3D() {
        sprite.point(10, 10, 10);
    }
    
    public function testQuad() {
        sprite.quad(
            0, 0,
            sprite.width, 0,
            sprite.width, sprite.height,
            0, sprite.height
        );
    }
    
    public function testEllipse() {
        sprite.ellipse(10, 10, 10, 10);
    }
    
    public function testRect() {
        sprite.rect(10, 10, 10, 10);
    }
    
    public function testBeginShape() {
        sprite.beginShape();
    }
    
    public function testEndShape() {
        sprite.endShape();
    }
    
    public function testVertex() {
        sprite.vertex(1, 2);
    }
    
    public function testBezierVertex() {
        sprite.bezierVertex(1, 2, 3, 4, 5, 6, 7, 8, 9);
    }
    
    public function testCurveVertex() {
        sprite.curveVertex(10, 10);
        sprite.curveVertex(10, 10, 10);
    }
}
