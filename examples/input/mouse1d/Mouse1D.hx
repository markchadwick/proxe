import proxe.Applet;

class Mouse2D extends Applet {

    var gx:Int;
    var gy:Int;
    var leftColor:Float;
    var rightColor:Float;


    public function setup() {
        size(200, 200);
//        colorMode(RGB, 1.0);
        noStroke();
        
        gx = 15;
        gy = 35;
        leftColor = 0;
        rightColor = 0;
    }
    
    /**
     * TODO: wrong alphas due to colorMode
     */
    public function draw() {
        background(0);
        update(mouseX); 
        fill(0, leftColor + 0.4, leftColor + 0.6);
        rect(width/4-gx, width/2-gx, gx*2, gx*2); 
        fill(0, rightColor + 0.2, rightColor + 0.4); 
        rect(width/1.33-gy, width/2-gy, gy*2, gy*2);
    }
    
    public function update(x:Int) {
        leftColor = -0.002 * x/2 + 0.06;
        rightColor =  0.002 * x/2 + 0.06;

        gx = x/2;
        gy = 100-x/2;

        if (gx < 10) {
            gx = 10;
        } else if (gx > 90) {
            gx = 90;
        }

        if (gy > 90) {
            gy = 90;
        } else if (gy < 10) {
            gy = 10;
        }
    }

    
    public static function main() {
        new Mouse2D().init();
    }
}