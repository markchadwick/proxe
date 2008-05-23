package proxe;

import proxe.Color;
import proxe.graphics.Graphics;
import proxe.graphics.GraphicsFactory;

enum ShapeMode {
    CORNERS;
    CORNER;
    RADIUS;
    CENTER;
}

enum ShapeType {
    POINTS;
    POLYGON;
    LINES;
    TRIANGLES;
    TRIANGLE_FAN;
    TRIANGLE_STRIP;
    QUADS;
    QUAD_STRIP;
}

enum ShapeClosingType {
    OPEN;
    CLOSE;
}

class Applet {
    
    ////////////////////////////////////////////////////////////////////////////
    // Instance Fields
    
    /**
     * Width the current applet
     *
     * TODO: implement getter (no setter)
     */
    public var width:Int;

    /**
     * Height of the current applet
     *
     * TODO: implement getter (no setter)
     */
    public var height:Int;
    
    
    /**
     * Path, if any, of the current Graphics
     */
    public var path:String;
    
    /**
     * Current Graphics renderer.
     *
     * TODO: implement "g" getter for Processing compatability
     */
    public var graphics:Graphics;
    
    /**
     * Current horizontal position of the mouse cursor, relative to the Applet.
     * It uses the same coordinate system as the Applet, so 0 would be the
     * left-hand side of the screen, and equal to "width" would be the right.
     */
    public var mouseX:Float;
    public var mouseY:Float;
    
    public var currentColorMode:ColorMode;
    public var maxR:Float;
    public var maxG:Float;
    public var maxB:Float;
    public var maxA:Float;
    
    ////////////////////////////////////////////////////////////////////////////
    // Constructor
    
    /**
     * Default Constructor.  Will set set certain field values which we cannot
     * guarentee will be set by the first time a user queries them.  Mouse
     * position, for example, may be updated whenever a particular platform
     * implementation would like to set them on our behalf.  It would be quite
     * easy for a user to use those variables while null (if not set now).
     */
    public function new() {
        mouseX = 0;
        mouseY = 0;
        
        currentColorMode = RGB;
        maxR = 255;
        maxG = 255;
        maxB = 255;
        maxA = 255;
    }
    
    ////////////////////////////////////////////////////////////////////////////
    // User-implemented Methods
    
    public function setup() { }
    public function draw() { }
    public function mousePressed() { }
    
    ////////////////////////////////////////////////////////////////////////////
    // Setup Methods
    
    public function init() {
        setup();
        
        if(graphics.looping) {
            loop();
        } else {
            draw();
        }
    }
    
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
        var color:Color = Color.resolve(red, green, blue, alpha,
                            currentColorMode, maxR, maxG, maxB, maxA);
        graphics.fill(color);
    }
    
    public function noFill() {
        graphics.fill(Color.NONE);
    }
    
    public function stroke(red:Int, ?green:Int, ?blue:Int, ?alpha:Int) {
        var color:Color = Color.resolve(red, green, blue, alpha,
                            currentColorMode, maxR, maxG, maxB, maxA);
        graphics.stroke(color);
    }
    
    public function noStroke() {
        graphics.stroke(Color.NONE);
    }
    
    public function background(red:Int, ?green:Int, ?blue:Int, ?alpha:Int) {
        var color:Color = Color.resolve(red, green, blue, alpha,
                            currentColorMode, maxR, maxG, maxB, maxA);
        graphics.background(color);
    }
    
    public function colorMode(mode:ColorMode, ?maxR:Float, ?maxG:Float,
                                ?maxB:Float, ?maxA:Float) {
        this.currentColorMode = mode;
        if(maxA == null) {
            if(maxB == null) {
                if(maxG == null) {
                    if(maxR != null) {
                        this.maxR = maxR;
                        this.maxG = maxR;
                        this.maxB = maxR;
                    }
                }
            }
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////
    // Drawing Methods
    
    public function rectMode(mode:ShapeMode) {
        graphics.rectMode(mode);
    }
    
    public function ellipseMode(mode:ShapeMode) {
        graphics.ellipseMode(mode);
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
    
    public function quad(x1:Float, y1:Float,
                         x2:Float, y2:Float,
                         x3:Float, y3:Float,
                         x4:Float, y4:Float) {
        graphics.quad(x1, y1, x2, y2, x3, y3, x4, y4);
    }
    
    public function triangle(x1:Float, y1:Float,
                             x2:Float, y2:Float,
                             x3:Float, y3:Float) {
    
        graphics.triangle(new Vertex(x1, y1),
                          new Vertex(x2, y2),
                          new Vertex(x3, y3));
    }
    
    public function point(x:Float, y:Float, ?z:Float) {
        graphics.point(new Vertex(x, y, z));
    }

    ////////////////////////////////////////////////////////////////////////////
    // Vertex Methods
    
    public function beginShape(?shapeType:ShapeType) {
        if(shapeType == null) {
            shapeType = POLYGON;
        }
        graphics.beginShape(shapeType);
    }
    
    public function endShape(?shapeClosingType:ShapeClosingType) {
        if(shapeClosingType == null) {
            shapeClosingType = OPEN;
        }
        graphics.endShape(shapeClosingType);
    }
    
    public function vertex(x:Float, y:Float, ?z:Float, ?u:Float, ?v:Float) {
        graphics.vertex(new Vertex(x, y, z, u, v));
    }
    
    public function curveVertex(x:Float, y:Float, ?z:Float) {
        graphics.curveVertex(new Vertex(x, y, z));
    }
    
    ////////////////////////////////////////////////////////////////////////////
    // Utility Methods
    /**
     * TODO: inline/static Applet util methods
     */
     
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
    
    public inline function abs(x:Float) : Float {
        return Math.abs(x);
    }
    
}
