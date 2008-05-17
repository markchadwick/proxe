package proxe;

class Color {
    public var red:Int;
    public var green:Int;
    public var blue:Int;
    public var alpha:Int;
    
    public static var NONE:Color = new Color(-1, -1, -1, -1);

    public function new(red:Int, green:Int, blue:Int, alpha:Int) {
        this.red = red;
        this.green = green;
        this.blue = blue;
        this.alpha = alpha;
    }
    
    /**
     * Takes four integers from 0-255, and packs them into a single integer.
     * If any of the given parameters is less than zero, it will cast it to
     * exactly zero.  If one of the parameters is above 255, it will case it to
     * exactly 255.
     *
     * The layout of the packed integer are as follows:
     *
     *  (2 bytes alpha) (2 bytes red) (2 bytes green) (2 bytes blue)
     *
     * Some examples of given RGBA parameters, and the resulting packed integer:
     *
     *  (r:0, g:0, b:0, a:255)      => 0xff000000
     *  (r:255, g:0, b:0, a:0)      => 0x00ff0000
     *  (r:0, g:255, b:0, a:255)    => 0xff00ff00
     *  (r:255, g:-1, b:1000, a:128)=> 0x80ff00ff
     */
    public static inline function pack(r:Int, g:Int, b:Int, a:Int) : Int {
        r = (r < 0) ? 0 : (r > 255) ? 255 : r;
        g = (g < 0) ? 0 : (g > 255) ? 255 : g;
        b = (b < 0) ? 0 : (b > 255) ? 255 : b;
        a = (a < 0) ? 0 : (a > 255) ? 255 : a;
        
        return (a << 24) | (r << 16) | (g << 8) | b;
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
     * String representation of a color, IE:
     *  <Color: r:128 g:23 b:0 a:255>
     */
    public function toString() : String {
        return "<Color: r:"+ red +" g:"+ green +" b:"+ blue +" a:"+ alpha +">";
    }

    public function equals(other:Color) : Bool {
        return(
            this.red == other.red &&
            this.green == other.green &&
            this.blue == other.blue &&
            this.alpha == other.alpha);
    }
}
