package proxe.graphics.shape;

import proxe.Vertex;
import proxe.graphics.Graphics;

class Curve {
    public var currentBezierDetail:Int;

    private var graphics:Graphics;
    
    private var splineVertices:Array<Vertex>;
    private var splineVertexCount:Int;
    
    private var bezierInitialized:Bool;
    private var curveInitialized:Bool;

    private var bezierBasis:Array<Array<Float>>;
    private var bezierForwardMatrix:Array<Array<Float>>;
    private var bezierDrawMatrix:Array<Array<Float>>;

    public function new(graphics:Graphics) {
        this.graphics = graphics;
        
        bezierInitialized = false;
        curveInitialized = false;
        
        splineVertices = new Array<Vertex>();
        splineVertexCount = 0;
        
        bezierDetail(20);
        
        bezierBasis = new Array<Array<Float>>();
        bezierBasis.push([-1,  3, -3,  1]);
        bezierBasis.push([ 3, -6,  3,  0]);
        bezierBasis.push([-3,  3,  0,  0]);
        bezierBasis.push([ 1,  0,  0,  0]);
    }

    public function splineVertex(v:Vertex, bezier:Bool) {
        splineVertices.push(v);
        splineVertexCount++;
        
        var dimensions = (v.z == null)? 2 : 3;
        
        if (splineVertices.length < 3) {
            return;
        }
        
        if (bezier) {
            if ((splineVertices.length % 4) == 0) {
                if(!bezierInitialized) {
                    bezierDetail();
                }
                splineSegment(splineVertexCount-4,
                              splineVertexCount-4,
                              bezierDrawMatrix, dimensions,
                              currentBezierDetail);
            }
        } else {
            if (!curveInitialized) {
                initializeCurve();
            }
            splineSegment(splineVertexCount-4,
                          splineVertexCount-3,
                          curve_draw, dimensions,
                          curveDetail);
        }
    }
    
    private function bezierDetail(?detail:Int) {
        if(detail == null) {
            detail = currentBezierDetail;
        }
        currentBezierDetail = detail;
        bezierInitialized = true;
        
        setupSplineForward(detail, bezierForwardMatrix);
        multSplineMatrix(bezierForwardMatrix, bezierBasis, bezierDrawMatrix, 4);
    }
    
    
    private function setupSplineForward(segments:Int, fwd:Array<Array<Float>>) {
        var f:Float  = 1.0 / segments;
        var ff:Float = f * f;
        var fff:Float = ff * f;

        fwd[0][0] = 0;     fwd[0][1] = 0;    fwd[0][2] = 0; fwd[0][3] = 1;
        fwd[1][0] = fff;   fwd[1][1] = ff;   fwd[1][2] = f; fwd[1][3] = 0;
        fwd[2][0] = 6*fff; fwd[2][1] = 2*ff; fwd[2][2] = 0; fwd[2][3] = 0;
        fwd[3][0] = 6*fff; fwd[3][1] = 0;    fwd[3][2] = 0; fwd[3][3] = 0;
    }
    
    private function multSplineMatrix(m:Array<Array<Float>>, g:Array<Array<Float>>,
                                    mg:Array<Array<Float>>, dimensions:Int) {
        for (i in 0...4) {
            for (j in 0...dimensions) {
                mg[i][j] = 0;
            }
        }
        
        for (i in 0...4) {
            for (j in 0...dimensions) {
                for (k in 0...4) {
                    mg[i][j] = mg[i][j] + (m[i][k] * g[k][j]);
                }
            }
        }
    }
    
    private function splineSegment(offset:Int, start:Int, m:Array<Array<Float>>,
                                   dimensions:Int, segments:Int) {
                                   
        var x1:Float = splineVertices[offset+0].x;
        var x2:Float = splineVertices[offset+1].x;
        var x3:Float = splineVertices[offset+2].x;
        var x4:Float = splineVertices[offset+3].x;
        var x0:Float = splineVertices[start].x;

        var y1:Float = splineVertices[offset+0].y;
        var y2:Float = splineVertices[offset+1].y;
        var y3:Float = splineVertices[offset+2].y;
        var y4:Float = splineVertices[offset+3].y;
        var y0:Float = splineVertices[start].y;

        var xplot1:Float = m[1][0]*x1 + m[1][1]*x2 + m[1][2]*x3 + m[1][3]*x4;
        var xplot2:Float = m[2][0]*x1 + m[2][1]*x2 + m[2][2]*x3 + m[2][3]*x4;
        var xplot3:Float = m[3][0]*x1 + m[3][1]*x2 + m[3][2]*x3 + m[3][3]*x4;

        var yplot1:Float = m[1][0]*y1 + m[1][1]*y2 + m[1][2]*y3 + m[1][3]*y4;
        var yplot2:Float = m[2][0]*y1 + m[2][1]*y2 + m[2][2]*y3 + m[2][3]*y4;
        var yplot3:Float = m[3][0]*y1 + m[3][1]*y2 + m[3][2]*y3 + m[3][3]*y4;

        var cVertexSaved:Int = splineVertexCount;

        if (dimensions == 3) {
                var z1:Float = splineVertices[offset+0].z;
                var z2:Float = splineVertices[offset+1].z;
                var z3:Float = splineVertices[offset+2].z;
                var z4:Float = splineVertices[offset+3].z;
                var z0:Float = splineVertices[start].z;

                var zplot1:Float = m[1][0]*z1 + m[1][1]*z2 + m[1][2]*z3 + m[1][3]*z4;
                var zplot2:Float = m[2][0]*z1 + m[2][1]*z2 + m[2][2]*z3 + m[2][3]*z4;
                var zplot3:Float = m[3][0]*z1 + m[3][1]*z2 + m[3][2]*z3 + m[3][3]*z4;

                graphics.vertex(new Vertex(x0, y0, z0));

                for (j in 0...segments) {
                    x0 += xplot1; xplot1 += xplot2; xplot2 += xplot3;
                    y0 += yplot1; yplot1 += yplot2; yplot2 += yplot3;
                    z0 += zplot1; zplot1 += zplot2; zplot2 += zplot3;
                    graphics.vertex(new Vertex(x0, y0, z0));
                }
            } else {
                graphics.vertex(new Vertex(x0, y0));

                for (j in 0...segments) {
                    x0 += xplot1; xplot1 += xplot2; xplot2 += xplot3;
                    y0 += yplot1; yplot1 += yplot2; yplot2 += yplot3;
                    graphics.vertex(new Vertex(x0, y0));
                }
            }
            splineVertexCount = cVertexSaved;
    }
}