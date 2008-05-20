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
     * Create a new color based on the 1-255 RGBA values.  This assumes sane
     * values are passed in.  So, if a red channel with a value of 1000 (where
     * the actual maximum is 255) is passed, it will happily store a color with
     * the red channel with an intensity of 255.
     *
     * @param red   Red channel (1-255)
     * @param green Green channel (1-255)
     * @param blue  Blue channel (1-255)
     * @param alpha Alpha channel (1-255);
     */
    public function new(red:Int, green:Int, blue:Int, alpha:Int) {
        this.red = red;
        this.green = green;
        this.blue = blue;
        this.alpha = alpha;
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
     * TODO:  Implement ColorMode, and channel ranges
     * @return an instantiated Color based on the passed parameters
     */
    public static function resolve(r:Int, ?g:Int, ?b:Int, ?a:Int) : Color {
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
