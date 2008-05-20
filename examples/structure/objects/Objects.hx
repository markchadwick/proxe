
import proxe.Applet;

/**
 * TODO: Not a great sale
 */
class Objects extends Applet {

    var r1:MRect;
    var r2:MRect;
    var r3:MRect;
    var r4:MRect;

    public function setup() {
        size(200, 200);
        fill(255);
        
        noStroke();
        
        r1 = new MRect(this, 1, 134.0, 0.532,  0.083*height,  10.0, 60);
        r2 = new MRect(this, 2, 44.0,  0.166,  0.332*height,  5.0,  50);
        r3 = new MRect(this, 2, 58.0,  0.332,  0.4482*height, 10.0, 35);
        r4 = new MRect(this, 1, 120.0, 0.0498, 0.913*height,  15.0, 60);
    }

    public function draw() {
        background(0);
        
        r1.display();
        r2.display();
        r3.display();
        r4.display();
        
        r1.moveToX(mouseX-(width/2), 30);
        r2.moveToX((mouseX+(width*0.05))%width, 20);
        r3.moveToX(mouseX/4, 40);
        r4.moveToX(mouseX-(width/2), 50);

        r1.moveToY(mouseY+(height*0.1), 30);
        r2.moveToY(mouseY+(height*0.025), 20);
        r3.moveToY(mouseY-(height*0.025), 40);
        r4.moveToY((height-mouseY), 50);
    }
 
    public static function main() {
        new Objects().init();
    }
}

class MRect {
    var applet:Applet;
    var w:Float;      // single bar width
    var xpos:Float; // rect x-position
    var h:Float;    // rect height
    var ypos:Float; // rect yposition
    var d:Float;    // single bar distance
    var t:Int;      // number of bars
    
    public function new(applet, iw, ixp, ih, iyp, id, it) {
        this.applet = applet;
        w = iw;
        xpos = ixp;
        h = ih;
        ypos = iyp;
        d = id;
        t = it;
    }
    
    public function moveToY(posY:Float, damping:Float) {
        var dif = ypos - posY;
        if(applet.abs(dif) > 1) {
            ypos -= dif/damping;
        }
    }
    
    public function moveToX(posX:Float, damping:Float) {
        var dif = xpos -posX;
        if(applet.abs(dif) > 1) {
            xpos -= dif/damping;
        }
    }
    
    public function display() {
        for(i in 0...t) {
            applet.rect(xpos+(i*(d+w)), ypos, w, applet.height*h);
        }
    }
}