package proxe.graphics;

import proxe.Color;
import proxe.graphics.Graphics;

class Graphics3D extends Graphics {
    
    // cheap picking someday - Ben Fry
    public var shape_index:Int;
    
    // pos of first vertex of current shape in vertices array
    public var vertex_start:Int;

    // i think vertex_end is actually the last vertex in the current shape
    // and is separate from vertexCount for occasions where drawing happens
    // on endDraw() with all the triangles being depth sorted
    public var vertex_end:Int;

    // vertices may be added during clipping against the near plane.
    public var vertex_end_including_clip_verts:Int;
    
    ////////////////////////////////////////////////////////////////////////////
    // Impl Methods
    
    /**
     * Clear pixel buffer. With P3D and OPENGL, this also clears the zbuffer.
     * Stencil buffer should also be cleared, but for now is ignored in P3D.
     */
    public function clear() {
        fillArray(pixels, backgroundColor.toInt());
        
        // TODO: Put actual MAX_VALUE here
        fillArray(zBuffer, 99999);
    
        clearRaw();
    }

    public function clearRaw() {
        if (raw != null) {
            raw.stroke(Color.NONE);
            raw.fill(backgroundColor);
            raw.beginShape(TRIANGLES);

            raw.vertex(0, 0);
            raw.vertex(width, 0);
            raw.vertex(0, height);

            raw.vertex(width, 0);
            raw.vertex(width, height);
            raw.vertex(0, height);

            raw.endShape();
        }
    }


    ////////////////////////////////////////////////////////////////////////////
    // Vertex Methods
    public function beginShape(kind:ShapeType) {
        shape = kind;

        shape_index = shape_index + 1;
        
        if (shape_index == -1) {
            shape_index = 0;
        }

        // TODO: Damn, this is ugly
        if (hints.get(""+ ENABLE_DEPTH_SORT)) {
            vertex_start = vertexCount;
            vertex_end = 0;
        } else {
            // reset vertex, line and triangle information
            // every shape is rendered at endShape();
            vertexCount = 0;
            if (line != null) {
                line.reset();  // necessary?
            }
            lineCount = 0;
            pathCount = 0;
            
            if (triangle != null) {
                triangle.reset();  // necessary?
            }
            triangleCount = 0;
        }
        
        textureImage = null;

        splineVertexCount = 0;
        
        normalMode = AUTO_NORMAL;
        normalCount = 0;
    }

    ////////////////////////////////////////////////////////////////////////////
    // Private Methods

    private static function fillArray(buf:Array<Dynamic>, val:Dynamic) {
        for(i in 0...buf.length) {
            buf[i] = val;
        }
    }
}
