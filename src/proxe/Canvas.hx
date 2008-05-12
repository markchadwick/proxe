package proxe;

import flash.display.Sprite;

import proxe.graphics.Graphics;
import proxe.graphics.FlashGraphics;


class Canvas extends flash.display.Sprite {
    ////////////////////////////////////////////////////////////////////////////
    // Fields
    private var graphics:FlashGraphics;
    
    private var fillColor:Int;
    private var strokeColor:Int;
    
    ////////////////////////////////////////////////////////////////////////////
    // Constructor
    
    /**
     * Default Constructor
     * TODO: Take a renderer
     */
    public function new() {
        graphics = new FlashGraphics();
        
        fillColor = resolveColor(128);
        strokeColor = resolveColor(0);
        
        this.addEventListener(Event.ENTER_FRAME, draw);
        
    }

    public function start() {
        //draw();
    }

    public function draw() {
    }

    ////////////////////////////////////////////////////////////////////////////
    // Drawing Methods
    
    public function rect(topLeft:Array<Int>, bottomRight:Array<Int>) : Void {
        graphics.beginShape(fillColor, strokeColor);
        
        graphics.vertex(topLeft[0],     topLeft[1]);
        graphics.vertex(bottomRight[0], topLeft[1]);
        graphics.vertex(bottomRight[0], bottomRight[1]);
        graphics.vertex(topLeft[0],     bottomRight[1]);
        
        graphics.endShape();
    }

    ////////////////////////////////////////////////////////////////////////////
    // Color Methods
    
    public function fill(r:Int, ?g:Int, ?b:Int, ?a:Int) : Void {
        fillColor = resolveColor(r, g, b, a);
    }
    
    /**
     * Red channel component of a packed color integer
     */
    public function red(r:Int) : Int {
        return graphics.red(r);
    }
    
    /**
     * Green channel component of a packed color integer
     */
    public function green(g:Int) : Int {
        return graphics.green(g);
    }
    
    /**
     * Blue channel component of a packed color integer
     */
    public function blue(b:Int) : Int {
        return graphics.blue(b);
    }
    
    /**
     * Alpha channel component of a packed color integer
     */
    public function alpha(a:Int) : Int {
        return graphics.alpha(a);
    }
    
    /**
     * Takes four integers from 0-255, and packs them into a single integer.
     * If any of the given parameters is less than zero, it will cast it to
     * exactly zero.  If one of the parameters is above 255, it will case it to
     * exactly 255.
     *
     * The layout of the packed integer are as follows:
     *
     *  (2 bytes alpha) (2 bytes red) (2 bytes green) (2 bytes blue)
     *
     * Some examples of given RGBA parameters, and the resulting packed integer:
     *
     *  (r:0, g:0, b:0, a:255)      => 0xff000000
     *  (r:255, g:0, b:0, a:0)      => 0x00ff0000
     *  (r:0, g:255, b:0, a:255)    => 0xff00ff00
     *  (r:255, g:-1, b:1000, a:128)=> 0x80ff00ff
     */
    public function packColor(r:Int, g:Int, b:Int, a:Int) : Int {
        r = (r < 0) ? 0 : (r > 255) ? 255 : r;
        g = (g < 0) ? 0 : (g > 255) ? 255 : g;
        b = (b < 0) ? 0 : (b > 255) ? 255 : b;
        a = (a < 0) ? 0 : (a > 255) ? 255 : a;
        
        return (a << 24) | (r << 16) | (g << 8) | b;
    }
    
    /**
     * Resolves a semi-variable list of integers from 0-255 into a single,
     * packed integer.  There are four different way to call this method.
     *
     *  resolveColor(gray)
     *  resolveColor(gray, alpha)
     *  resolveColor(red, green, blue)
     *  resolveColor(red, green, blue, alpha)
     */
    public function resolveColor(r:Int, ?g:Int, ?b:Int, ?a:Int) : Int {
        if(a == null) {
            if(b == null) {
                if(g == null) {
                    return packColor(r, r, r, 255);
                }
                return packColor(r, r, r, g);
            }
            return packColor(r, g, b, 255);
        }
        return packColor(r, g, b, a);
    }
}
