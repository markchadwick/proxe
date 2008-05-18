package proxe.Shape;

import proxe.graphics.Graphics;

public class PLine implements {
    private var m_pixels:Array<Int>;
    private var m_zbuffer:Array<Float>;

    private var m_index:Int;

    private static var R_COLOR:Int = 0x1;
    private static var R_ALPHA:Int = 0x2;
    private static var R_SPATIAL:Int = 0x8;
    private static var R_THICK:Int = 0x4;
    private static var R_SMOOTH:Int  = 0x10;

    private var SCREEN_WIDTH:Int;
    private var SCREEN_HEIGHT:Int;
    private var SCREEN_WIDTH1:Int;
    private var SCREEN_HEIGHT1:Int;
    

    public var INTERPOLATE_RGB:Bool;
    public var INTERPOLATE_ALPHA:Bool;
    public var INTERPOLATE_Z:Bool;
    public var INTERPOLATE_THICK:Bool;

    private var SMOOTH:Bool;


    private var m_stroke:Int;

    public var  m_drawFlags:Int;

    // vertex coordinates
    private var x_array:Array<Float>;
    private var y_array:Array<Float>;
    private var z_array:Array<Float>;

    // vertex intensity
    private var r_array:Array<Float>;
    private var g_array:Array<Float>;
    private var b_array:Array<Float>;
    private var a_array:Array<Float>;

    // vertex offsets
    private var o0:Int;
    private var o1:Int;

    // start values
    private var m_r0:Float;
    private var m_g0:Float;
    private var m_b0:Float;
    private var m_a0:Float;
    private var m_z0:Float;

    // deltas
    private var dz:Float;

    // rgba deltas
    private var dr:Float;
    private var dg:Float;
    private var db:Float;
    private var da:Float;

    private var parent:Graphics;

    public function new(g:Graphics) {
        INTERPOLATE_Z = false;

        // TODO: Resize these all to 2
        x_array = new Array<Float>();
        y_array = new Array<Float>();
        z_array = new Array<Float>();
        r_array = new Array<Float>();
        g_array = new Array<Float>();
        b_array = new Array<Float>();
        a_array = new Array<Float>();
        
        this.parent = g;
    }

    
    public function reset() {
        SCREEN_WIDTH = parent.width;
        SCREEN_HEIGHT = parent.height;
        SCREEN_WIDTH1 = SCREEN_WIDTH-1;
        SCREEN_HEIGHT1 = SCREEN_HEIGHT-1;

        m_pixels = parent.pixels;
        m_zbuffer = parent.zbuffer;
        
        INTERPOLATE_RGB = false;
        INTERPOLATE_ALPHA = false;
        m_drawFlags = 0;
        m_index = 0;
    }
    
    public function setVerticies(x0:Float, y0:Float, z0:Float,
                                 x1:Float, y1:Float, z1:Float) {

        if (z0 != z1 || z0!=0.0f || z1!=0.0f || INTERPOLATE_Z) {
            INTERPOLATE_Z = true;
            m_drawFlags |= R_SPATIAL;
        } else {
            INTERPOLATE_Z = false;
            m_drawFlags &= ~R_SPATIAL;
        }

        z_array[0] = z0;
        z_array[1] = z1;

        x_array[0] = x0;
        x_array[1] = x1;

        y_array[0] = y0;
        y_array[1] = y1;
    }

    
    public function setIntensities(r0:Float, g0:Float, b0:Float, a0:Float,
                                   r1:Float, g1:Float, b1:Float, a1:Float) {
    
        a_array[0] = (a0 * 253f + 1.0f) * 65536f;
        a_array[1] = (a1 * 253f + 1.0f) * 65536f;

        if ((a0 != 1.0f) || (a1 != 1.0f)) {
            INTERPOLATE_ALPHA = true;
            m_drawFlags |= R_ALPHA;
        } else {
            INTERPOLATE_ALPHA = false;
            m_drawFlags &= ~R_ALPHA;
        }

        /*
         * extra scaling added to prevent color "overflood" due to rounding
         * errors
         */
        r_array[0] = (r0 * 253f + 1.0f) * 65536f;
        r_array[1] = (r1 * 253f + 1.0f) * 65536f;

        g_array[0] = (g0 * 253f + 1.0f) * 65536f;
        g_array[1] = (g1 * 253f + 1.0f) * 65536f;

        b_array[0] = (b0 * 253f + 1.0f) * 65536f;
        b_array[1] = (b1 * 253f + 1.0f) * 65536f;

        /*
         * check if we need to interpolate the intensity values
         */
        if (r0 != r1) {
            INTERPOLATE_RGB = true;
            m_drawFlags |= R_COLOR;
        } else if (g0 != g1) {
            INTERPOLATE_RGB = true;
            m_drawFlags |= R_COLOR;
        } else if (b0 != b1) {
            INTERPOLATE_RGB = true;
            m_drawFlags |= R_COLOR;
        } else {
            m_stroke = 0xFF000000 |
                ((int)(255*r0) << 16) | ((int)(255*g0) << 8) | (int)(255*b0);
            INTERPOLATE_RGB = false;
            m_drawFlags &= ~R_COLOR;
        }
    }


  
    public function setIndex(index:Int) {
        m_index = index;
        
        if (m_index == -1) {
            m_index = 0;
        }
    }


  
  
    public function draw() {
        var xi:Int;
        var yi:Int;
        var length:Int;
        var visible:Bool = true;


        if (parent.smooth) {
            SMOOTH = true;
            m_drawFlags |= R_SMOOTH;
        } else {
            SMOOTH = false;
            m_drawFlags &= ~R_SMOOTH;
        }

        // line hack
        if (parent.hints[DISABLE_FLYING_POO]) {
            float nwidth2 = -SCREEN_WIDTH;
            float nheight2 = -SCREEN_HEIGHT;
            float width2 = SCREEN_WIDTH * 2;
            float height2 = SCREEN_HEIGHT * 2;
            
            if ((x_array[1] < nwidth2) ||
                (x_array[1] > width2) ||
                (x_array[0] < nwidth2) ||
                (x_array[0] > width2) ||
                (y_array[1] < nheight2) ||
                (y_array[1] > height2) ||
                (y_array[0] < nheight2) ||
                (y_array[0] > height2)) {
                return;  // this is a bad line
            }
        }

    ///////////////////////////////////////
    // line clipping
    visible = lineClipping();
    if (!visible) {
      return;
    }

    ///////////////////////////////////////
    // calculate line values
    int shortLen;
    int longLen;
    boolean yLonger;
    int dt;

    yLonger = false;

    // HACK for drawing lines left-to-right for rev 0069
    // some kind of bug exists with the line-stepping algorithm
    // that causes strange patterns in the anti-aliasing.
    // [040228 fry]
    //
    // swap rgba as well as the coords.. oops
    // [040712 fry]
    //
    if (x_array[1] < x_array[0]) {
      float t;

      t = x_array[1]; x_array[1] = x_array[0]; x_array[0] = t;
      t = y_array[1]; y_array[1] = y_array[0]; y_array[0] = t;
      t = z_array[1]; z_array[1] = z_array[0]; z_array[0] = t;

      t = r_array[1]; r_array[1] = r_array[0]; r_array[0] = t;
      t = g_array[1]; g_array[1] = g_array[0]; g_array[0] = t;
      t = b_array[1]; b_array[1] = b_array[0]; b_array[0] = t;
      t = a_array[1]; a_array[1] = a_array[0]; a_array[0] = t;
    }

    // important - don't change the casts
    // is needed this way for line drawing algorithm
    longLen  = (int)x_array[1] - (int)x_array[0];
    shortLen = (int)y_array[1] - (int)y_array[0];

    if (Math.abs(shortLen) > Math.abs(longLen)) {
      int swap = shortLen;
      shortLen = longLen;
      longLen = swap;
      yLonger = true;
    }

    // now we sort points so longLen is always positive
    // and we always start drawing from x[0], y[0]
    if (longLen < 0) {
      // swap order
      o0 = 1;
      o1 = 0;

      xi = (int) x_array[1];
      yi = (int) y_array[1];

      length = -longLen;

    } else {
      o0 = 0;
      o1 = 1;

      xi = (int) x_array[0];
      yi = (int) y_array[0];

      length = longLen;
    }

    // calculate dt
    if (length == 0) {
      dt = 0;
    } else {
      dt = (shortLen << 16) / longLen;
    }

    m_r0 = r_array[o0];
    m_g0 = g_array[o0];
    m_b0 = b_array[o0];

    if (INTERPOLATE_RGB) {
      dr = (r_array[o1] - r_array[o0]) / length;
      dg = (g_array[o1] - g_array[o0]) / length;
      db = (b_array[o1] - b_array[o0]) / length;
    } else {
      dr = 0;
      dg = 0;
      db = 0;
    }

    m_a0 = a_array[o0];

    if (INTERPOLATE_ALPHA) {
      da = (a_array[o1] - a_array[o0]) / length;
    } else {
      da = 0;
    }

    m_z0 = z_array[o0];
    //z0 += -0.001f; // [rocha] ugly fix for z buffer precision

    if (INTERPOLATE_Z) {
      dz = (z_array[o1] - z_array[o0]) / length;
    } else {
      dz = 0;
    }

    // draw thin points
    if (length == 0) {
      if (INTERPOLATE_ALPHA) {
        drawPoint_alpha(xi, yi);
      } else {
        drawPoint(xi, yi);
      }
      return;
    }

    // draw normal strokes
    if (SMOOTH) {
      drawLine_smooth(xi, yi, dt, length, yLonger);

    } else {
      if (m_drawFlags == 0) {
        drawLine_plain(xi, yi, dt, length, yLonger);

      } else if (m_drawFlags == R_ALPHA) {
        drawLine_plain_alpha(xi, yi, dt, length, yLonger);

      } else if (m_drawFlags == R_COLOR) {
        drawLine_color(xi, yi, dt, length, yLonger);

      } else if (m_drawFlags == (R_COLOR + R_ALPHA)) {
        drawLine_color_alpha(xi, yi, dt, length, yLonger);

      } else if (m_drawFlags == R_SPATIAL) {
        drawLine_plain_spatial(xi, yi, dt, length, yLonger);

      } else if (m_drawFlags == (R_SPATIAL + R_ALPHA)) {
        drawLine_plain_alpha_spatial(xi, yi, dt, length, yLonger);

      } else if (m_drawFlags == (R_SPATIAL + R_COLOR)) {
        drawLine_color_spatial(xi, yi, dt, length, yLonger);

      } else if (m_drawFlags == (R_SPATIAL + R_COLOR + R_ALPHA)) {
        drawLine_color_alpha_spatial(xi, yi, dt, length, yLonger);
      }
    }
  }


  public boolean lineClipping() {
    // new cohen-sutherland clipping code, as old one was buggy [toxi]
    // get the "dips" for the points to clip
    int code1 = lineClipCode(x_array[0], y_array[0]);
    int code2 = lineClipCode(x_array[1], y_array[1]);
    int dip = code1 | code2;

    if ((code1 & code2)!=0) {

      return false;

    } else if (dip != 0) {

      // now calculate the clipped points
      float a0 = 0, a1 = 1, a = 0;

      for (int i = 0; i < 4; i++) {
        if (((dip>>i)%2)==1){
          a = lineSlope(x_array[0], y_array[0], x_array[1], y_array[1], i+1);
          if (((code1 >> i) % 2) == 1) {
            a0 = (a>a0)?a:a0; // max(a,a0)
          } else {
            a1 = (a<a1)?a:a1; // min(a,a1)
          }
        }
      }

      if (a0 > a1) {
        return false;
      } else {
        float xt =  x_array[0];
        float yt =  y_array[0];

        x_array[0] = xt + a0 * (x_array[1] - xt);
        y_array[0] = yt + a0 * (y_array[1] - yt);
        x_array[1] = xt + a1 * (x_array[1] - xt);
        y_array[1] = yt + a1 * (y_array[1] - yt);

        // interpolate remaining parameters
        if (INTERPOLATE_RGB) {
          float t = r_array[0];
          r_array[0] = t + a0 * (r_array[1] - t);
          r_array[1] = t + a1 * (r_array[1] - t);
          t = g_array[0];
          g_array[0] = t + a0 * (g_array[1] - t);
          g_array[1] = t + a1 * (g_array[1] - t);
          t = b_array[0];
          b_array[0] = t + a0 * (b_array[1] - t);
          b_array[1] = t + a1 * (b_array[1] - t);
        }

        if (INTERPOLATE_ALPHA) {
          float t = a_array[0];
          a_array[0] = t + a0 * (a_array[1] - t);
          a_array[1] = t + a1 * (a_array[1] - t);
        }
      }
    }
    return true;
  }


  private int lineClipCode(float xi, float yi) {
    int xmin = 0;
    int ymin = 0;
    int xmax = SCREEN_WIDTH1;
    int ymax = SCREEN_HEIGHT1;

    //return ((yi < ymin ? 8 : 0) | (yi > ymax ? 4 : 0) |
    //        (xi < xmin ? 2 : 0) | (xi > xmax ? 1 : 0));
    //(int) added by ewjordan 6/13/07 because otherwise we sometimes clip last pixel when it should actually be displayed.
        //Currently the min values are okay because values less than 0 should not be rendered; however, bear in mind that
        //(int) casts towards zero, so without this clipping, values between -1+eps and +1-eps would all be rendered as 0.
    return ((yi < ymin ? 8 : 0) | ((int)yi > ymax ? 4 : 0) |
            (xi < xmin ? 2 : 0) | ((int)xi > xmax ? 1 : 0));
  }


  private float lineSlope(float x1, float y1, float x2, float y2, int border) {
    int xmin = 0;
    int ymin = 0;
    int xmax = SCREEN_WIDTH1;
    int ymax = SCREEN_HEIGHT1;

    switch (border) {
    case 4: return (ymin-y1)/(y2-y1);
    case 3: return (ymax-y1)/(y2-y1);
    case 2: return (xmin-x1)/(x2-x1);
    case 1: return (xmax-x1)/(x2-x1);
    }
    return -1f;
  }


  private void drawPoint(int x0, int y0) {
    float iz = m_z0;
    int offset = y0 * SCREEN_WIDTH + x0;

    if (iz <= m_zbuffer[offset]) {
      m_pixels[offset] = m_stroke;
      m_zbuffer[offset] = iz;
    }
  }


  private void drawPoint_alpha(int x0, int y0) {
    int ia = (int) a_array[0];
    int pr = m_stroke & 0xFF0000;
    int pg = m_stroke & 0xFF00;
    int pb = m_stroke & 0xFF;
    float iz = m_z0;
    int offset = y0 * SCREEN_WIDTH + x0;

    if (iz <= m_zbuffer[offset]) {
      int alpha = ia >> 16;
      int r0 = m_pixels[offset];
      int g0 = r0 & 0xFF00;
      int b0 = r0 & 0xFF;
      r0 &= 0xFF0000;

      r0 = r0 + (((pr - r0) * alpha) >> 8);
      g0 = g0 + (((pg - g0) * alpha) >> 8);
      b0 = b0 + (((pb - b0) * alpha) >> 8);

      m_pixels[offset] = 0xFF000000 |
        (r0 & 0xFF0000) | (g0 & 0xFF00) | (b0 & 0xFF);
      //m_zbuffer[offset] = iz;
    }
  }


  private void drawLine_plain(int x0, int y0, int dt,
                              int length, boolean vertical) {
    // new "extremely fast" line code
    // adapted from http://www.edepot.com/linee.html
    // first version modified by [toxi]
    // simplified by [rocha]
    // length must be >= 0

    //assert length>=0:length;

    int offset = 0;

    if (vertical) {
      // vertical
      length += y0;
      for (int j = 0x8000 + (x0<<16); y0 <= length; ++y0) {
        offset = y0 * SCREEN_WIDTH + (j>>16);
        m_pixels[offset] = m_stroke;
        m_zbuffer[offset] = m_z0;
        j+=dt;
      }

    } else {
      // horizontal
      length += x0;
      for (int j = 0x8000 + (y0<<16); x0 <= length; ++x0) {
        offset = (j>>16) * SCREEN_WIDTH + x0;
        m_pixels[offset] = m_stroke;
        //m_zbuffer[offset] = m_z0;
        j+=dt;
      }
    }
  }


  private void drawLine_plain_alpha(int x0, int y0, int dt,
                                    int length, boolean vertical)  {
    int offset = 0;

    int pr = m_stroke & 0xFF0000;
    int pg = m_stroke & 0xFF00;
    int pb = m_stroke & 0xFF;

    int ia = (int) (m_a0);

    if (vertical) {
      length += y0;
      for (int j = 0x8000 + (x0<<16); y0 <= length; ++y0) {
        offset = y0 * SCREEN_WIDTH + (j>>16);

        int alpha = ia >> 16;
        int r0 = m_pixels[offset];
        int g0 = r0 & 0xFF00;
        int b0 = r0 & 0xFF;
        r0 &= 0xFF0000;
        r0 = r0 + (((pr - r0) * alpha) >> 8);
        g0 = g0 + (((pg - g0) * alpha) >> 8);
        b0 = b0 + (((pb - b0) * alpha) >> 8);

        m_pixels[offset] = 0xFF000000 |
          (r0 & 0xFF0000) | (g0 & 0xFF00) | (b0 & 0xFF);
        m_zbuffer[offset] = m_z0;

        ia += da;
        j += dt;
      }

    } else {  // horizontal
      length += x0;
      for (int j = 0x8000 + (y0<<16); x0 <= length; ++x0) {
        offset = (j>>16) * SCREEN_WIDTH + x0;

        int alpha = ia >> 16;
        int r0 = m_pixels[offset];
        int g0 = r0 & 0xFF00;
        int b0 = r0 & 0xFF;
        r0&=0xFF0000;
        r0 = r0 + (((pr - r0) * alpha) >> 8);
        g0 = g0 + (((pg - g0) * alpha) >> 8);
        b0 = b0 + (((pb - b0) * alpha) >> 8);

        m_pixels[offset] = 0xFF000000 |
          (r0 & 0xFF0000) | (g0 & 0xFF00) | (b0 & 0xFF);
        m_zbuffer[offset] = m_z0;

        ia += da;
        j += dt;
      }
    }
  }


  private void drawLine_color(int x0, int y0, int dt,
                              int length, boolean vertical)  {
    int offset = 0;

    int ir = (int) m_r0;
    int ig = (int) m_g0;
    int ib = (int) m_b0;

    if (vertical) {
      length += y0;
      for (int j = 0x8000 + (x0<<16); y0 <= length; ++y0) {
        offset = y0 * SCREEN_WIDTH + (j>>16);
        m_pixels[offset] = 0xFF000000 |
          ((ir & 0xFF0000) | ((ig >> 8) & 0xFF00) | (ib >> 16));
        m_zbuffer[offset] = m_z0;
        ir += dr;
        ig += dg;
        ib += db;
        j +=dt;
      }

    } else {  // horizontal
      length += x0;
      for (int j = 0x8000 + (y0<<16); x0 <= length; ++x0) {
        offset = (j>>16) * SCREEN_WIDTH + x0;
        m_pixels[offset] = 0xFF000000 |
          ((ir & 0xFF0000) | ((ig >> 8) & 0xFF00) | (ib >> 16));
        m_zbuffer[offset] = m_z0;
        ir += dr;
        ig += dg;
        ib += db;
        j += dt;
      }
    }
  }


  private void drawLine_color_alpha(int x0, int y0, int dt,
                                    int length, boolean vertical)  {
    int offset = 0;

    int ir = (int) m_r0;
    int ig = (int) m_g0;
    int ib = (int) m_b0;
    int ia = (int) m_a0;

    if (vertical) {
      length += y0;
      for (int j = 0x8000 + (x0<<16); y0 <= length; ++y0) {
        offset = y0 * SCREEN_WIDTH + (j>>16);

        int pr = ir & 0xFF0000;
        int pg = (ig >> 8) & 0xFF00;
        int pb = (ib >> 16);

        int r0 = m_pixels[offset];
        int g0 = r0 & 0xFF00;
        int b0 = r0 & 0xFF;
        r0&=0xFF0000;

        int alpha = ia >> 16;

        r0 = r0 + (((pr - r0) * alpha) >> 8);
        g0 = g0 + (((pg - g0) * alpha) >> 8);
        b0 = b0 + (((pb - b0) * alpha) >> 8);

        m_pixels[offset] = 0xFF000000 |
          (r0 & 0xFF0000) | (g0 & 0xFF00) | (b0 & 0xFF);
        m_zbuffer[offset] = m_z0;

        ir+= dr;
        ig+= dg;
        ib+= db;
        ia+= da;
        j+=dt;
      }

    } else {  // horizontal
      length += x0;
      for (int j = 0x8000 + (y0<<16); x0 <= length; ++x0) {
        offset = (j>>16) * SCREEN_WIDTH + x0;

        int pr = ir & 0xFF0000;
        int pg = (ig >> 8) & 0xFF00;
        int pb = (ib >> 16);

        int r0 = m_pixels[offset];
        int g0 = r0 & 0xFF00;
        int b0 = r0 & 0xFF;
        r0&=0xFF0000;

        int alpha = ia >> 16;

        r0 = r0 + (((pr - r0) * alpha) >> 8);
        g0 = g0 + (((pg - g0) * alpha) >> 8);
        b0 = b0 + (((pb - b0) * alpha) >> 8);

        m_pixels[offset] = 0xFF000000 |
          (r0 & 0xFF0000) | (g0 & 0xFF00) | (b0 & 0xFF);
        m_zbuffer[offset] = m_z0;

        ir+= dr;
        ig+= dg;
        ib+= db;
        ia+= da;
        j+=dt;
      }
    }
  }


  private void drawLine_plain_spatial(int x0, int y0, int dt,
                                      int length, boolean vertical)  {
    int offset = 0;
    float iz = m_z0;

    if (vertical) {
      length += y0;
      for (int j = 0x8000 + (x0<<16); y0 <= length; ++y0) {
        offset = y0 * SCREEN_WIDTH + (j>>16);
        if (iz <= m_zbuffer[offset]) {
          m_pixels[offset] = m_stroke;
          m_zbuffer[offset] = iz;
        }
        iz+=dz;
        j+=dt;
      }

    } else {  // horizontal
      length += x0;
      for (int j = 0x8000 + (y0<<16); x0 <= length; ++x0) {
        offset = (j>>16) * SCREEN_WIDTH + x0;
        if (iz <= m_zbuffer[offset]) {
          m_pixels[offset] = m_stroke;
          m_zbuffer[offset] = iz;
        }
        iz+=dz;
        j+=dt;
      }
    }
  }


  private void drawLine_plain_alpha_spatial(int x0, int y0, int dt,
                                            int length, boolean vertical) {
    int offset = 0;
    float iz = m_z0;

    int pr = m_stroke & 0xFF0000;
    int pg = m_stroke & 0xFF00;
    int pb = m_stroke & 0xFF;

    int ia = (int) m_a0;

    if (vertical) {
      length += y0;
      for (int j = 0x8000 + (x0<<16); y0 <= length; ++y0) {
        offset = y0 * SCREEN_WIDTH + (j>>16);

        if (iz <= m_zbuffer[offset]) {
          int alpha = ia >> 16;
          int r0 = m_pixels[offset];
          int g0 = r0 & 0xFF00;
          int b0 = r0 & 0xFF;
          r0 &= 0xFF0000;
          r0 = r0 + (((pr - r0) * alpha) >> 8);
          g0 = g0 + (((pg - g0) * alpha) >> 8);
          b0 = b0 + (((pb - b0) * alpha) >> 8);

          m_pixels[offset] = 0xFF000000 |
            (r0 & 0xFF0000) | (g0 & 0xFF00) | (b0 & 0xFF);
          //m_zbuffer[offset] = iz;
        }
        iz +=dz;
        ia += da;
        j += dt;
      }

    } else {  // horizontal
      length += x0;
      for (int j = 0x8000 + (y0<<16); x0 <= length; ++x0) {
        offset = (j>>16) * SCREEN_WIDTH + x0;

        if (iz <= m_zbuffer[offset]) {
          int alpha = ia >> 16;
          int r0 = m_pixels[offset];
          int g0 = r0 & 0xFF00;
          int b0 = r0 & 0xFF;
          r0&=0xFF0000;
          r0 = r0 + (((pr - r0) * alpha) >> 8);
          g0 = g0 + (((pg - g0) * alpha) >> 8);
          b0 = b0 + (((pb - b0) * alpha) >> 8);

          m_pixels[offset] = 0xFF000000 |
            (r0 & 0xFF0000) | (g0 & 0xFF00) | (b0 & 0xFF);
          //m_zbuffer[offset] = iz;
        }
        iz += dz;
        ia += da;
        j += dt;
      }
    }
  }


  private void drawLine_color_spatial(int x0, int y0, int dt,
                                      int length, boolean vertical)  {
    int offset = 0;
    float iz = m_z0;

    int ir = (int) m_r0;
    int ig = (int) m_g0;
    int ib = (int) m_b0;

    if (vertical) {
      length += y0;
      for (int j = 0x8000 + (x0<<16); y0 <= length; ++y0) {
        offset = y0 * SCREEN_WIDTH + (j>>16);

        if (iz <= m_zbuffer[offset]) {
          m_pixels[offset] = 0xFF000000 |
            ((ir & 0xFF0000) | ((ig >> 8) & 0xFF00) | (ib >> 16));
          m_zbuffer[offset] = iz;
        }
        iz +=dz;
        ir += dr;
        ig += dg;
        ib += db;
        j += dt;
      }
    } else {  // horizontal
      length += x0;
      for (int j = 0x8000 + (y0<<16); x0 <= length; ++x0) {
        offset = (j>>16) * SCREEN_WIDTH + x0;
        if (iz <= m_zbuffer[offset]) {
          m_pixels[offset] = 0xFF000000 |
            ((ir & 0xFF0000) | ((ig >> 8) & 0xFF00) | (ib >> 16));
          m_zbuffer[offset] = iz;
        }
        iz += dz;
        ir += dr;
        ig += dg;
        ib += db;
        j += dt;
      }
      return;
    }
  }


  private void drawLine_color_alpha_spatial(int x0, int y0, int dt,
                                            int length, boolean vertical)  {
    int offset = 0;
    float iz = m_z0;

    int ir = (int) m_r0;
    int ig = (int) m_g0;
    int ib = (int) m_b0;
    int ia = (int) m_a0;

    if (vertical) {
      length += y0;
      for (int j = 0x8000 + (x0<<16); y0 <= length; ++y0) {
        offset = y0 * SCREEN_WIDTH + (j>>16);

        if (iz <= m_zbuffer[offset]) {
          int pr = ir & 0xFF0000;
          int pg = (ig >> 8) & 0xFF00;
          int pb = (ib >> 16);

          int r0 = m_pixels[offset];
          int g0 = r0 & 0xFF00;
          int b0 = r0 & 0xFF;
          r0&=0xFF0000;

          int alpha = ia >> 16;

          r0 = r0 + (((pr - r0) * alpha) >> 8);
          g0 = g0 + (((pg - g0) * alpha) >> 8);
          b0 = b0 + (((pb - b0) * alpha) >> 8);

          m_pixels[offset] = 0xFF000000 |
            (r0 & 0xFF0000) | (g0 & 0xFF00) | (b0 & 0xFF);
          m_zbuffer[offset] = iz;
        }
        iz+=dz;
        ir+= dr;
        ig+= dg;
        ib+= db;
        ia+= da;
        j+=dt;
      }

    } else {  // horizontal
      length += x0;
      for (int j = 0x8000 + (y0<<16); x0 <= length; ++x0) {
        offset = (j>>16) * SCREEN_WIDTH + x0;

        if (iz <= m_zbuffer[offset]) {
          int pr = ir & 0xFF0000;
          int pg = (ig >> 8) & 0xFF00;
          int pb = (ib >> 16);

          int r0 = m_pixels[offset];
          int g0 = r0 & 0xFF00;
          int b0 = r0 & 0xFF;
          r0 &= 0xFF0000;

          int alpha = ia >> 16;

          r0 = r0 + (((pr - r0) * alpha) >> 8);
          g0 = g0 + (((pg - g0) * alpha) >> 8);
          b0 = b0 + (((pb - b0) * alpha) >> 8);

          m_pixels[offset] = 0xFF000000 |
            (r0 & 0xFF0000) | (g0 & 0xFF00) | (b0 & 0xFF);
          m_zbuffer[offset] = iz;
        }
        iz += dz;
        ir += dr;
        ig += dg;
        ib += db;
        ia += da;
        j += dt;
      }
    }
  }


  void drawLine_smooth(int x0, int y0, int dt,
                       int length, boolean vertical) {
    int xi, yi; // these must be >=32 bits
    int offset = 0;
    int temp;
    int end;

    float iz = m_z0;

    int ir = (int) m_r0;
    int ig = (int) m_g0;
    int ib = (int) m_b0;
    int ia = (int) m_a0;

    if (vertical) {
      xi = x0 << 16;
      yi = y0 << 16;

      end = length + y0;

      while ((yi >> 16) < end) {

        offset = (yi>>16) * SCREEN_WIDTH + (xi>>16);

        int pr = ir & 0xFF0000;
        int pg = (ig >> 8) & 0xFF00;
        int pb = (ib >> 16);

        if (iz <= m_zbuffer[offset]) {
          int alpha = (((~xi >> 8) & 0xFF) * (ia >> 16)) >> 8;

          int r0 = m_pixels[offset];
          int g0 = r0 & 0xFF00;
          int b0 = r0 & 0xFF;
          r0&=0xFF0000;

          r0 = r0 + (((pr - r0) * alpha) >> 8);
          g0 = g0 + (((pg - g0) * alpha) >> 8);
          b0 = b0 + (((pb - b0) * alpha) >> 8);

          m_pixels[offset] = 0xFF000000 |
            (r0 & 0xFF0000) | (g0 & 0xFF00) | (b0 & 0xFF);
          m_zbuffer[offset] = iz;
        }

        // this if() makes things slow. there shoudl be
        // a better way to check if the second pixel is
        // withing the image array [rocha]
        temp = ((xi>>16)+1);
        if (temp >= SCREEN_WIDTH) {
          xi += dt;
          yi += (1 << 16);
          continue;
        }

        offset = (yi>>16) * SCREEN_WIDTH + temp;

        if (iz <= m_zbuffer[offset]) {
          int alpha = (((xi >> 8) & 0xFF) * (ia >> 16)) >> 8;

          int r0 = m_pixels[offset];
          int g0 = r0 & 0xFF00;
          int b0 = r0 & 0xFF;
          r0 &= 0xFF0000;

          r0 = r0 + (((pr - r0) * alpha) >> 8);
          g0 = g0 + (((pg - g0) * alpha) >> 8);
          b0 = b0 + (((pb - b0) * alpha) >> 8);

          m_pixels[offset] = 0xFF000000 |
            (r0 & 0xFF0000) | (g0 & 0xFF00) | (b0 & 0xFF);
          m_zbuffer[offset] = iz;
        }

        xi += dt;
        yi += (1 << 16);

        iz+=dz;
        ir+= dr;
        ig+= dg;
        ib+= db;
        ia+= da;
      }

    } else {  // horizontal
      xi = x0 << 16;
      yi = y0 << 16;
      end = length + x0;

      while ((xi >> 16) < end) {
        offset = (yi>>16) * SCREEN_WIDTH + (xi>>16);

        int pr = ir & 0xFF0000;
        int pg = (ig >> 8) & 0xFF00;
        int pb = (ib >> 16);

        if (iz <= m_zbuffer[offset]) {
          int alpha = (((~yi >> 8) & 0xFF) * (ia >> 16)) >> 8;

          int r0 = m_pixels[offset];
          int g0 = r0 & 0xFF00;
          int b0 = r0 & 0xFF;
          r0 &= 0xFF0000;

          r0 = r0 + (((pr - r0) * alpha) >> 8);
          g0 = g0 + (((pg - g0) * alpha) >> 8);
          b0 = b0 + (((pb - b0) * alpha) >> 8);

          m_pixels[offset] = 0xFF000000 |
            (r0 & 0xFF0000) | (g0 & 0xFF00) | (b0 & 0xFF);
          m_zbuffer[offset] = iz;
        }

        // see above [rocha]
        temp = ((yi>>16)+1);
        if (temp >= SCREEN_HEIGHT) {
          xi += (1 << 16);
          yi += dt;
          continue;
        }

        offset = temp * SCREEN_WIDTH + (xi>>16);

        if (iz <= m_zbuffer[offset]) {
          int alpha = (((yi >> 8) & 0xFF) * (ia >> 16)) >> 8;

          int r0 = m_pixels[offset];
          int g0 = r0 & 0xFF00;
          int b0 = r0 & 0xFF;
          r0&=0xFF0000;

          r0 = r0 + (((pr - r0) * alpha) >> 8);
          g0 = g0 + (((pg - g0) * alpha) >> 8);
          b0 = b0 + (((pb - b0) * alpha) >> 8);

          m_pixels[offset] = 0xFF000000 |
            (r0 & 0xFF0000) | (g0 & 0xFF00) | (b0 & 0xFF);
          m_zbuffer[offset] = iz;
        }

        xi += (1 << 16);
        yi += dt;

        iz+=dz;
        ir+= dr;
        ig+= dg;
        ib+= db;
        ia+= da;
      }
    }
  }

}
