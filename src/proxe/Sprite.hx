package proxe;

import haxe.Timer;

import proxe.graphics.Graphics;
import proxe.graphics.MockGraphics;

class Sprite {
    /*
     * LANGUAGE MISMATCHES:
     *
     * - "frameRate" cannot be both a field and a method
     * http://processing.org/reference/frameRate.html
     *
     */
    
    ////////////////////////////////////////////////////////////////////////////
    // Public Fields

    /**
     * @Processing:
     *
     * System variable which stores the width of the display window. This value
     * is set by the first parameter of the size() function. For example, the
     * function call size(320, 240) sets the width variable to the value 320.
     * The value of width is zero until size() is called.
     */
    public var width:Int;
    
    /**
     * @Processing:
     *
     * System variable which stores the height of the display window. This value
     * is set by the second parameter of the size() function. For example, the
     * function call size(320, 240) sets the height variable to the value 240.
     * The value of height is zero until size() is called.
     */
    public var height:Int;
    
    public var framesPerSecond:Int;

    public var graphicsClass:String;
    public var graphics:Graphics;
    
    /**
     * @Processing:
     * 
     * The system variable frameCount contains the number of frames displayed
     * since the program started. Inside setup() the value is 0 and and after
     * the first iteration of draw it is 1, etc.
     */
    public var frameCount:Int;
    
    /**
     * @Processing:
     *
     * System variable which stores the dimensions of the computer screen. For
     * example, if the current screen resolution is 1024x768, screen.width is
     * 1024 and screen.height is 768. These dimensions are useful when exporting
     * full-screen applications. To ensure that the sketch takes over the entire
     * screen, use "Present" instead of "Run". Otherwise the window will still
     * have a frame border around it and not be placed in the upper corner of
     * the screen. On Mac OS X, the menu bar will remain present unless\
     * "Present" mode is used.
     */
    public var screen:Dynamic;

    ////////////////////////////////////////////////////////////////////////////
    // Private Fields

    private var timer:haxe.Timer;
    private var looping:Bool;
    
    ////////////////////////////////////////////////////////////////////////////
    // Constructor

    /**
     * Default constructor.  Will attempt to set reasonable defaults for new
     * Sprites.  The following defaults are set:
     *
     *  width:              100 px
     *  height:             100 px
     *  framesPerSecond:    60
     *  graphicsClass       "proxe.graphics.Graphics"
     *  looping             false
     *  frameCount          0
     * 
     */
    public function new() {
        width = 100;
        height = 100;

        framesPerSecond = 60;
        graphicsClass = "proxe.graphics.Graphics";
        looping = false;
        
        frameCount = 0;
    }

    ////////////////////////////////////////////////////////////////////////////
    // Placeholder Functions

    public function setup() {
    }

    public function draw() {
    }

    ////////////////////////////////////////////////////////////////////////////
    // Control Methods

    public function init() {
        setup();
        start();
    }

    public function start() {
        looping = true;
        
        var startTime:Float;
        var diff:Float;

        var sleepTime:Float = 1.0/framesPerSecond;
    
        while(looping) {
            startTime =  Timer.stamp();
            frameCount++;
            draw();
            diff = sleepTime - ((Timer.stamp() - startTime)/100);

            if(diff > 0) {
                neko.Sys.sleep(diff);
            }
        }
    }

    public function stop() {
        looping = false;
    }
    
    ////////////////////////////////////////////////////////////////////////////
    // Structure
    
    /**
     * @Processing:
     * 
     * Defines the dimension of the display window in units of pixels. The
     * size() function must be the first line in setup(). If size() is not
     * called, the default size of the window is 100x100 pixels.
     * The system variables width and height are set by the parameters passed to
     * the size() function. Using variables as the parameters to size() is
     * strongly discouraged and can create problems. Instead, use a numeric
     * value for the width and height variables if you need to know the
     * dimensions of the display window within your program.
     *
     * The MODE parameters selects which rendering engine to use. For example,
     * if you will be drawing 3D shapes for the web use P3D, if you want to
     * export a program with OpenGL graphics acceleration use OPENGL. A brief
     * description of the four primary renderers follows:
     *
     *  P2D (Processing 2D) - 2D renderer supporting Java 1.1 export (NOT
     *  CURRENTLY IMPLEMENTED)
     * 
     *  P3D (Processing 3D) - Fast 3D renderer for the web. Sacrifices rendering
     *  quality for quick 3D drawing.
     * 
     *  JAVA2D - The default renderer, higher quality in general, but slower
     *  than P2D
     * 
     *  OPENGL - Interface with OpenGL hardware acceleration to increase speed
     *  if an OpenGL graphics card is installed.
     *
     * If you're manipulating pixels (using methods like get() or blend(), or
     * manipulating the pixels[] array), P3D (and eventually P2D as well) will
     * be faster than the default (JAVA2D) setting, as well as the OPENGL
     * setting. Similarly, when handling lots of images, or doing video
     * playback, P3D will often be faster.
     *
     * The maximum width and height is limited by your operating system, and is
     * usually the width and height of your actual screen. On some machines it
     * may simply be the number of pixels on your current screen, meaning that a
     * screen that's 800x600 could support size(1600, 300), since it's the same
     * number of pixels. This varies widely so you'll have to try different
     * rendering modes and sizes until you get what you're looking for. If you
     * need something larger, use createGraphics to create a non-visible drawing
     * surface.
     *
     * Again, the size() method must be the first line of the code (or first
     * item inside setup). Any code that appears before the size() command may
     * run more than once, which can lead to confusing results.
     */
    public function size(width:Int, height:Int, ?graphics:Dynamic) {
        this.width = width;
        this.height = height;

        this.graphics = initializeGraphics(graphics);
    }

    /**
     * @Processing:
     *
     * Causes Processing to continuously execute the code within draw(). If
     * noLoop() is called, the code in draw() stops executing.
     */
    public function loop() {
        if(!looping) {
            start();
        }
    }

    /**
     * @Processing:
     *
     * Stops Processing from continuously executing the code within draw(). If
     * loop() is called, the code in draw() begin to run continuously again. If
     * using noLoop() in setup(), it should be the last line inside the block.
     *
     * When noLoop() is used, it's not possible to draw to the screen inside
     * event handling functions such as mousePressed() or keyPressed(). Instead,
     * use those functions to call redraw() or loop(), which will run draw(),
     * which can update the screen properly.
     *
     * Note that if the sketch is resized, redraw() will be called to update
     * the sketch, even after noLoop() has been specified. Otherwise, the sketch
     * would enter an odd state until loop() was called.
     */
    public function noLoop() {
        if(looping) {
            stop();
        }
    }


    /**
     * @Processing:
     * 
     * Forces the program to stop running for a specified time. Delay times are
     * specified in thousandths of a second. The function call delay(3000) will
     * stop the program for three seconds.
     *
     * Because the screen is updated only at the end of draw(), the program may
     * appear to "freeze" until the delay() has elapsed.
     *
     * This function causes the program to stop as soon as it is called, except
     * if the program is running the draw() for the first time, it will complete
     * the loop before stopping.
     */
    public function delay(milliseconds:Int) {
        throw "Sprite.delay not implemented";
    }


    /**
     * @Processing:
     * 
     * Executes the code within draw() one time. This functions allows the
     * program to update the display window only when necessary, for example
     * when an event registered by mousePressed() or keyPressed() occurs.
     *
     * In structuring a program, it only makes sense to call redraw() within
     * events such as mousePressed(). This is because redraw() does not run
     * draw() immediately (it only sets a flag that indicates an update is
     * needed).
     *
     * Calling redraw() within draw() has no effect because draw() is
     * continuously called anyway.
     */
    public function redraw() {
        throw "Sprite.redraw() not implemented";
    }
    
    ////////////////////////////////////////////////////////////////////////////
    // Environment

    /**
     * @Processing:
     *
     * Specifies the number of frames to be displayed every second. If the
     * processor is not fast enough to maintain the specified rate, it will not
     * be achieved. For example, the function call frameRate(30) will attempt to
     * refresh 30 times a second. It is recommended to set the frame rate within
     * setup(). The default rate is 60 frames per second.
     */
    public function frameRate(fps:Int) {
        throw "Sprite.frameRate() not implemented";
    }

    /**
     * @Processing:
     *
     * Hides the cursor from view. Will not work when running the program in a
     * web browser.
     */
    public function noCursor() {
        throw "Sprite.noCursor() not implemented";
    }

    /**
     * @Processing:
     *
     * Sets the cursor to a predefined symbol, an image, or turns it on if
     * already hidden. If you are trying to set an image as the cursor, it is
     * recommended to make the size 16x16 or 32x32 pixels. It is not possible to
     * load an image as the cursor if you are exporting your program for the
     * Web. The values for parameters x and y must be less than the dimensions
     * of the image.
     */
    public function cursor(?modeOrImage:Dynamic, ?x:Float, ?y:Float) {
        throw "Sprite.cursor() not implemented";
    }

    ////////////////////////////////////////////////////////////////////////////
    // Shape Methods

    /**
     * @Processing:
     *
     * A triangle is a plane created by connecting three points. The first two
     * arguments specify the first point, the middle two arguments specify the
     * second point, and the last two arguments specify the third point.
     */
    public function triangle(x1:Float, y1:Float,
        x2:Float, y2:Float,
        x3:Float, y3:Float) {
        
        throw "Sprite.triangle() not implemented";
    }
    
    /**
     * @Processing:
     *
     * Draws a line (a direct path between two points) to the screen. The
     * version of line() with four parameters draws the line in 2D. To color a
     * line, use the stroke() function. A line cannot be filled, therefore the
     * fill() method will not affect the color of a line. 2D lines are drawn
     * with a width of one pixel by default, but this can be changed with the
     * strokeWeight() function. The version with six parameters allows the line
     * to be placed anywhere within XYZ space. Drawing this shape in 3D using
     * the z parameter requires the P3D or OPENGL parameter in combination with
     * size as shown in the above example.
     */
    public function line(x1:Float, y1:Float, z1:Float,
        x2:Float, ?y2:Float, ?z2:Float) {
        
        throw "Sprite.line() not implemented";
    }

    /**
     * @Processing:
     *
     * Draws an arc in the display window. Arcs are drawn along the outer edge
     * of an ellipse defined by the x, y, width and height parameters. The
     * origin or the arc's ellipse may be changed with the ellipseMode()
     * function. The start and stop parameters specify the angles at which to
     * draw the arc.
     *
     * @param x         x coordinate of the arc's ellipse
     * @param y         y coordinate of the arc's ellipse
     * @param width     with of the arc's ellipse
     * @param height    height of the arc's ellipse
     * @param start     angle to start the arc, specified in radians or degrees
     *                  depending on the current angle mode
     * @param stop      angle to stop the arc, specified in radians or degrees
     *                  depending on the current angle mode
     */
    public function arc(x:Float, y:Float, width:Float, height:Float,
        start:Float, stop:Float) {
        
        throw "Sprite.arc() not implemented";
    }

    /**
     * @Processing:
     *
     * Draws a point, a coordinate in space at the dimension of one pixel. The
     * first parameter is the horizontal value for the point, the second value
     * is the vertical value for the point, and the optional third value is the
     * depth value. Drawing this shape in 3D using the z parameter requires the
     * P3D or OPENGL parameter in combination with size as shown in the above
     * example.
     *
     * @param x         x coordinate of the point
     * @param y         y coordinate of the point
     * @param z         optional z coordinate of the point
     */
    public function point(x:Float, y:Float, ?z:Float) {
        throw "Sprite.point() not implemented";
    }
    
    /**
     * @Processing:
     *
     * A quad is a quadrilateral, a four sided polygon. It is similar to a 
     * rectangle, but the angles between its edges are not constrained to ninety
     * degrees. The first pair of parameters (x1,y1) sets the first vertex and
     * the subsequent pairs should proceed clockwise or counter-clockwise around
     * the defined shape.
     *
     * @param x1        x coordinate of the first corner
     * @param y1        y coordinate of the first corner
     * @param x1        x coordinate of the second corner
     * @param y1        y coordinate of the second corner
     * @param x1        x coordinate of the third corner
     * @param y1        y coordinate of the third corner
     * @param x1        x coordinate of the fourth corner
     * @param y1        y coordinate of the fourth corner
     */
    public function quad(x1:Float, y1:Float, x2:Float, y2:Float,
        x3:Float, y3:Float, x4:Float, y4:Float) {
        
        throw "Sprite.quad() not implemented";
    }
    
    /**
     * @Processing:
     *
     * Draws an ellipse (oval) in the display window. An ellipse with an equal
     * width and height is a circle. The first two parameters set the location,
     * the third sets the width, and the fourth sets the height. The origin may
     * be changed with the ellipseMode() function.
     *
     * @param x         x coordinate of the ellipse
     * @param y         y coordinate of the ellipse
     * @param width     width of the ellipse
     * @param height    height of the ellipse
     */
    public function ellipse(x:Float, y:Float, width:Float, height:Float) {
        throw "Sprite.ellipse() not implemented!";
    }
    
    /**
     * @Processing:
     *
     * Draws a rectangle to the screen. A rectangle is a four-sided shape with
     * every angle at ninety degrees. The first two parameters set the location,
     * the third sets the width, and the fourth sets the height. The origin is
     * changed with the rectMode() function.
     *
     * @param x         x coordinate of the rectangle
     * @param y         y coordinate of the rectangle
     * @param width     width of the rectangle
     * @param height    height of the rectangle
     */
    public function rect(x:Float, y:Float, width:Float, height:Float) {
        throw "Sprite.rect() not implemented";
    }
    

    ////////////////////////////////////////////////////////////////////////////
    // Private methods

    /**
     * Initializes the graphics for this Sprite.  The three possible options for
     * `graphicsType` are:
     *
     *  when (graphics == null):            reflect this.graphicsClass string
     *  when (graphics is a String):        reflect the string
     *  when (graphics is a GraphicsType):  instance that type
     */
    private function initializeGraphics(graphics:Dynamic) : Graphics {
        try {
            if(graphics == null) {
                graphics = this.graphicsClass;
            }

            if(String == Type.getClass(graphics)) {
                return Type.createInstance(Type.resolveClass(graphics), [this]);
            }

            switch(cast(graphics, GraphicType)) {
                case MOCK: return new MockGraphics(this);
            }
            
        } catch(e:Dynamic) {
            throw "Unknown Graphics Type: "+ graphics;
        }
        return null;
    }
}
