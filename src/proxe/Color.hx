package proxe;

class Color {
    public var red:Int;
    public var green:Int;
    public var blue:Int;
    public var alpha:Int;
    
    /**
     * Color representing "no color", or null.  Setting fill to `Color.NONE`
     * will have the same effect as `noFill()`.
     */
    public static var NONE:Color = new Color(-1, -1, -1, -1);

    /**
     * Create a new color based on the 1-255 RGBA values
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
     * of two colors are the same, the colors are said to be equal.
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
     */
    public function toString() : String {
        return "<Color: r:"+ red +" g:"+ green +" b:"+ blue +" a:"+ alpha +">";
    }

}
