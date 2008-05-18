package proxe.graphics;

import proxe.graphics.Graphics;

class Graphics3D extends Graphics {
    
    /**
     * Clear pixel buffer. With P3D and OPENGL, this also clears the zbuffer.
     * Stencil buffer should also be cleared, but for now is ignored in P3D.
     */
    public function clear() {
        fillArray(pixels, backgroundColor.toInt());
        fillArray(zBuffer, Float.MAX_VALUE);
    
        clearRaw();
    }

    public function clearRaw() {
        if (raw != null) {
            raw.colorMode(RGB, 1);
            raw.noStroke();
            raw.fill(backgroundR, backgroundG, backgroundB);
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
    // Private Methods

    private static function fillArray(buf:Array<Dynamic>, val:Dynamic) {
        for(i in 0...buf.length) {
            buf[i] = val;
        }
    }
}
