import proxe.Applet;
import proxe.Color;

class SimpleCurves extends Applet {

    private static var PI:Float = Math.PI;

    public function setup() {
        size(200, 200);
        colorMode(RGB, 100);
        background(0);
        noFill();
        noLoop();
    }
    
    public function draw() {
        stroke(40);
        beginShape();
        for(i in 0...width) {
            vertex(i, singraph(i/width)*height);
        }
        endShape();

        stroke(55);
        beginShape();
        for(i in 0...width) {
            vertex(i, quadratic(i/width)*height);
        }
        endShape();

        stroke(70);
        beginShape();
        for(i in 0...width) {
            vertex(i, quadHump(i/width)*height);
        }
        endShape();

        stroke(85);
        beginShape();
        for(i in 0...width) {
            vertex(i, hump(i/width)*height);
        }
        endShape();

        stroke(100);
        beginShape();
        for(i in 0...width) {
            vertex(i, squared(i/width)*height);
        }
        endShape();
    }
    
    function singraph(sa:Float) {
        sa = (sa - 0.5) * 1.0; //scale from -1 to 1
        sa = sin(sa*PI)/2 + 0.5;
        return sa;
    }

    function quadratic(sa:Float) {
        return sa*sa*sa*sa;
    }

    function quadHump(sa:Float) {
        sa = (sa - 0.5); //scale from -2 to 2
        sa = sa*sa*sa*sa * 16;
        return sa;
    }

    function hump(sa:Float) {
        sa = (sa - 0.5) * 2; //scale from -2 to 2
        sa = sa*sa;
        if(sa > 1) { sa = 1; }
        return 1-sa;
    }

    function squared(sa:Float) {
        sa = sa*sa;
        return sa;
    }

    
    public static function main() {
        new SimpleCurves().init();
    }
}