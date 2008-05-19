package proxe.graphics;

#if neko
import proxe.graphics.MockGraphics;
#else flash9
import proxe.graphics.FlashGraphics;
#end

import proxe.Applet;

class GraphicsFactory {

    /**
     * Defines the default Graphics implementation for a given compilation
     * setting
     */
    #if flash9
    public static var DEFAULT:String = "proxe.graphics.FlashGraphics";
    #else true
    public static var DEFAULT:String = "proxe.graphics.Graphics";
    #end

    /**
     * Instantiates a new Graphics implementation based on the current
     * compilation settings, and parameters passed.  There are a few ways this
     * factory method can operate:
     *
     * @param width     Width of the returned Graphics
     * @param height    Height of the returned Graphics
     * @param renderer  String hint (fully-qualified class name) of which
     *                  Graphics to instantiate
     * @param path      Path of the Graphics (assuming it accepts)
     * @return          Instantiated Graphics
     */
    public static function newInstance(width:Int, height:Int, renderer:String,
                                       path:String, applet:Applet) : Graphics {
        if(renderer == null) {
            renderer = DEFAULT;
        }
        
        try {
            if(String == Type.getClass(renderer)) {
                return fromString(width, height, renderer, path, applet);
            }
        } catch (e:Dynamic)  {
            trace(e);
            trace("Unknown Renderer: "+ renderer);
            throw("Unknown Renderer: "+ renderer);
        }
        
        trace("Unable to find renderer.");
        return null;
    }
    
    ////////////////////////////////////////////////////////////////////////////
    // Private Methods
    
    /**
     * Instantiates a Graphics from a string
     */
    private static function fromString(width:Int, height:Int, renderer:String,
                                       path:String, applet:Applet) : Graphics {
                                       
        var clazz = Type.resolveClass(renderer);
        return Type.createInstance(clazz, [width, height, applet]);
    }
}