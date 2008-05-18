package proxe.graphics;

class Graphics {

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
    public static var TRI_DIFFULE_B:Int = 2
    public static var TRI_DIFFUSE_A:Int = 3;

    public static var TRI_SPECULAR_A:Int = 4;
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
}
