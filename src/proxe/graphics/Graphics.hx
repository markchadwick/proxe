package proxe.graphics;

import proxe.Applet;
import proxe.Color;
import proxe.Vertex;

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
    public var currentRectMode:ShapeMode;
    public var currentEllipseMode:ShapeMode;
    
    /**
     * Applent parent of this graphics
     */
    public var parent:Applet;
    
    public var looping:Bool;
    
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
    
    public function frameRate(frameRate:Float) {
        trace("Abstract Method: Graphics.frameRate()");
        throw("Abstract Method: Graphics.frameRate()");
    }
    
    public function loop() {
        trace("Abstract Method: Graphics.loop()");
        throw("Abstract Method: Graphics.loop()");
    }
    
    public function noLoop() {
        trace("Abstract Method: Graphics.noLoop()");
        throw("Abstract Method: Graphics.noLoop()");
    }
    
    public function redraw() {
        trace("Abstract Method: Graphics.redraw()");
        throw("Abstract Method: Graphics.redraw()");
    }
    
    ////////////////////////////////////////////////////////////////////////////
    // Vertex Methods
    
    public function beginShape(shapeType:ShapeType) {
        this.currentShapeType = shapeType;
        this.vertices = new Array<Vertex>();
    }
    
    public function endShape(shapeClosingType:ShapeClosingType) {
        this.currentShapeClosingType = shapeClosingType;
        
        if(shapeClosingType == CLOSE && vertices.length > 1) {
            vertices.push( vertices[0] );
        }
        
        drawVertices();
    }
    
    public function vertex(v:Vertex) {
        switch(currentShapeType) {
            case POINTS:
                vertices.push(v);
                
            case POLYGON:
                vertices.push(v);
                
            case LINES:
                vertices.push(v);
                
            case TRIANGLES:
                vertices.push(v);
                
            case TRIANGLE_FAN:
                vertices.push(v);
                
            case TRIANGLE_STRIP:
                vertices.push(v);
                
            case QUADS:
                vertices.push(v);
                
            case QUAD_STRIP:
                vertices.push(v);
        }
    }

    public function curveVertex(v:Vertex) {
        splineVertex(v, false);
    }

    ////////////////////////////////////////////////////////////////////////////
    // Utility Methods
    
    /**
     * Sets various defaults for a drawing graphics (should likely be called
     * by an implementing Graphics to avoid null pointers.
     */
    public function defaults() {
        currentRectMode = CORNER;
        currentEllipseMode = CENTER;
        backgroundColor = Color.resolve(200);
        fillColor = Color.resolve(255);
        strokeColor = Color.resolve(0);
        looping = true;
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
        
        fillColor = oldFill;
        strokeColor = oldStroke;
    }
    
    public function point(v:Vertex) {
        beginShape(POINTS);
        vertex(v);
        endShape(OPEN);
    }
    
    public function line(from:Vertex, to:Vertex) {
        beginShape(LINES);
        vertex(from);
        vertex(to);
        endShape(OPEN);
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
    

    public function quad(x1:Float, y1:Float,
                         x2:Float, y2:Float,
                         x3:Float, y3:Float,
                         x4:Float, y4:Float) {
        beginShape(QUADS);
        vertex(new Vertex(x1, y1));
        vertex(new Vertex(x2, y2));
        vertex(new Vertex(x3, y3));
        vertex(new Vertex(x4, y4));
        endShape(CLOSE);
    }
    

    public function triangle(v1:Vertex, v2:Vertex, v3:Vertex) {
        beginShape(TRIANGLES);
        vertex(v1);
        vertex(v2);
        vertex(v3);
        endShape(CLOSE);
    }

    public function ellipse(v1:Vertex, v2:Vertex) {
        var x:Float = v1.x;
        var y:Float = v1.y;
        var width:Float = v2.x;
        var height:Float = v2.y;
    
        switch(currentEllipseMode) {
            case CORNERS:
                width -= x;
                height -= y;
                
            case RADIUS:
                x -= width;
                y -= height;
                width *= 2;
                height *= 2;
                
            case CENTER:
                x -= width/2;
                y -= height/2;
                
            case CORNER:
        }
        
        if(width < 0) {
            x += width;
            width = -width;
        }
        
        if(height < 0) {
            y += height;
            height = -height;
        }
        
        ellipseImpl(x, y, width, height);
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
    // Drawing Methods
    
    public function rectMode(mode:ShapeMode) {
        this.currentRectMode = mode;
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
    
    private function ellipseImpl(x:Float, y:Float, width:Float, height:Float) {
        var TWO_PI:Float = Math.PI * 2;
        var hRadius:Float = width / 2;
        var vRadius:Float = height / 2;

        var centerX:Float = x + hRadius;
        var centerY:Float = y + vRadius;

        var resolution:Float = 4 + Math.sqrt(hRadius + vRadius) * 3;
        var thetaStep:Float = TWO_PI / resolution;
                
        var i:Float = 0;
        
        beginShape(POLYGON);
        while(i <= TWO_PI) {
            vertex(new Vertex(centerX + Math.cos(i) * hRadius,
                              centerY + Math.sin(i) * vRadius));
            i += thetaStep;
        }
        endShape(CLOSE);
    }
    
    private function splineVertex(v:Vertex, bezier:Bool) {
        vertex(v);
    }

}
