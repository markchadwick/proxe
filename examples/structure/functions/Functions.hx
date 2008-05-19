
import proxe.Applet;

class Functions extends Applet {

    public function setup() {
        size(200, 200);
        background(100);
        
        noStroke();
        // smooth();
        noLoop();
    }
    
    public function draw() {
        draw_target(68, 34, 200, 10);
        draw_target(152, 16, 100, 3);
        draw_target(100, 144, 80, 5);
    }

    function draw_target(xloc, yloc, size, num)  {
        var grayvalues:Float = 255/num;
        var steps:Float = size/num;
        
        for(i in 0...num) {
            fill(Math.floor(i*grayvalues));
            ellipse(xloc, yloc, size-i*steps, size-i*steps);
        }
    }

    public static function main() {
        new Functions().init();
    }
}