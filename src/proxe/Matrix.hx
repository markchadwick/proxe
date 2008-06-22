package proxe;

import proxe.vertex;

/**
 * Essentially a 1:1 port of Processings [PMatrix] Class.  A 4-space Matrix
 * capible of doing a number of 3-space transforms
 */
class Matrix {

    private static var DEFAULT_STACK_DEPTH = 0;
    
    private var maxStackDepth:Int;
    
    var m00:Float;
    var m01:Float;
    var m02:Float;
    var m03:Float;
    
    var m10:Float;
    var m11:Float;
    var m12:Float;
    var m13:Float;
    
    var m20:Float;
    var m21:Float;
    var m22:Float;
    var m23:Float;
    
    var m30:Float;
    var m31:Float;
    var m32:Float;
    var m33:Float;
    
    /**
     * Implemtation of Processing's 3 PMatrix constructors
     *
     * Opt 1: No args
     *  Create the identity matrix with a default stack depth
     *
     * Opt 2: One arg
     *  Create the identity matrix with the given stack depth
     *
     * Opt 3: All Args
     *  Create the given matrix with the default depth
     */
    public function new(?m00:Float, ?m01:Float, ?m02:Float, ?m03:Float,
                        ?m10:Float, ?m11:Float, ?m12:Float, ?m13:Float,
                        ?m20:Float, ?m21:Float, ?m22:Float, ?m23:Float,
                        ?m30:Float, ?m31:Float, ?m32:Float, ?m33:Float) {
        if(m00 == null) {
            reset();
            this.maxStackDepth = DEFAULT_STACK_DEPTH;
        
        } else if (m01 == null) {
            reset();
            this.maxStackDepth = cast(m00, Int);
        
        } else {
            set(m00, m01, m02, m03,
                m10, m11, m12, m13,
                m20, m21, m22, m23,
                m30, m31, m32, m33);
            this.maxStackDepth = DEFAULT_STACK_DEPTH;
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////
    // Transformation Methods
    
    public function translate(v:Vertex) {
        m03 += (v.x * m00) + (v.y * m01) + (v.z * m02);
        m13 += (v.x * m10) + (v.y * m11) + (v.z * m12);
        m23 += (v.x * m20) + (v.y * m21) + (v.z * m22);
        m33 += (v.x * m30) + (v.y * m31) + (v.z * m32);
    }
    
    public function invTranslate(v:Vertex) {
        preApply(1, 0, 0, -v.x,
                 0, 1, 0, -v.y,
                 0, 0, 1, -v.z,
                 0, 0, 0, 1);
    }
    
    public function rotateX(angle:Float) {
        var c:Float = Math.cos(angle);
        var s:Float = Math.sin(angle);
        apply(1, 0, 0, 0,  0, c, -s, 0,  0, s, c, 0,  0, 0, 0, 1);
    }
    
    public function invRotateX(angle:Float) {
        var c:Float = Math.cos(-angle);
        var s:Float = Math.sin(-angle);
        preApply(1, 0, 0, 0,  0, c, -s, 0,  0, s, c, 0,  0, 0, 0, 1);
    }


    public function rotateY(angle:Float) {
        var c:Float = Math.cos(angle);
        var s:Float = Math.sin(angle);
        apply(c, 0, s, 0,  0, 1, 0, 0, -s, 0, c, 0,  0, 0, 0, 1);
    }


    public function invRotateY(angle:Float) {
        var c:Float = Math.cos(-angle);
        var s:Float = Math.sin(-angle);
        preApply(c, 0, s, 0,  0, 1, 0, 0, -s, 0, c, 0,  0, 0, 0, 1);
    }
  
    public function rotate(angle:Float) {
        rotateZ(angle);
    }


    public function invRotate(angle:Float) {
        invRotateZ(angle);
    }


    public function rotateZ(angle:Float) {
        var c:Float = Math.cos(angle);
        var s:Float = Math.sin(angle);
        apply(c, -s, 0, 0,  s, c, 0, 0,  0, 0, 1, 0,  0, 0, 0, 1);
    }


    public void invRotateZ(angle:Float) {
        var c:Float = Math.cos(-angle);
        var s:Float = Math.sin(-angle);
        preApply(c, -s, 0, 0,  s, c, 0, 0,  0, 0, 1, 0,  0, 0, 0, 1);
    }
    
    public function rotate(angle:Float, v:Vertex) {
        var c:Float = Math.cos(angle);
        var s:Float = Math.sin(angle);
        var t:Float = 1 - c;

        var v0:Float = v.x;
        var v1:Float = v.y;
        var v2:Float = v.z;

        apply((t*v0*v0) + c, (t*v0*v1) - (s*v2), (t*v0*v2) + (s*v1), 0,
          (t*v0*v1) + (s*v2), (t*v1*v1) + c, (t*v1*v2) - (s*v0), 0,
          (t*v0*v2) - (s*v1), (t*v1*v2) + (s*v0), (t*v2*v2) + c, 0,
          0, 0, 0, 1);
    }


    public function invRotate(angle:Float, v:Vertex) {
        var c:Float = Math.cos(-angle);
        var s:Float = Math.sin(-angle);
        var t:Float = 1 - c;

        var v0:Float = v.x;
        var v1:Float = v.y;
        var v2:Float = v.z;
        
        preApply((t*v0*v0) + c, (t*v0*v1) - (s*v2), (t*v0*v2) + (s*v1), 0,
             (t*v0*v1) + (s*v2), (t*v1*v1) + c, (t*v1*v2) - (s*v0), 0,
             (t*v0*v2) - (s*v1), (t*v1*v2) + (s*v0), (t*v2*v2) + c, 0,
             0, 0, 0, 1);
    }
    
    public function scale(s:Float) {
        apply(s, 0, 0, 0,  0, s, 0, 0,  0, 0, s, 0,  0, 0, 0, 1);
    }

    public function invScale(s:Float) {
        preApply(1/s, 0, 0, 0,  0, 1/s, 0, 0,  0, 0, 1/s, 0,  0, 0, 0, 1);
    }

    public function scale(sx:Float, sy:Float) {
        apply(sx, 0, 0, 0,  0, sy, 0, 0,  0, 0, 1, 0,  0, 0, 0, 1);
    }
    
    public function invScale(sx:Float, sy:Float) {
        preApply(1/sx, 0, 0, 0,  0, 1/sy, 0, 0,  0, 0, 1, 0,  0, 0, 0, 1);
    }

    public function scale(x:Float, y:Float, z:Float) {
        apply(x, 0, 0, 0,  0, y, 0, 0,  0, 0, z, 0,  0, 0, 0, 1);
    }

    public function invScale(x:Float, y:Float, z:Float) {
        preApply(1/x, 0, 0, 0,  0, 1/y, 0, 0,  0, 0, 1/z, 0,  0, 0, 0, 1);
    } 

    
    ////////////////////////////////////////////////////////////////////////////
    // Implementation Methods
    
    public function set(m00:Float, m01:Float, m02:Float, m03:Float,
                        m10:Float, m11:Float, m12:Float, m13:Float,
                        m20:Float, m21:Float, m22:Float, m23:Float,
                        m30:Float, m31:Float, m32:Float, m33:Float) {
        this.m00 = m00;
        this.m01 = m01;
        this.m02 = m02;
        this.m03 = m03;
        
        this.m10 = m10;
        this.m11 = m11;
        this.m12 = m12;
        this.m13 = m13;
        
        this.m20 = m20;
        this.m21 = m21;
        this.m22 = m22;
        this.m23 = m23;
        
        this.m30 = m30;
        this.m31 = m31;
        this.m32 = m32;
        this.m33 = m33;
    }
    
    public function reset() {
        set(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1);
    }
    
    /**
     * Used for inverse operations, like multiplying the matrix on the left
     */
    public function preApply(n00:Float, n01:Float, n02:Float, n03:Float,
                             n10:Float, n11:Float, n12:Float, n13:Float,
                             n20:Float, n21:Float, n22:Float, n23:Float,
                             n30:Float, n31:Float, n32:Float, n33:Float) {

        var r00:Float = n00*m00 + n01*m10 + n02*m20 + n03*m30;
        var r01:Float = n00*m01 + n01*m11 + n02*m21 + n03*m31;
        var r02:Float = n00*m02 + n01*m12 + n02*m22 + n03*m32;
        var r03:Float = n00*m03 + n01*m13 + n02*m23 + n03*m33;

        var r10:Float = n10*m00 + n11*m10 + n12*m20 + n13*m30;
        var r11:Float = n10*m01 + n11*m11 + n12*m21 + n13*m31;
        var r12:Float = n10*m02 + n11*m12 + n12*m22 + n13*m32;
        var r13:Float = n10*m03 + n11*m13 + n12*m23 + n13*m33;

        var r20:Float = n20*m00 + n21*m10 + n22*m20 + n23*m30;
        var r21:Float = n20*m01 + n21*m11 + n22*m21 + n23*m31;
        var r22:Float = n20*m02 + n21*m12 + n22*m22 + n23*m32;
        var r23:Float = n20*m03 + n21*m13 + n22*m23 + n23*m33;

        var r30:Float = n30*m00 + n31*m10 + n32*m20 + n33*m30;
        var r31:Float = n30*m01 + n31*m11 + n32*m21 + n33*m31;
        var r32:Float = n30*m02 + n31*m12 + n32*m22 + n33*m32;
        var r33:Float = n30*m03 + n31*m13 + n32*m23 + n33*m33;

        m00 = r00; m01 = r01; m02 = r02; m03 = r03;
        m10 = r10; m11 = r11; m12 = r12; m13 = r13;
        m20 = r20; m21 = r21; m22 = r22; m23 = r23;
        m30 = r30; m31 = r31; m32 = r32; m33 = r33;
  }
    

}