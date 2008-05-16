package proxe;

import proxe.Sprite;

class Main extends Sprite {
    public function setup() {
        size(300, 400);
        trace("setup()");
    }
    
    public function draw() : Void {
        background(200, 210, 220);
        
        trace("Draw");
    }

    static function main() : Void {
        new Main().init();
    }
}
