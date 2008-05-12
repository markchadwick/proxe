package proxe;

import flash.MovieClip;

class Main extends Canvas {
    
    var boxX:Int;
    
    public function new() {
        super();
        
        boxX = 50;
    }
    
    public function draw():Void {
        fill(200, 100, 100);
        rect([50, 50], [100, 100]);
        
        fill(100, 100, 200, 100);
        rect([80, 80], [130, boxX]);
        
        boxX++;
    }

    static function main() : Void {
        var m = new Main();
        //m.start();
    }
}
