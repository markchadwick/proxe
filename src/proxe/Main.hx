package proxe;

import flash.MovieClip;

class Main extends Canvas {
    
    public function draw():Void {
        background();
        
        fill(200, 100, 100);
        rect([50, 50], [100, 100]);
        
        fill(100, 100, 200, 100);
        rect([80, 80], [130, 130]);
    }

    private function background():Void {
        fill(255, 255, 255);
        rect([0, 0], [width, height]);
    }

    static function main() : Void {
        var m = new Main();
        m.draw();
    }
}