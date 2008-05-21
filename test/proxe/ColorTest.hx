package proxe;

import haxe.unit.TestCase;

import proxe.Color;

class ColorTest extends TestCase {
    ////////////////////////////////////////////////////////////////////////////
    // Constructor Tests

    public function testConstructorColorBoundries() {
        var color = new Color(-1000, 1000, 0, 255);
        
        assertEquals(0, color.red);
        assertEquals(255, color.green);
        assertEquals(0, color.blue);
        assertEquals(255, color.alpha);
    }

    public function testConstructorMaxColorRanges() {
        var color = new Color(10, 10, 10, 10,
                              20, 20, 20, 20);
        
        assertEquals(127, color.red);
        assertEquals(127, color.green);
        assertEquals(127, color.blue);
        assertEquals(127, color.alpha);
    }

    ////////////////////////////////////////////////////////////////////////////
    // Resolution Tests
    
    public function testResolveOneParam() {
        var color = Color.resolve(100);
        
        assertEquals(100, color.red);
        assertEquals(100, color.green);
        assertEquals(100, color.blue);
        assertEquals(255, color.alpha);
    }
    
    public function testResolveTwoParams() {
        var color = Color.resolve(200, 50);
        
        assertEquals(200, color.red);
        assertEquals(200, color.green);
        assertEquals(200, color.blue);
        assertEquals(50, color.alpha);
    }
    
    public function testResolveThreeParams() {
        var color = Color.resolve(10, 100, 200);
        
        assertEquals(10, color.red);
        assertEquals(100, color.green);
        assertEquals(200, color.blue);
        assertEquals(255, color.alpha);
    }
    
    public function testResolveFourParams() {
        var color = Color.resolve(10, 20, 30, 40);
        
        assertEquals(10, color.red);
        assertEquals(20, color.green);
        assertEquals(30, color.blue);
        assertEquals(40, color.alpha);
    }
    
    public function testResolveSimpleHSVColor() {
        // Note: These tests will actual pass without a HSV implementation
        
        var color = Color.resolve(0, 0, 0, 0, HSV);
        assertEquals(0, color.red);
        assertEquals(0, color.green);
        assertEquals(0, color.blue);
        assertEquals(0, color.alpha);
        
        var color = Color.resolve(255, 255, 255, 255, HSV);
        assertEquals(255, color.red);
        assertEquals(255, color.green);
        assertEquals(255, color.blue);
        assertEquals(255, color.alpha);
    }
    
    public function testResolveHSVColor() {
        var color = Color.resolve(10, 20, 255, 255, HSV);
        assertEquals(255, color.red);
        assertEquals(255, color.green);
        assertEquals(255, color.blue);
        assertEquals(255, color.alpha);
        
        color = Color.resolve(10, 20, 0, 255, HSV);
        assertEquals(0, color.red);
        assertEquals(0, color.green);
        assertEquals(0, color.blue);
        assertEquals(0, color.alpha);
    }
}