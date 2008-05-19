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
    
    
    /**
     * Default Constructor
     */
    public function new() {
        trace("Applet initialized.");
    }
    
    public function init() {
        setup();
        draw();
    }
    
    public function setup() { }
    public function draw() { }
    
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
        graphics.fill(Color.NONE);
    }
    
    public function point(x:Float, y:Float, ?z:Float) {
        graphics.point(new Vertex(x, y, z));
    }
    
    /**
     * Passes either a 2D or 3D line to the graphics renderer, based on the
     * number of passed parameters.  For example:
     *  
     *  // Draws a 2D line from {x:0, y:0} to {x:10, y:10}
     *  line(0, 0, 10, 10);
     * 
     *  // Draws a 3D line from {x:0, y:0, z:0} to {x:100, y:200, z:300}
     *  line(0, 0, 0, 100, 200, 300);
     */
    public function line(x1:Float, y1:Float, z1:Float, x2:Float, ?y2:Float, ?z2:Float) {
        if(y2 == null) {
            graphics.line(new Vertex(x1, y1), new Vertex(z1, x2));
        } else {
            graphics.line(new Vertex(x1, y1, z1),
                          new Vertex(x2, y2, z2));
        }
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
    
}
