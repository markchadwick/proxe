package proxe;

import proxe.graphics.Graphics;

#if flash9
import proxe.graphics.FlashGraphics;
#end

class Applet {

    ////////////////////////////////////////////////////////////////////////////
    // Static fields

    public static var DEFAULT_WIDTH:Int = 200;
    public static var DEFAULT_HEIGHT:Int = 200;

    public static var DEFAULT_RENDERER = "proxe.graphics.FlashGraphics";

    /**
     * Message of the Exception thrown when size() is called the first time.
     *
     * This is used internally so that setup() is forced to run twice when the
     * renderer is changed. This is the only way for us to handle invoking the
     * new renderer while also in the midst of rendering.
     */
    public static var NEW_RENDERER:String = "new renderer";

    ////////////////////////////////////////////////////////////////////////////
    // Constructor
    public function new() {
    }

    ////////////////////////////////////////////////////////////////////////////
    // Public Fields

    /**
     * true if no size() command has been executed. This is used to wait until
     * a size has been set before placing in the window and showing it.
     */
    public var defaultSize:Bool;

    /**
     * Width of this applet's associated PGraphics
     */
    public var width:Int;

    /**
     * Height of this applet's associated PGraphics
     */
    public var height:Int;
    
    /**
     * The Graphics renderer associated with this Applet
     */
    public var g:Graphics;

    /**
     * A leech graphics object that is echoing all events.
     */
    public var recorder:Graphics;


    /**
     * How many frames have been displayed since the applet started.
     * 
     * This value is read-only *do not* attempt to set it, otherwise bad things
     * will happen.
     * 
     * Inside setup(), frameCount is 0. For the first iteration of draw(),
     * frameCount will equal 1.
     */
    public var frameCount:Int;
    
    ////////////////////////////////////////////////////////////////////////////
    // Private Fields
    
    private var looping:Bool;

    /**
     * Creates a new Graphics object and sets it to the specified size.
     *
     * Note that you cannot change the renderer once outside of setup().
     * In most cases, you can call size() to give it a new size,
     * but you need to always ask for the same renderer, otherwise
     * you're gonna run into trouble.
     *
     * @param width     Width of the Graphics object
     * @param height    Height of the Graphics object
     * @param renderer  Which class of Graphics object to render to (optional)
     * @param path      where to save the output of the renderer (optional)
     */
    public function size(width:Int, height:Int, ?renderer:Dynamic, ?path:String) {
        if (this.g == null) {
            this.g = Applet.createGraphics(width, height, renderer, path, this);
            this.width = width;
            this.height = height;
            setSize(width, height);
        } else {
            if (path != null) {
                path = savePath(path);
            }
            var currentRenderer:String = cast(Type.getClass(g), String);
            
            if (currentRenderer == renderer) {
                if (this.width == width && this.height == height) {
                    return;
                }
                
                setRendererSize(width, height);
                setSize(width, height);
            } else {
                if (frameCount > 0) {
                    throw "size() cannot be called to change " +
                          "the renderer outside of setup()";
                }
                
                this.g = Applet.createGraphics(width, height, renderer, path, this);
                this.width = width;
                this.height = height;

                setSize(width, height);
            
                defaultSize = false;
            }
            throw NEW_RENDERER;
        }
    }

    /**
     * Creates an instantiated Graphics object of the size and type passed to
     * the method.
     *
     * @param width     Width of the desired graphics object
     * @param height    Height of the desired Graphics object
     * @param renderer  fully-qualifed class name of the renerer to instantiate
     * @param applet    reference back to the spawing applet
     */
    public static function createGraphics(width:Int, height:Int,
                                          renderer:Dynamic, path:String,
                                          applet:Applet) : Graphics {
        try {
            if(renderer == null) {
                renderer = Applet.DEFAULT_RENDERER;
            }

            if(String == Type.getClass(renderer)) {
                return Type.createInstance(Type.resolveClass(renderer),
                                           [width, height, applet]);
            }
        } catch(e:Dynamic) {
            trace(e);
            trace("Unknown Graphics Type: "+ renderer);
            throw("Unknown Graphics Type: "+ renderer);
        }
        return null;
    }

    /**
     * Resize the current renderer that's in use. This will be called after the
     * Component has been resized (by an event) and the renderer needs an update.
     */
    public function setRendererSize(width:Int, height:Int) {
        var changed:Bool = false;
        if (g == null) {
            g = Applet.createGraphics(width, height, DEFAULT_RENDERER, null, this);
        } else  if (width != g.width || height != g.height) {
            g.resize(width, height);
            changed = true;
        }
        this.width = width;
        this.height = height;
        
        if (changed) {
            redraw();
        }
    }

    ////////////////////////////////////////////////////////////////////////////
    // Drawing Jazz
    
    public function background(red:Int, ?green:Int, ?blue:Int, ?alpha:Int) {
        var color:Color = Color.resolve(red, green, blue, alpha);
        if (recorder != null) recorder.background(color);
        g.background(color);
    }

    public function fill(red:Int, ?green:Int, ?blue:Int, ?alpha:Int) {
        var color:Color = Color.resolve(red, green, blue, alpha);
        if(recorder != null) recorder.fill(color);
        g.fill(color);
    }

    public function noFill() {
        var color:Color = Color.NONE;
        if(recorder != null) recorder.fill(color);
        g.fill(color);
    }

    public function stroke(red:Int, ?green:Int, ?blue:Int, ?alpha:Int) {
        var color:Color = Color.resolve(red, green, blue, alpha);
        if(recorder != null) recorder.stroke(color);
        g.stroke(color);
    }

    public function noStroke() {
        var color:Color = Color.NONE;
        if(recorder != null) recorder.stroke(color);
        g.stroke(color);
    }

    public function point(x:Float, y:Float, ?z:Float) {
        if(recorder != null) recorder.point(x, y, z);
        g.point(x, y, z);    
    }

    public function line(x1:Float, y1:Float, z1:Float,
                         x2:Float, ?y2:Float, ?z2:Float) {
        if(recorder != null) recorder.line(x1, y1, z1, x2, y2, z2);
        g.line(x1, y1, z1, x2, y2, z2);
    }

    public function rect(x:Float, y:Float, width:Float, height:Float) {
        if(recorder != null) recorder.rect(x, y, width, height);
        g.rect(x, y, width, height);
    }
    
    ////////////////////////////////////////////////////////////////////////////
    // LEGACY METHODS

    public function setSize(width:Int, height:Int) {
        trace("LEGACY: setSize("+ width +", "+ height +")");
    }

    public function savePath(where:String) : String {
        trace("File operations disable :(");
        return ".";
    }

    public function sketchPath(where:String) : String {
        trace("File operations disabled :(");
        return ".";
    }

    public function redraw() {
        trace("Redraw");
        //if(!looping) {
            //redraw = true;
            //if (thread != null) {
                //if (CRUSTY_THREADS) {
                    //thread.interrupt();
                //} else {
                    //synchronized (blocker) {
                        //blocker.notifyAll();
                    //}
                //}
            //}
        //}
    }

}
