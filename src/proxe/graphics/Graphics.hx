package proxe.graphics;

class Graphics {
    /**
     * TODO: Graphics shouldn't have a constructor!
     */
    public function new() {
    }
    
    ////////////////////////////////////////////////////////////////////////////
    // Color Methods
    
    /**
     * Red channel component of a packed color integer
     */
    public function red(r:Int) : Int {
        return (r >> 16) & 0xff;
    }
    
    /**
     * Green channel component of a packed color integer
     */
    public function green(g:Int) : Int {
        return (g >> 8) & 0xff;
    }
    
    /**
     * Blue channel component of a packed color integer
     */
    public function blue(b:Int) : Int {
        return b & 0xff;
    }
    
    /**
     * Alpha channel component of a packed color integer
     */
    public function alpha(a:Int) : Int {
        return (a >> 24);
    }
}
