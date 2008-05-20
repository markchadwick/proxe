package proxe;

class Vertex {
    public var x:Float;
    public var y:Float;
    public var z:Float;
    public var u:Float;
    public var v:Float;
    
    public function new (x:Float, ?y:Float, ?z:Float, ?u:Float, ?v:Float) {
        this.x = x;
        this.y = y;
        this.z = z;
        this.u = u;
        this.v = v;
    }
}