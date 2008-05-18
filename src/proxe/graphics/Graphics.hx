package proxe.graphics;

import proxe.Color;
import proxe.graphics.Image;

enum GraphicsType {
    MOCK;
}

enum RectMode {
    CORNERS;
    CORNER;
    RADIUS;
    CENTER;
}

enum ShapeType {
    QUADS;
    POINTS;
    LINES;
    TRIANGLES;
}

enum ShapeClosingType {
    OPEN;
    CLOSE;
}

enum Hint {
  ENABLE_OPENGL_2X_SMOOTH;
  ENABLE_OPENGL_4X_SMOOTH;
  ENABLE_NATIVE_FONTS;
  DISABLE_DEPTH_TEST;
  DISABLE_FLYING_POO;
  ENABLE_DEPTH_SORT;
  DISABLE_ERROR_REPORT;
  ENABLE_ACCURATE_TEXTURES;
  DISABLE_AUTO_GZIP;
}

class Graphics extends Image {

    ////////////////////////////////////////////////////////////////////////////
    // CONSTANTS
    
    /*
     * Transformed values (to be used in rendering)
     */
    public static var X:Int = 0;
    public static var Y:Int = 1;
    public static var Z:Int = 2;

    /*
     * Actual RGBA, after lighting.  Fill stored here, transform in place.
     */
    public static var R:Int = 3;
    public static var G:Int = 4;
    public static var B:Int = 5;
    public static var A:Int = 6;

    /*
     * Values that need to transformation, but will be used in rendering
     */
    public static var U:Int = 7;
    public static var V:Int = 8;

    /*
     * Incoming values, raw and untransformed (won't be used in rendering)
     */
    public static var MX:Int = 9;
    public static var MY:Int = 10;
    public static var MZ:Int = 11;

    /*
     * Stroke ARGB values
     */
    public static var SR:Int = 12;
    public static var SG:Int = 13;
    public static var SB:Int = 14;
    public static var SA:Int = 15;

    /*
     * Stroke Weight
     */
    public static var SW:Int = 16;

    /*
     * Not ued in rendering, only used for calculating colors.
     */
    public static var NX:Int = 17;
    public static var NY:Int = 18;
    public static var NZ:Int = 19;

    /*
     * View space coordinates
     */
    public static var VX:Int = 20;
    public static var VY:Int = 21;
    public static var VZ:Int = 22;
    public static var VW:Int = 23;

    /*
     * Ambient color (usually to be kept the same as diffuse).  fill(_) sets
     * both ambient and diffuse.
     */
    public static var AR:Int = 24;
    public static var AG:Int = 25;
    public static var AB:Int = 26;

    /*
     * Diffuse is shared with fill
     */
    public static var DR:Int = R;
    public static var DG:Int = G;
    public static var DB:Int = B;
    public static var DA:Int = A;

    /*
     * Specular (by default kept white)
     */
    public static var SPR:Int = 27;
    public static var SPG:Int = 28;
    public static var SPB:Int = 29;
    public static var SPA:Int = 30;

    /*
     * Shininess
     */
    public static var SHINE:Int = 31;

    /*
     * Emissive (by default kept black)
     */
    public static var ER:Int = 32;
    public static var EG:Int = 33;
    public static var EB:Int = 34;

    /*
     * Has the vertex been let yet?
     */
    public static var BEEN_LIT:Int = 35;

    /*
     * Count of the vertices
     */
    public static var VERTEX_FIELD_COUNT:Int = 36;

    /*
     * Line and Triangle fields (note how these overlap)
     */
    public static var INDEX:Int = 0;
    public static var VERTEX1:Int = 1;
    public static var VERTEX2:Int = 2;
    public static var VERTEX3:Int = 3;
    public static var TEXTURE_MODE:Int = 4;
    public static var STROKE_MODE:Int = 3;
    public static var STROKE_WEIGHT:Int = 4;

    public static var LINE_FIELD_COUNT:Int = 5;
    public static var TRIANGLE_FIELD_COUNT:Int = 5;

    public static var TRI_DIFFUSE_R:Int = 0;
    public static var TRI_DIFFUSE_G:Int = 1;
    public static var TRI_DIFFULE_B:Int = 2;
    public static var TRI_DIFFUSE_A:Int = 3;

    public static var TRI_SPECULAR_R:Int = 4;
    public static var TRI_SPECULAR_G:Int = 5;
    public static var TRI_SPECULAR_B:Int = 6;
    public static var TRI_SPECULAR_A:Int = 7;

    public static var TRIANGLE_COLOR_COUNT:Int = 8;

    /*
     * Normal modes for lighting, these have the uglier naming becase the
     * constants are never seen by users
     *
     * TODO: Yuck!  See above.
     */
    
    /**
     * Normal calculated per triangle
     */
    public static var AUTO_NORMAL:Int = 0;

    /**
     * One normal manually specified per shape
     */
    public static var MANUAL_SHAPE_NORMAL:Int = 1;

    /**
     * Normals specified for each shape vertex
     */
    public static var MANUAL_VERTEX_NORMAL:Int = 2;

    ////////////////////////////////////////////////////////////////////////////
    // Instance Fields

    /**
     * Depth buffer
     */
    public var zBuffer:Array<Float>;

    /**
     * Width minus one (useful for many calculations)
     */
    public var width1:Int;

    /**
     * Height minus one (useful for many calculations)
     */
    public var height1:Int;

    /**
     * width * height (useful for many calculations)
     */
    public var pixelCount:Int;

    /**
     * True if defaults() has been called a first time
     */
    public var defaultsInited:Int;

    /**
     * true if in-between beginDraw() and endDraw()
     */
    public var insdeDraw:Bool;

    /**
     * True if in the midst of resize (no drawing can take place)
     */
    public var insideResize:Bool;

    public var raw:Graphics;
    
    /**
     * Array of hint[] items. These are hacks to get around various temporary
     * workarounds inside the environment.
     *
     * Note that this array cannot be static, as a hint() may result in a
     * runtime change specific to a renderer. For instance, calling
     * hint(DISABLE_DEPTH_TEST) has to call glDisable() right away on an
     * instance of PGraphicsOpenGL.
     *
     * The hints[] array is allocated early on because it might be used inside
     * beginDraw(), allocate(), etc.
     */
//    protected boolean hints[] = new boolean[HINT_COUNT];
    // TODO: Initialize to HINT_COUNT
    public var hints:Hash<Bool>;

    // total number of verticies
    public var vertexCount:Int;

    public var backgroundColor:Color;
    public var fillColor:Color;
    public var strokeColor:Color;
    
    /**
     * Type of shape passed to beginShape(),
     * zero if no shape is currently being drawn.
     */
    public var shape:ShapeType;

    ////////////////////////////////////////////////////////////////////////////
    // Color Fields

    /**
     * The current color mode
     * 
     * @default RGB
     */
    public var colorMode:Int;

    /**
     * Max value for red (or hue) set by colorMode
     *
     * @default 255
     */
    public var colorModeX:Float;

    /**
     * Max value for green (or saturation) set by colorMode
     *
     * @default 255
     */
    public var colorModeY:Float;

    /**
     * Max value for blue (or value) set by colorMode
     *
     * @default 255
     */
    public var colorModeZ:Float;

    /**
     * Max value for alpha set by colorMode
     *
     * @default 255
     */
    public var colorModeA:Float;

    /**
     * True if colors are not in the range 0..1
     * 
     * @default true
     */
    private var colorScale:Bool;

    /**
     * True if colorMode(RGB, 255)
     * 
     * @default true
     */
    private var colorRgb255:Bool;

    ////////////////////////////////////////////////////////////////////////////
    // "Mode" variables
    
    private var currentRectMode:RectMode;

    ////////////////////////////////////////////////////////////////////////////
    // Abstract Methods
    public function allocate() {
        trace("Abstract Method: Graphics.allocate()");
        throw("Abstract Method: Graphics.allocate()");
    }

    public function clear() {
        trace("Abstract Method: Graphics.clear()");
        throw("Abstract Method: Graphics.clear()");
    }

    public function beginShape(?kind:ShapeType) {
        trace("Abstract Method: Graphics.beginShape()");
        throw("Abstract Method: Graphics.beginShape()");
    }

    public function vertex(x:Float, y:Float, ?z:Float, ?u:Float, ?v:Float) {
        trace("Abstract Method: Graphics.vertex()");
        throw("Abstract Method: Graphics.vertex()");
    }

    public function endShape(?mode:ShapeClosingType) {
        trace("Abstract Method: Graphics.endShape()");
        throw("Abstract Method: Graphics.endShape()");
    }

    ////////////////////////////////////////////////////////////////////////////
    // Public Methods
    /**
     * Called in repsonse to a resize event, handles setting the new width and
     * height internally, as well as re-allocating the pixel buffer for the new
     * size
     *
     * Note that this will nuke any camera settings.
     */
    public function resize(width:Int, height:Int) {
        trace("resize("+ width +", "+ height +")");

        insideDrawWait();

        // Lock the draw
        insideResize = true;

        this.width = width;
        this.height = height;
        this.width1 = width - 1;
        this.height1 = height - 1;

        allocate();

        // Okay to redraw
        insideResize = false;
    }

    ////////////////////////////////////////////////////////////////////////////
    // Drawing Methods
    public function background(color:Color) {
        clear();
        
        if(color.alpha != 255) {
            color.alpha = 255;
        }

        this.backgroundColor = color;
        rect(0, 0, width, height);
    }

    public function rect(x:Float, y:Float, width:Float, height:Float) {
        var hRadius:Float;
        var vRadius:Float;
        
        switch(currentRectMode) {
            case CORNERS:

            case CORNER:
                width += x;
                height += y;

            case RADIUS:
                hRadius = width;
                vRadius = height;

                width  = x + hRadius;
                height = y + vRadius;

                x -= hRadius;
                y -= vRadius;

            case CENTER:
                hRadius = height/2;
                vRadius = width/2;

                width  = x + hRadius;
                height = y + vRadius;

                x -= hRadius;
                y -= vRadius;
        }

        if(x > width) {
            var temp:Float = x;
            x = width;
            width = temp;
        }

        if(y > height) {
            var temp:Float = y;
            y = width;
            width = temp;
        }

        rectImpl(x, y, width, height);
    }

    public function quad(x1:Float, y1:Float, x2:Float, y2:Float,
                         x3:Float, y3:Float, x4:Float, y4:Float) {
                         
        beginShape(QUADS);
        vertex(x1, y1);
        vertex(x2, y2);
        vertex(x3, y3);
        vertex(x4, y4);
        endShape();
    }

    public function fill(color:Color) {
        this.fillColor = color;
    }
    
    public function stroke(color:Color) {
        this.strokeColor = color;
    }

    ////////////////////////////////////////////////////////////////////////////
    // Shape Implementation Methods
    
    public function rectImpl(x1:Float, y1:Float, x2:Float, y2:Float) {
        quad(x1, y1,  x2, y1,  x2, y2,  x1, y2);
    }

    public function point(x:Float, y:Float, ?z:Float) {
        beginShape(POINTS);
        vertex(x, y, z);
        endShape();
    }

    public function line(x1:Float, y1:Float, z1:Float,
                         x2:Float, ?y2:Float, ?z2:Float) {
        if(y2 == null) {
            beginShape(LINES);
            vertex(x1, y1);
            vertex(z1, x1);
            endShape();
        } else {
            beginShape(LINES);
            vertex(x1, y1, z1);
            vertex(x2, y2, z2);
            endShape();
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////
    // Legacy Methods

    private function insideDrawWait() {
        /*
        while (insideDraw) {
            //System.out.println("waiting");
            try {
                Thread.sleep(5);
            } catch (InterruptedException e) { }
        }
        */
    }
}
