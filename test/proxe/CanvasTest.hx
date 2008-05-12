package proxe;

import haxe.unit.TestCase;

import proxe.Canvas;

class CanvasTest extends TestCase {
    public var canvas:Canvas;
    
    public function setup() {
        canvas = new Canvas();
    }

    ////////////////////////////////////////////////////////////////////////////
    // Color Tests

    /**
     * RGBA colors should be packed into a single integer in the style:
     *  0xAARRGGBB
     */
    public function testPackColor() {
        var c:Int;
        
        c = canvas.packColor(255, 0, 0, 0);
        assertEquals(0x00ff0000, c);
        
        c = canvas.packColor(0, 255, 0, 0);
        assertEquals(0x0000ff00, c);
        
        c = canvas.packColor(0, 0, 255, 0);
        assertEquals(0x000000ff, c);
        
        c = canvas.packColor(0, 0, 0, 255);
        assertEquals(0xff000000, c);
    }

    /**
     * When encountering a value more than 255 for a parameter, `packColor`
     * should limit the value to 255.
     */
    public function testPackColorOverflow() {
        var c:Int;
        
        c = canvas.packColor(1000, 0, 0, 0);
        assertEquals(0x00ff0000, c);
        
        c = canvas.packColor(0, 1000, 0, 0);
        assertEquals(0x0000ff00, c);
        
        c = canvas.packColor(0, 0, 1000, 0);
        assertEquals(0x000000ff, c);
        
        c = canvas.packColor(0, 0, 0, 1000);
        assertEquals(0xff000000, c);
    }
    
    
    /**
     * When encountering a number less than 0 for a parameter, 'packColor`
     * should raise the value to 0
     */
    public function testPackColorUnderflow() {
        var c:Int;
        
        c = canvas.packColor(-1, 255, 255, 255);
        assertEquals(0xff00ffff, c);
        
        c = canvas.packColor(255, -1, 255, 255);
        assertEquals(0xffff00ff, c);
        
        c = canvas.packColor(255, 255, -1, 255);
        assertEquals(0xffffff00, c);
        
        c = canvas.packColor(255, 255, 255, -1);
        assertEquals(0x00ffffff, c);
    }

    /**
     * When `resolveColor` is passed a single param, it should be the grayscale
     * value with 100% opacity
     */
    public function testResolveColorOneParam() {
        var c:Int;
        
        c = canvas.resolveColor(0);
        assertEquals(0xff000000, c);
        
        c = canvas.resolveColor(255);
        assertEquals(0xffffffff, c);
        
        c = canvas.resolveColor(128);
        assertEquals(0xff808080, c);
        
        c = canvas.resolveColor(1000);
        assertEquals(0xffffffff, c);
        
        c = canvas.resolveColor(-10);
        assertEquals(0xff000000, c);
    }
    
    /**
     * When `resolveColor` is passed two parameters, it should return the
     * grayscale value, with the second paramter as alpha
     */
    public function testResolveColorTwoParams() {
        var c:Int;
        
        c = canvas.resolveColor(255, 255);
        assertEquals(0xffffffff, c);
        
        c = canvas.resolveColor(255, 128);
        assertEquals(0x80ffffff, c);
        
        c = canvas.resolveColor(0, 0);
        assertEquals(0x00000000, c);
        
        c = canvas.resolveColor(1000, -1);
        assertEquals(0x00ffffff, c);
    }
    
    /**
     * When `resolveColor` is passed three parameters, it should return the
     * RGB value of those three colors, with alpha at 100%
     */
    public function testResolveColorThreeParameters() {
        var c:Int;
        
        c = canvas.resolveColor(255, 0, 0);
        assertEquals(0xffff0000, c);
        
        c = canvas.resolveColor(0, 255, 0);
        assertEquals(0xff00ff00, c);
        
        c = canvas.resolveColor(0, 0, 255);
        assertEquals(0xff0000ff, c);
        
        c = canvas.resolveColor(-1, 128, 1000);
        assertEquals(0xff0080ff, c);
    }
    
    /**
     * When `resolveCOlor` is passed four parameters, it should return the
     * straight RGBA as defined in `packColor`
     */
    public function testResolveColorFourParameters() {
        var c:Int;
        
        c = canvas.resolveColor(255, 0, 0, 0);
        assertEquals(0x00ff0000, c);
        
        c = canvas.resolveColor(0, 255, 0, 0);
        assertEquals(0x0000ff00, c);
        
        c = canvas.resolveColor(0, 0, 255, 0);
        assertEquals(0x000000ff, c);
        
        c = canvas.resolveColor(0, 0, 0, 255);
        assertEquals(0xff000000, c);
        
        c = canvas.resolveColor(-1, 1000, 0, 128);
        assertEquals(0x8000ff00, c);
    }
     
    public function testRed() : Void {
         assertEquals(0,   canvas.red(0x00000000));
         assertEquals(255, canvas.red(0x00ff0000));
         assertEquals(128, canvas.red(0x00800000));
     }
     
    public function testGreen() : Void {
         assertEquals(0,   canvas.green(0x00000000));
         assertEquals(255, canvas.green(0x0000ff00));
         assertEquals(128, canvas.green(0x00008000));
     }

     public function testBlue() : Void {
         assertEquals(0,   canvas.blue(0x00000000));
         assertEquals(255, canvas.blue(0x000000ff));
         assertEquals(128, canvas.blue(0x00000080));
     }
     
     public function testAlpha() : Void {
         assertEquals(0,   canvas.alpha(0x00000000));
         assertEquals(255, canvas.alpha(0xff000000));
         //assertEquals(128, canvas.alpha(0x80000000));
         
         //var c:Int;
         //c = 0x00000080;
         //assertEquals(128, c);
         
         //c <<= 24;
         //assertEquals(128, (c >> 24));
     }
     
     //public function testUnsignedBitShifting() : Void {
         //var b:Int;
         //b = 0x00000080;
         
         //assertEquals(128, b);
         
         //for(shift in [0, 8, 16, 24]) {
             //var i:Int;
             //i = (b << shift);
             //assertEquals(b, (i >> shift));
         //}
     //}   
}
