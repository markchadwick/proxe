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
    HSB;
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
    public function new(red:Float, green:Float, blue:Float, alpha:Float,
                        ?maxR:Float, ?maxG:Float, ?maxB:Float, ?maxA:Float) {
    
        /*
         * Set Range Bounds
         */
        maxR = (maxR == null)? 255 : (maxR < 0)? 0 : maxR;
        maxG = (maxG == null)? 255 : (maxG < 0)? 0 : maxG;
        maxB = (maxB == null)? 255 : (maxB < 0)? 0 : maxB;
        maxA = (maxA == null)? 255 : (maxA < 0)? 0 : maxA;
        
        /*
         * Set Channel Bounds
         */
        red     = (red > maxR)  ? maxR : (red < 0)?   0 : red;
        green   = (green > maxG)? maxG : (green < 0)? 0 : green;
        blue    = (blue > maxB) ? maxB : (blue < 0)?  0 : blue;
        alpha   = (alpha > maxA)? maxA : (alpha < 0)? 0 : alpha;
        
        /*
         * Set values
         */
        this.red = Math.floor(red/maxR*255);
        this.green = Math.floor(green/maxG*255);
        this.blue = Math.floor(blue/maxB*255);
        this.alpha = Math.floor(alpha/maxA*255);
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
    public static function resolve(r:Float, ?g:Float, ?b:Float, ?a:Float) : Color {
        if(a == null) {
            if(b == null) {
                if(g == null) {
                    return new Color(r, r, r, 255);
                }
                return new Color(r, r, r, g);
            }
            return new Color(r, g, b, 255);
        }
        return new Color(r, g, b, a);
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

}
