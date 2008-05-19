package proxe.graphics;

import proxe.Applet;
import proxe.Color;
import proxe.Vertex;

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
    
    
    /**
     * Type of the current shape being drawn
     */
    public var currentShapeType:ShapeType;
    public var currentShapeClosingType:ShapeClosingType;
    
    public var vertices:Array<Vertex>;
    
    public var backgroundColor:Color;
    public var fillColor:Color;
    public var strokeColor:Color;
    public var strokeWidth:Float;
    
    ////////////////////////////////////////////////////////////////////////////
    // Abstract Methods
    public function clear() {
        trace("Abstract Method: Graphics.clear()");
        throw("Abstract Method: Graphics.clear()");
    }
    
    public function drawVertices() {
        trace("Abstract Method: Graphics.drawVertices()");
        throw("Abstract Method: Graphics.drawVertices()");
    }
    
    
    ////////////////////////////////////////////////////////////////////////////
    // Vertex Methods
    public function beginShape(?shapeType:ShapeType) {
        if(shapeType == null) {
            shapeType = POLYGON;
        }
        this.currentShapeType = shapeType;
        this.vertices = new Array<Vertex>();
    }
    
    public function endShape(?shapeClosingType:ShapeClosingType) {
        if(shapeClosingType == null) {
            shapeClosingType = OPEN;
        }
        
        this.currentShapeClosingType = shapeClosingType;
        
        if(shapeClosingType == CLOSE && vertices.length > 1) {
            vertices.push( vertices[0] );
        }
        
        drawVertices();
    }
    
    public function vertex(v:Vertex) {
        vertices.push( v );
    }


    ////////////////////////////////////////////////////////////////////////////
    // Utility Methods
    
    /**
     * Sets various defaults for a drawing graphics (should likely be called
     * by an implementing Graphics to avoid null pointers.
     */
    public function defaults() {
        currentRectMode = CORNER;
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
        
        fill(backgroundColor);
        stroke(Color.NONE);
        
        rectImpl(new Vertex(0, 0), new Vertex(width, height));
    }
    
    public function point(v:Vertex) {
        beginShape(POINTS);
        vertex(v);
        endShape();
    }
    
    public function line(from:Vertex, to:Vertex) {
        beginShape(LINES);
        vertex(from);
        vertex(to);
        endShape();
    }
    
    /**
     * Rectangle
     */
    public function rect(v1:Vertex, v2:Vertex) {
        var hRadius:Float;
        var vRadius:Float;
        
        switch (currentRectMode) {
            case CORNERS:
            
            case CORNER:
                v2.x += v1.x;
                v2.y += v1.y;

            case RADIUS:
                hRadius = v2.x;
                vRadius = v2.y;
                
                v2.x = v1.x + hRadius;
                v2.y = v1.y + vRadius;
                
                v1.x -= hRadius;
                v1.y -= vRadius;

            case CENTER:
                hRadius = v2.x / 2;
                vRadius = v2.y / 2;
                
                v2.x = v1.x + hRadius;
                v2.y = v1.y + vRadius;
                
                v1.x -= hRadius;
                v1.y -= vRadius;
        }

        if (v1.x > v2.x) {
            var temp:Float = v1.x;
            v1.x = v2.x;
            v2.x = temp;
        }

        if (v1.y > width) {
            var temp:Float = v1.x;
            v1.y = v2.y;
            v2.y = temp;
        }

        rectImpl(v1, v2);
    }
    
    /**
     * Quadratic
     */
    public function quad(x1:Float, y1:Float, x2:Float, y2:Float,
                         x3:Float, y3:Float, x4:Float, y4:Float) {
        beginShape(QUADS);
        vertex(new Vertex(x1, y1));
        vertex(new Vertex(x2, y2));
        vertex(new Vertex(x3, y3));
        vertex(new Vertex(x4, y4));
        endShape(CLOSE);
  }

    ////////////////////////////////////////////////////////////////////////////
    // Color Methods
    public function fill(color:Color) {
        this.fillColor = color;
    }
    
    public function stroke(color:Color) {
        this.strokeColor = color;
    }
    
    ////////////////////////////////////////////////////////////////////////////
    // Private Methods
    private function rectImpl(v1:Vertex, v2:Vertex) {
        quad(
            v1.x, v1.y,
            v2.x, v1.y,
            v2.x, v2.y,
            v1.x, v2.y
        );
    }

}
