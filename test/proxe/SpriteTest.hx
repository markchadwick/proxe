package proxe;

import neko.vm.Thread;
import haxe.unit.TestCase;

import proxe.Sprite;
import proxe.MockSprite;
import proxe.graphics.Graphics;
import proxe.graphics.MockGraphics;

class SpriteTest extends TestCase {

    var sprite:MockSprite;
    
    public function setup() {
        sprite = new MockSprite();
        sprite.graphicsClass = "proxe.graphics.MockGraphics";
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

    public function testLoop() {
        var me = this;
        Thread.create(function() {
            me.sprite.init();
            me.assertTrue(me.sprite.isLooping());
        }, 1000);
        
        sprite.stop();
        
        assertEquals(1, sprite.setupCount);
        assertTrue( sprite.drawCount > 1 );
        trace("Drew "+ sprite.drawCount +" Frames!");
    }

    public function testLoopDisabledWithoutSetup() {
        assertEquals(null, sprite.drawCount);
        assertEquals(null, sprite.setupCount);
    }
}
