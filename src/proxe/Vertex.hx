package proxe;

class Vertex {
    public var dimensionality:Int;

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
        
        computeDimensionality();
    }
    
    
    ///////////////////////////////////////////////////////////////////////////
    // Private Methods
    
    /**
     * Computes the dimensionality of the current vertex
     */
    private function computeDimensionality() {
        dimensionality = 3;
//        if(v == null) {
//            if(u == null) {
//                if(z == null) {
//                    if(y == null) {
//                        dimensionality = 1;
//                        return;
//                    }
//                    dimensionality = 2;
//                    return;
//                }
//                dimensionality = 3;
//                return;
//            }
//            dimensionality = 4;
//            return;
//        }
//        dimensionality = 5;
    }
}