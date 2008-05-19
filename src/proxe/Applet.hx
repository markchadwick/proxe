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
    // Drawing Methods
    
    public function background(red:Int, ?green:Int, ?blue:Int, ?alpha:Int) {
        var color:Color = Color.resolve(red, green, blue, alpha);
        graphics.background(color);
    }
}
