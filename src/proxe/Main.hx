package proxe;

import proxe.Sprite;
import proxe.Color;

class Box {
    var sprite:Sprite;

    var x:Float;
    var y:Float;
    var size:Float;
    var stroke:Float;
    var fill:Color;
    
    public function new(sprite:Sprite) {
        this.sprite = sprite;

        size = sprite.random(5, 20);
        x = sprite.random(0, sprite.width - size);
        y = sprite.random(0, sprite.height - size);
    }

    public function draw() {
        sprite.stroke(0);
        sprite.strokeWeight(1);
        sprite.fill(100, 100, 100, 100);
        sprite.rect(x, y, size, size);
    }
}

class Main extends Sprite {
    var boxes:Array<Box>;
    
    public function setup() {
        size(400, 300);

        boxes = new Array<Box>();
        for(i in 0...100) {
            boxes.push( new Box(this) );
        }
    }
    
    public function draw() {
        background(200, 210, 220);
        
        fill(200, 150, 150, 100);
        stroke(255, 0, 0, 100);
        strokeWeight(10);
        triangle(
            width/2, 0,
            width, height-2,
            0, height-2
        );

        for(box in boxes) {
            box.draw();
        }
    }

    static function main() {
        var m = new Main();
        m.setup();
        m.draw();
    }
}
