package proxe.graphics;

import proxe.Applet;
import proxe.Color;

enum RectMode {
    CORNERS;
    CORNER;
    RADIUS;
    CENTER;
}

enum ShapeType {
    POINTS;
    POLYGON;
    LINES;
    TRIANGLES;
    TRIANGLE_FAN;
    TRIANGLE_STRIP;
    QUADS;
    QUAD_STRIP;
}

enum ShapeClosingType {
    OPEN;
    CLOSE;
}

class Graphics {

    /**
     * Width of the current Graphics
     */
    public var width:Int;
    
    /**
     * Height of the current Graphics
     */
    public var height:Int;
    
    /**
     * "Path" of the current Graphics.  This is used for saving file (if the
     * graphics enables it).
     */
    public var path:String;
    
    /**
     * Current mode to draw a rectagle.
     */
    public var currentRectMode:RectMode;
    
    /**
     * Applent parent of this graphics
     */
    public var parent:Applet;
    
    public var backgroundColor:Color;
    public var fillColor:Color;
    public var strokeColor:Color;
    
    ////////////////////////////////////////////////////////////////////////////
    // Abstract Methods
    public function clear() {
        trace("Abstract Method: Graphics.clear()");
        throw("Abstract Method: Graphics.clear()");
    }
    
    
    public function beginShape(?shapeType:ShapeType) {
        trace("Abstract Method: Graphics.beginShape()");
        throw("Abstract Method: Graphics.beginShape()");
    }
    
    public function endShape(?shapeClosingType:ShapeClosingType) {
        trace("Abstract Method: Graphics.endShape()");
        trace("Abstract Method: Graphics.endShape()");
    }
    
    public function vertex(x:Float, y:Float, ?z:Float, ?u:Float, ?v:Float) {
        trace("Abstract Method: Graphics.vertex()");
        throw("Abstract Method: Graphics.vertex()");
    }

    ////////////////////////////////////////////////////////////////////////////
    // Utility Methods
    
    /**
     * Sets various defaults for a drawing graphics (should likely be called
     * by an implementing Graphics to avoid null pointers.
     */
    public function defaults() {
        currentRectMode = CENTER;
        backgroundColor = Color.resolve(200);
        fillColor = Color.resolve(255);
        strokeColor = Color.resolve(0);
    }
    
    ////////////////////////////////////////////////////////////////////////////
    // Drawing Methods
    
    /**
     * Clears the current drawing surface, and fills it solidly with the given
     * color.
     *
     * @todo Might have to shuffle that rect
     */
    public function background(color:Color) {
        backgroundColor = color;
        
        clear();
        
        var oldFill = fillColor;
        var oldStroke = strokeColor;
        
        fillColor = backgroundColor;
        strokeColor = Color.NONE;
        
        rect(0, 0, width, height);
    }
    
    /**
     * Rectangle
     */
    public function rect(x1:Float, y1:Float, x2:Float, y2:Float) {
        var hRadius:Float;
        var vRadius:Float;
        
        switch (currentRectMode) {
            case CORNERS:
            
            case CORNER:
                x2 += x1;
                y2 += y1;

            case RADIUS:
                hRadius = x2;
                vRadius = y2;
                
                x2 = x1 + hRadius;
                y2 = y1 + vRadius;
                
                x1 -= hRadius;
                y1 -= vRadius;

            case CENTER:
                hRadius = x2 / 2;
                vRadius = y2 / 2;
                
                x2 = x1 + hRadius;
                y2 = y1 + vRadius;
                
                x1 -= hRadius;
                y1 -= vRadius;
        }

        if (x1 > x2) {
            var temp:Float = x1;
            x1 = x2;
            x2 = temp;
        }

        if (y1 > y2) {
            var temp:Float = y1;
            y1 = y2;
            y2 = temp;
        }

        trace("Drawing Rect");
        rectImpl(x1, y1, x2, y2);
    }
    
    /**
     * Quadratic
     */
    public function quad(x1:Float, y1:Float, x2:Float, y2:Float,
                         x3:Float, y3:Float, x4:Float, y4:Float) {
        
        trace("Begin Shape");
        beginShape(QUADS);
        
        trace("Vertex 1");
        vertex(x1, y1);
        
        trace("Vertex 2");
        vertex(x2, y2);
        vertex(x3, y3);
        vertex(x4, y4);
        
        trace("End shape");
        endShape();
  }
    
    ////////////////////////////////////////////////////////////////////////////
    // Private Methods
    private function rectImpl(x1:Float, y1:Float, x2:Float, y2:Float) {
        quad(x1, y1,  x2, y1,  x2, y2,  x1, y2);
    }

}
