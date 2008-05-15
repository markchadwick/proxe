package proxe;

class Box {
    var canvas:Canvas;
    
    public var color:proxe.Color;
    
    var x:Float;
    var y:Float;
    var width:Float;
    var height:Float;
    
    var xVel:Float;
    var yVel:Float;
    
    public function new(canvas:Canvas) {
        this.canvas = canvas;
        
        width = 20;
        height = 20;
        
        x = Math.random() * (canvas.width - width);
        y = Math.random() * (canvas.height - height);
        
        xVel = 1 + Math.random() * 6;
        yVel = 1 + Math.random() * 6;
    }
    
    public function draw() {
        if(x+width >= canvas.width || x <= 0) {
            xVel *= -1;
        }
        
        if(y+height >= canvas.height || y <= 0) {
            yVel *= -1;
        }
        
        x += xVel;
        y += yVel;
        
        canvas.fill(200, 100, 100, 100);
        canvas.rect([x, y], [this.width, this.height]);
    }
}

class Main extends Canvas {
    var boxes:Array<Box>;
    
    public function setup() {
        boxes = new Array<Box>();
        
        for(i in 0...100) {
            boxes.push(new Box(this));
        }
    }
    
    public function draw(?_) : Void {
        background(200, 210, 220);

        for(box in boxes) {
            box.draw();
        }
    }

    static function main() : Void {
        var m = new Main();
    }
}
