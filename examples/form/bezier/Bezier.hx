import proxe.Applet;

class Bezier extends Applet {

    public function setup() {
        size(200, 200); 
        background(0); 
        stroke(255);
        // smooth();

        for(i in 0...10) {
            var j = i * 10;
            bezier(90-(j/2.0), 20+i, 210, 10, 220, 150, 120-(j/8.0), 150+(j/4.0));
        }
    }
    
    public static function main() {
        new Bezier().init();
    }
}