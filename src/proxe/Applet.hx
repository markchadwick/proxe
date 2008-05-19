package proxe;

import proxe.Color;
import proxe.graphics.Graphics;
import proxe.graphics.GraphicsFactory;

class Applet {
    
    ////////////////////////////////////////////////////////////////////////////
    // Instance Fields
    
    /**
     * Width the current applet
     *
     * @todo implement getter (no setter)
     */
    public var width:Int;

    /**
     * Height of the current applet
     *
     * @todo implement getter (no setter)
     */
    public var height:Int;
    
    
    /**
     * Path, if any, of the current Graphics
     */
    public var path:String;
    
    /**
     * Current Graphics renderer.
     *
     * @todo implement "g" getter for Processing compatability
     */
    public var graphics:Graphics;
    
    
    public var mouseX:Float;
    public var mouseY:Float;
    
    /**
     * Default Constructor
     */
    public function new() {
    }
    
    public function init() {
        setup();
        
        if(graphics.looping) {
            loop();
        } else {
            draw();
        }
    }
    
    public function setup() { }
    public function draw() { }
    public function mousePressed() { }
    
    ////////////////////////////////////////////////////////////////////////////
    // Setup Methods
    
    /**
     * Initializes this Applet with a new graphics layer of the given size.  If
     * no renderer is given, `GraphicsFactory` will choose the the best option
     * for the current compilation settings.
     */
    public function size(width:Int, height:Int, ?renderer:String, ?path:String) {
        this.width = width;
        this.height = height;
        
        this.graphics = GraphicsFactory.newInstance(width, height, renderer,
                                                    path, this);
        this.path = graphics.path;
    }

    public function loop() {
        graphics.loop();
    }
    
    public function noLoop() {
        graphics.noLoop();
    }
    
    public function frameRate(frameRate:Float) {
        graphics.frameRate(frameRate);
    }
    
    public function redraw() {
        graphics.redraw();
    }

    ////////////////////////////////////////////////////////////////////////////
    // Color Methods
    public function fill(red:Int, ?green:Int, ?blue:Int, ?alpha:Int) {
        var color:Color = Color.resolve(red, green, blue, alpha);
        graphics.fill(color);
    }
    
    public function noFill() {
        graphics.fill(Color.NONE);
    }
    
    public function stroke(red:Int, ?green:Int, ?blue:Int, ?alpha:Int) {
        var color:Color = Color.resolve(red, green, blue, alpha);
        graphics.stroke(color);
    }
    
    public function noStroke() {
        graphics.stroke(Color.NONE);
    }
    
    public function point(x:Float, y:Float, ?z:Float) {
        graphics.point(new Vertex(x, y, z));
    }
    
    
    ////////////////////////////////////////////////////////////////////////////
    // Drawing Methods
    
    public function background(red:Int, ?green:Int, ?blue:Int, ?alpha:Int) {
        var color:Color = Color.resolve(red, green, blue, alpha);
        graphics.background(color);
    }
    
    public function rect(x1:Float, y1:Float, x2:Float, y2:Float) {
        graphics.rect(new Vertex(x1, y1),
                      new Vertex(x2, y2));
    }
    
    public function line(x1:Float, y1:Float, z1:Float, x2:Float, ?y2:Float, ?z2:Float) {
        if(y2 == null) {
            graphics.line(new Vertex(x1, y1), new Vertex(z1, x2));
        } else {
            graphics.line(new Vertex(x1, y1, z1),
                          new Vertex(x2, y2, z2));
        }
    }
    
    public function ellipse(x1:Float, y1:Float, x2:Float, y2:Float) {
        graphics.ellipse(new Vertex(x1, y1),
                         new Vertex(x2, y2));
    }
    
    ////////////////////////////////////////////////////////////////////////////
    // Utility Methods
    public function random(?low:Float, ?high:Float) : Float {
        if(low == null) {
            return Math.random();
        }
        
        if(high == null) {
            return Math.random() * low;
        }
        
        var diff:Float = high - low;
        return (Math.random() * diff) + low;
    }
    
    public function cos(x:Float) : Float {
        return Math.cos(x);
    }
    
    public function sin(x:Float) : Float {
        return Math.sin(x);
    }
    
}
