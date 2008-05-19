
import proxe.Applet;

class Recursion extends Applet {

    public function setup() {
        size(200, 200);
        noStroke();
        // smooth();
        drawCircle(100, 100, 80, 8);
    }

    /**
     * TODO: Implement PI, TWO_PI, et cetera constants
     */
    public function drawCircle(x:Float, y:Float, radius:Float, level:Float)  {                    
        var tt:Int = Math.floor(126 * level/6.0);
        var TWO_PI = Math.PI * 2;
        
        fill(tt, 153);
        ellipse(x, y, radius*2, radius*2);      
        
        if(level > 1) {
            level = level - 1;
            var num = Math.floor(random(2, 6));
            for(i in 0...num) {
                var a = random(0, TWO_PI);
                var nx = x + cos(a) * 6.0 * level;
                var ny = y + sin(a) * 6.0 * level;
                drawCircle(nx, ny, radius/2, level);
            }
        }
    }



    public static function main() {
        new Recursion().init();
    }
}