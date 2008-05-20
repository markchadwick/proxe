import proxe.Applet;

class ShapePrimitives extends Applet {

    public function setup() {
        size(200, 200);
//        smooth(); 
        background(0);
        noStroke();
        fill(226);
        triangle(10, 10, 10, 200, 45, 200);
        rect(45, 45, 35, 35);
        quad(105, 10, 120, 10, 120, 200, 80, 200);
        ellipse(140, 80, 40, 40);
        triangle(160, 10, 195, 200, 160, 200); 
    }
    
    public static function main() {
        new ShapePrimitives().init();
    }
}