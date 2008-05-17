package proxe.graphics;

import proxe.Color;

enum GraphicType {
    MOCK;
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

enum EllipseMode {
    CENTER;
    RADIUS;
    CORNER;
    CORNERS;
}

class Graphics {

    /**
     * The type of shape the graphics is currently drawing.  If the graphics is
     * not currently drawing anything, this should be null.  Possible values for
     * this variable can be found in the above `ShapeType` enum.
     */
    public var currentShapeType:ShapeType;

    /**
     * Current shape depth for this graphics
     */
    public var shapeDepth:Int;

    /**
     * Current number of calls to the `vertex` method since the last
     * `beginShape`
     */
    public var vertexDepth:Int;

    /**
     * List of verticies collected between calling `beingShape()` and calling
     * `endShape()`.
     */
    var vertices:Array<Array<Float>>;

    private var fillColor:Color;
    private var strokeColor:Color;
    private var strokeWidth:Float;

    public var ellipseMode:EllipseMode;

    ////////////////////////////////////////////////////////////////////////////
    // Temporary Methods
    public function background(color:Color) {
        trace("Graphics.background() should not be called.");
        throw("Graphics.background() should not be called.");
    }

    public function point(x:Float, y:Float, ?z:Float) {
        trace("Graphics.point() should not be called.");
        throw("Graphics.point() should not be called.");
    }

    public function ellipse(x:Float, y:Float, width:Float, height:Float) {
        if(ellipseMode == null) {
            ellipseMode = CENTER;
        }
        
        switch ellipseMode {
            case CENTER:
                drawEllipse(x-(width/2), y-(height/2), width, height);
            case CORNER:
                drawEllipse(x, y, width, height);
            default:
                trace("Unknown ellipseMode: "+ ellipseMode);
                throw("Unknown ellipseMode: "+ ellipseMode);
        }
    }

    public function drawEllipse(x:Float, y:Float, width:Float, height:Float) {
        trace("drawEllipse not implemented");
        throw("drawEllipse not implemented");
    }

    ////////////////////////////////////////////////////////////////////////////
    // Vertex Methods
    
    /**
     * Allows the graphics to start accepting vertices for a given shape.  Code
     * using this graphics library should be aware that before sending vertices
     * to a `Graphics`, a `beginShape` call must be made.
     *
     * By default, the shapeType will be POLYGON.
     *
     * If `beginShape` is called while another shape is in progress, this method
     * will throw an exception.
     * 
     * The following types of shapes are enabled by default (but, of couse,
     * could be overridden in a child class).
     *
     * == POINTS ==
     *  Will not draw connecting lines, or fill the contained area.  Will simply
     *  draw single points at the passes vertices
     * 
     * == POLYGON ==
     *  Default drawing style.  Given a set of points, it create a path through
     *  the points.  If a fillColor is given, it will close the path (regardless
     *  of `closeShape` being called with `CLOSE`), and fill the interior. 
     * 
     * == LINES ==
     *  Will take pairs of `vertex` method calls, and draw desperate lines
     *  between them.  Take the following code:
     *
     *      beginShape(LINES);
     *      vertex(30, 20);
     *      vertex(85, 20);
     *      vertex(85, 75);
     *      vertex(30, 75);
     *      endShape();
     *
     * Will draw two lines.  One from {30,20} to {85, 20}, and another line
     * between {85,75} and {30,75}, with nothing connecting the two.
     * 
     * == TRIANGLES ==
     * == TRIANGLE_FAN ==
     * == TRIANGLE_STRIP ==
     * == QUADS ==
     * == QUAD_STRIP ==
     *
     * @param shapeType:ShapeType   defines the type of shape to be drawn (via
     *                              following vertex() method calls). Valid
     *                              values are POINTS, POLYGON, LINES,
     *                              TRIANGLES, TRIANGLE_FAN, TRIANGLE_STRIP,
     *                              QUADS, and QUAD_STRIP.  See the above
     *                              documentation for more information.
     */
    public function beginShape(?shapeType:ShapeType) {
        if(shapeType == null) {
            shapeType = POLYGON;
        }

        #if neko
        if(shapeDepth == null) { shapeDepth = 0; }
        #end
        
        shapeDepth++;
        vertexDepth = 0;
        
        if(shapeDepth > 1) {
            throw "Already drawing "+ currentShapeType +", cannot draw new "
                + shapeType +".";
        }

        this.currentShapeType = shapeType;
        this.vertices = new Array<Array<Float>>();
    }

    /**
     * This is the companion to `beginShape`, and may only be called after
     * `beginShape`.  If a `beginShape` hasn't been called, this will throw an
     * exception.
     *
     * @param shapeClosingType  Either null or a member of `ShapeClosingType`.
     *                          If passed `CLOSE`, it will connect the last
     *                          vertex of the draw with the first, and attempt
     *                          to fill the internals.
     */
    public function endShape(?shapeClosingType:ShapeClosingType) {
        if(shapeClosingType == null) {
            shapeClosingType = OPEN;
        }

        if(shapeClosingType == CLOSE && vertices.length > 1) {
            var v:Array<Float> = vertices[0];
            vertices.push(v);
        }

        drawVertices(vertices, currentShapeType, shapeClosingType);
        
        shapeDepth--;
        vertexDepth = 0;
        currentShapeType = null;
    }

    public function vertex(x:Float, y:Float, ?z:Float) {
        vertexDepth++;
        
        var point:Array<Float> = [x, y, z];
        vertices.push(point);
    }

    ////////////////////////////////////////////////////////////////////////////
    // Shape Methods
    public function triangle(x1:Float, y1:Float, x2:Float, y2:Float,
        x3:Float, y3:Float) {

        beginShape(POLYGON);
        vertex(x1, y1);
        vertex(x2, y2);
        vertex(x3, y3);
        endShape(CLOSE);
    }

    public function rect(x:Float, y:Float, width:Float, height:Float) {
        beginShape(POLYGON);
        vertex(x, y);
        vertex(x+width, y);
        vertex(x+width, y+height);
        vertex(x, y+height);
        endShape(CLOSE);
    }

    /**
     * TODO: Only handles 2D lines
     */
    public function line(x1:Float, y1:Float, z1:Float,
        x2:Float, ?y2:Float, ?z2:Float) {

        beginShape(LINES);
        vertex(x1, y1);
        vertex(z1, x2);
        endShape();
    }

    ////////////////////////////////////////////////////////////////////////////
    // Color Methods
    public function stroke(color:Color) {
        this.strokeColor = color;
    }

    public function fill(color:Color) {
        this.fillColor = color;
    }

    public function strokeWeight(strokeWidth:Float) {
        this.strokeWidth = strokeWidth;
    }

    ////////////////////////////////////////////////////////////////////////////
    // Abstract Methods
    public function drawVertices(verticies:Array<Array<Float>>,
        openShapeType:ShapeType, closeShapeType:ShapeClosingType) {
        trace("Unimplemented: Graphics.drawVertices");
        throw "Unimplemented: Graphics.drawVerticies";
    }
}
