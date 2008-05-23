package proxe;

/**
 * Different ways we can currently represent a color.  This will be used by the
 * Color class below to determine actual channel intensities for values in
 * different Color respresentations.
 *
 * "RGB" stands for "Red Green Blue", and is used by default. "HSV" stands for
 * "Hue, Saturation, Brightness" and will often be used where an incrementing
 * red channel will cycle a color through the spectrum of colors (quite hard
 * to do in RGB land).  For more information, check out:
 * http://en.wikipedia.org/wiki/HSV_color_space
 */
enum ColorMode {
    RGB;
    HSV;
}

/**
 * Class encapsulating color logic for Proxe's internals.  Calling methods may
 * pass different code "modes" to this class, but the representation is always
 * stored as four integer values: red, green, blue, and alpha.
 *
 */
class Color {
    public var red:Int;
    public var green:Int;
    public var blue:Int;
    public var alpha:Int;
    
    /**
     * Color representing "no color", or null.  Setting fill to `Color.NONE`
     * will have the same effect as `noFill()`.  As negative numbers are
     * generally not valid intensity values, passing this value directly to
     * an external (non-Proxe) graphics object is not recomended.
     *
     * TODO: Current bounds checks make this black, not non-valid.
     */
    public static var NONE:Color = new Color(-1, -1, -1, -1);

    /**
     * TODO: Fix docs
     *  used to talk about fixed vals and ranges
     *
     * @param red   Red/Hue channel (1-255)
     * @param green Green/Saturation channel (1-255)
     * @param blue  Blue/Value channel (1-255)
     * @param alpha Alpha channel (1-255);
     *
     * @param maxR (optional) maximum primary channel value
     * @param maxG (optional) maximum seconary channel value
     * @param maxB (optional) maximum tertiary channel
     * @param maxA (optional) maximum quaternary channel
     */
    public function new(red:Float, green:Float, blue:Float, alpha:Float) {
        this.red = Math.floor(red);
        this.green = Math.floor(green);
        this.blue = Math.floor(blue);
        this.alpha = Math.floor(alpha);
    }
    
    /**
     * Resolves a semi-variable list of integers from 0-255 into a single,
     * packed integer.  There are four different way to call this method.
     *
     *  resolveColor(gray)
     *  resolveColor(gray, alpha)
     *  resolveColor(red, green, blue)
     *  resolveColor(red, green, blue, alpha)
     *
     * TODO:  Implement ColorMode
     * @return an instantiated Color based on the passed parameters
     */
    public static function resolve(r:Float, ?g:Float, ?b:Float, ?a:Float,
                                   ?colorMode:ColorMode, ?maxR:Float,
                                   ?maxG:Float, ?maxB:Float, ?maxA:Float) : Color {
        
        colorMode = (colorMode == null)? RGB : colorMode;
        
        /*
         * Set Range Bounds
         */
        maxR = (maxR == null)? 255 : (maxR < 1)? 1 : maxR;
        maxG = (maxG == null)? 255 : (maxG < 1)? 1 : maxG;
        maxB = (maxB == null)? 255 : (maxB < 1)? 1 : maxB;
        maxA = (maxA == null)? 255 : (maxA < 1)? 1 : maxA;
        
        /*
         * Reconstruct parameters
         */
        if(a == null) {
            if(b == null) {
                if(g == null) {
                    g = r;
                    b = r;
                    a = maxA;
                } else {
                    a = g;
                    g = r;
                    b = r;
                }
            } else {
                a = maxA;
            }
        }
        
        /*
         * Set Channel Bounds
         */
        r = (r > maxR)? maxR : (r < 0)? 0 : r;
        g = (g > maxG)? maxG : (g < 0)? 0 : g;
        b = (b > maxB)? maxB : (b < 0)? 0 : b;
        a = (a > maxA)? maxA : (a < 0)? 0 : a;
        
        /*
         * Normalize
         */
        r = (r/maxR) * 255;
        g = (g/maxG) * 255;
        b = (b/maxB) * 255;
        a = (a/maxA) * 255;
        
        if(colorMode == RGB || colorMode == null) {
            return new Color(r, g, b, a);
        } else {
            return resolveHSV(r, g, b, a);
        }
    }

    /**
     * Tests equality of two colors.  If the red, green blue, and alpha channels
     * of two colors are the same, the colors are said to be equal.  Because
     * the Color class stores are internal representations as RGBA values,
     * this will safely determine equality of RGB/HSV colors if they are indeed
     * the same color.
     *
     * @param other The color to compare to "this"
     * @return True if the colors' red, green, blue, and alpha channels are
     *         equal.  Otherwise, false.
     */
    public function equals(other:Color) : Bool {
        return(
            this.red == other.red &&
            this.green == other.green &&
            this.blue == other.blue &&
            this.alpha == other.alpha);
    }
    
    /**
     * String representation of a color, IE:
     *  <Color: r:128 g:23 b:0 a:255>
     * It is important to note that because a Color will store even HSV colors
     * as RGBA values internally, this string representation may be confusing
     * for colors not in RGB color mode.
     *
     * @return String representation of the current color's red, green, blue,
     *         and alpha channels on a scale from 1-255.
     */
    public function toString() : String {
        return "<Color: r:"+ red +" g:"+ green +" b:"+ blue +" a:"+ alpha +">";
    }
    
    ////////////////////////////////////////////////////////////////////////////
    // Private Methods
    
    private static function resolveHSV(h:Float, s:Float, v:Float, a:Float) : Color {
        var rgb:Array<Float> = hsvToRgb(h, s, v);
        return new Color(rgb[0], rgb[1], rgb[2], a);
    }
    
    private static function hsvToRgb(h:Float, s:Float, v:Float) : Array<Float> {
        h =  (h/255) * 360;
        s /= 255;
        v /= 255;
        
        var r:Float = 0;
        var g:Float = 0;
        var b:Float = 0;
        
        if(s == 0) {
            var rgb = new Array<Float>();
            rgb[0] = v * 255;
            rgb[1] = v * 255;
            rgb[2] = v * 255;
            return rgb;
        }
        
        if(h == 360) {
            h = 0;
        } else {
            h /= 60;
        }
        
        var i:Int = Math.floor(h);
        var f = h - i;
        var p = v * (1 - s);
        var q = v * (1 - s * f);
        var t = v * (1 - s * (1 -f));

        switch(i) {
            case 0:
                r = v;
                g = t;
                b = p;
                
            case 1:
                r = q;
                g = v;
                b = p;
            
            case 2:
                r = p;
                g = v;
                b = t;
                
            case 3:
                r = p;
                g = q;
                b = v;
                
            case 4:
                r = t;
                g = p;
                b = v;
            
            default:
                r = v;
                g = p;
                b = q;
        }
        
        var rgb = new Array<Float>();
        rgb[0] = r * 255;
        rgb[1] = g * 255;
        rgb[2] = b * 255;
        return rgb;
    }

    private static function rgbToHsv(r:Float, g:Float, b:Float) {
        var max:Float = Math.max(r, Math.max(g, b));
        var min:Float = Math.min(r, Math.min(g, b));
        var delta:Float = max - min;
    
        var h:Float = 0;
        var s:Float = 0;
        var v:Float = max;
        
        if(v != 0) {
            s = delta/max;
        }
        
        if(s != 0) {
            switch(max) {
                case r:     h = (g-b)/delta;
                case g:     h = 2 + (b-r) / delta;
                case b:     h = 4 + (r-g) / delta;
            }
        }
        
        h *= 60;
        h %= 360;
    }

}
