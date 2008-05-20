import proxe.Applet;

class Mouse2D extends Applet {

    public function setup() {
        size(200, 200); 
        noStroke();
//        colorMode(RGB, 255, 255, 255, 100);
        rectMode(CENTER);
    }
    
    /**
     * TODO: wrong alphas due to colorMode
     */
    public function draw() {
        background(51);
        fill(255, 204);
        rect(mouseX, height/2, mouseY/2+10, mouseY/2+10);
        fill(255, 204);
        rect(width-mouseX, height/2, ((height-mouseY)/2)+10, ((height-mouseY)/2)+10);
    }
    
    public static function main() {
        new Mouse2D().init();
    }
}