package proxe;

import haxe.unit.TestCase;

import proxe.Color;

class ColorTest extends TestCase {
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
    
    public function testResolveColorBoundries() {
        var color = Color.resolve(-1000, 1000, 0, 255);
        
        assertEquals(0, color.red);
        assertEquals(255, color.green);
        assertEquals(0, color.blue);
        assertEquals(255, color.alpha);
    }
}