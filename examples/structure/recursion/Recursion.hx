
import proxe.Applet;

class Recursion extends Applet {

    public function setup() {
        size(200, 200);
        noStroke();
        // smooth();
        noLoop();
    }

    public function draw() {
        drawCircle(126, 170, 6);
    }

    public function drawCircle(x:Float, radius:Float, level) {                    
        var tt:Int = Math.floor(126 * level/4.0);
        fill(tt);
        ellipse(x, 100, radius*2, radius*2);      
        
        if(level > 1) {
            level = level - 1;
            drawCircle(x - radius/2, radius/2, level);
            drawCircle(x + radius/2, radius/2, level);
        }
    }


    public static function main() {
        new Recursion().init();
    }
}