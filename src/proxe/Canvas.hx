package proxe;

import flash.Lib;
import flash.events.Event;

import proxe.Color;
import proxe.graphics.Graphics;
import proxe.graphics.FlashGraphics;

class Canvas {
    
    public var width:Int;
    public var height:Int;
    
    ////////////////////////////////////////////////////////////////////////////
    // Fields
    private var graphics:FlashGraphics;
    
    private var fillColor:Color;
    private var strokeColor:Color;
    private var strokeWeight:Float;
    
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
        strokeWeight = 1;
        
        width = 400;
        height = 300;
        
        flash.Lib.current.addEventListener(Event.ENTER_FRAME, draw);
        
        setup();
        draw();
    }
    
    public function setup() : Void {
        trace("missing setup!");
    }
    
    public function draw(?_) : Void {

    }

    public function push(f:Int) {
    }

    ////////////////////////////////////////////////////////////////////////////
    // Drawing Methods
    
    public function background(r, ?g, ?b, ?a) : Void {
        graphics.background(Color.resolve(r, g, b, a));
    }
    
    public function rect(topLeft:Array<Float>, bottomRight:Array<Float>) : Void {
        graphics.rect(topLeft[0], topLeft[1], bottomRight[0], bottomRight[1]);
    }
    
    
    ////////////////////////////////////////////////////////////////////////////
    // Random Methods
    
    public function random(?low:Float, ?high:Float) : Void {
    }

    ////////////////////////////////////////////////////////////////////////////
    // Color Methods
    
    public function fill(r:Int, ?g:Int, ?b:Int, ?a:Int) : Void {
        fillColor = Color.resolve(r, g, b, a);
        graphics.fillColor = fillColor;
    }
    
    public function noFill() : Void {
        fillColor = Color.NONE;
        graphics.fillColor = Color.NONE;
    }
    
    public function stroke(r:Int, ?g:Int, ?b:Int, a:Int) : Void {
        strokeColor = Color.resolve(r, g, b, a);
        graphics.fillColor = strokeColor;
    }
    
    public function noStroke() : Void {
        strokeColor = Color.NONE;
        graphics.strokeColor = Color.NONE;
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
    public function resolveColor(r:Int, ?g:Int, ?b:Int, ?a:Int) : Color {
        return new Color(r, g, b, a);
    }
}
