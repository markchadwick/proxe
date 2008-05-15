package proxe;

import haxe.unit.TestCase;

import proxe.Color;

class ColorTest extends TestCase {
    public var color:Canvas;
    
    public function setup() {
        color = new Color();
    }

    ////////////////////////////////////////////////////////////////////////////
    // Color Tests

    /**
     * RGBA colors should be packed into a single integer in the style:
     *  0xAARRGGBB
     */
    public function testPackColor() {
        var c:Int;
        
        c = Color.pack(255, 0, 0, 0);
        assertEquals(0x00ff0000, c);
        
        c = Color.pack(0, 255, 0, 0);
        assertEquals(0x0000ff00, c);
        
        c = Color.pack(0, 0, 255, 0);
        assertEquals(0x000000ff, c);
        
        c = Color.pack(0, 0, 0, 255);
        assertEquals(0xff000000, c);
    }

    /**
     * When encountering a value more than 255 for a parameter, `packColor`
     * should limit the value to 255.
     */
    public function testPackColorOverflow() {
        var c:Int;
        
        c = Color.pack(1000, 0, 0, 0);
        assertEquals(0x00ff0000, c);
        
        c = Color.pack(0, 1000, 0, 0);
        assertEquals(0x0000ff00, c);
        
        c = Color.pack(0, 0, 1000, 0);
        assertEquals(0x000000ff, c);
        
        c = Color.pack(0, 0, 0, 1000);
        assertEquals(0xff000000, c);
    }
    
    
    /**
     * When encountering a number less than 0 for a parameter, 'packColor`
     * should raise the value to 0
     */
    public function testPackColorUnderflow() {
        var c:Int;
        
        c = Color.pack(-1, 255, 255, 255);
        assertEquals(0xff00ffff, c);
        
        c = Color.pack(255, -1, 255, 255);
        assertEquals(0xffff00ff, c);
        
        c = Color.pack(255, 255, -1, 255);
        assertEquals(0xffffff00, c);
        
        c = Color.pack(255, 255, 255, -1);
        assertEquals(0x00ffffff, c);
    }

    /**
     * When `resolveColor` is passed a single param, it should be the grayscale
     * value with 100% opacity
     */
    public function testResolveColorOneParam() {
        var c:Int;
        
        c = Color.resolve(0);
        assertEquals(0xff000000, c);
        
        c = Color.resolve(255);
        assertEquals(0xffffffff, c);
        
        c = Color.resolve(128);
        assertEquals(0xff808080, c);
        
        c = Color.resolve(1000);
        assertEquals(0xffffffff, c);
        
        c = Color.resolve(-10);
        assertEquals(0xff000000, c);
    }
    
    /**
     * When `resolveColor` is passed two parameters, it should return the
     * grayscale value, with the second paramter as alpha
     */
    public function testResolveColorTwoParams() {
        var c:Int;
        
        c = Color.resolve(255, 255);
        assertEquals(0xffffffff, c);
        
        c = Color.resolve(255, 128);
        assertEquals(0x80ffffff, c);
        
        c = Color.resolve(0, 0);
        assertEquals(0x00000000, c);
        
        c = Color.resolve(1000, -1);
        assertEquals(0x00ffffff, c);
    }
    
    /**
     * When `resolveColor` is passed three parameters, it should return the
     * RGB value of those three colors, with alpha at 100%
     */
    public function testResolveColorThreeParameters() {
        var c:Int;
        
        c = Color.resolve(255, 0, 0);
        assertEquals(0xffff0000, c);
        
        c = Color.resolve(0, 255, 0);
        assertEquals(0xff00ff00, c);
        
        c = Color.resolve(0, 0, 255);
        assertEquals(0xff0000ff, c);
        
        c = Color.resolve(-1, 128, 1000);
        assertEquals(0xff0080ff, c);
    }
    
    /**
     * When `resolveCOlor` is passed four parameters, it should return the
     * straight RGBA as defined in `packColor`
     */
    public function testResolveColorFourParameters() {
        var c:Int;
        
        c = Color.resolve(255, 0, 0, 0);
        assertEquals(0x00ff0000, c);
        
        c = Color.resolve(0, 255, 0, 0);
        assertEquals(0x0000ff00, c);
        
        c = Color.resolve(0, 0, 255, 0);
        assertEquals(0x000000ff, c);
        
        c = Color.resolve(0, 0, 0, 255);
        assertEquals(0xff000000, c);
        
        c = Color.resolve(-1, 1000, 0, 128);
        assertEquals(0x8000ff00, c);
    }
     
    public function testRed() : Void {
         assertEquals(0,   Color.red(0x00000000));
         assertEquals(255, Color.red(0x00ff0000));
         assertEquals(128, Color.red(0x00800000));
     }
     
    public function testGreen() : Void {
         assertEquals(0,   Color.green(0x00000000));
         assertEquals(255, Color.green(0x0000ff00));
         assertEquals(128, Color.green(0x00008000));
     }

     public function testBlue() : Void {
         assertEquals(0,   Color.blue(0x00000000));
         assertEquals(255, Color.blue(0x000000ff));
         assertEquals(128, Color.blue(0x00000080));
     }
     
     public function testAlpha() : Void {
         assertEquals(0,   Color.alpha(0x00000000));
         assertEquals(255, Color.alpha(0xff000000));
         assertEquals(128, Color.alpha(0x80000000));
         
         var c:Int;
         c = 0x00000080;
         assertEquals(128, c);
         
         c <<= 24;
         assertEquals(128, (c >> 24));
     }
     
     public function testUnsignedBitShifting() : Void {
         var b:Int;
         b = 0x00000080;
         
         assertEquals(128, b);
         
         for(shift in [0, 8, 16, 24]) {
             var i:Int;
             i = (b << shift);
             assertEquals(b, (i >> shift));
         }
     }   
}
