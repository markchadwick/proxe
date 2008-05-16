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

    public var width:Int;
    public var height:Int;
    
    public var framesPerSecond:Int;

    public var graphicsClass:String;
    public var graphics:Graphics;

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
     *  looping             flase
     * 
     */
    public function new() {
        width = 100;
        height = 100;

        framesPerSecond = 60;
        graphicsClass = "proxe.graphics.Graphics";
        looping = false;
    }

    ////////////////////////////////////////////////////////////////////////////
    // Control Methods

    public function init() {
        looping = true;

        setup();
        start();
    }

    public function start() {
        var startTime:Float;
        var diff:Float;

        var sleepTime:Float = 1.0/framesPerSecond;

        trace("Sleep Time: "+ sleepTime);
        
        while(looping) {
            startTime =  Timer.stamp();
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
    // Placeholder Functions

    public function setup() {
        trace("Undefined Setup!");
    }

    public function draw() {
        trace("Undefined Draw!");
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
        start();
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
        stop();
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
    }

    /**
     * @Processing:
     *
     * Hides the cursor from view. Will not work when running the program in a
     * web browser.
     */
    public function noCursor() {
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
        if(graphics == null) {
            graphics = this.graphicsClass;
        }

        if(String == Type.getClass(graphics)) {
            return Type.createInstance(Type.resolveClass(graphics), [this]);
        }

        switch(cast(graphics, GraphicType)) {
            case MOCK: return new MockGraphics(this);
        }

        // TODO: Throw exception
        return null;
    }
}
