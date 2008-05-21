package proxe;

import haxe.unit.TestCase;

import proxe.Applet;

class AppletTest extends TestCase {
    
    private var applet:Applet;

    public function setup() {
        applet = new Applet();
    }

    ////////////////////////////////////////////////////////////////////////////
    // Defaults
    
    public function testDefaultMouseX() {   
        assertEquals(0.0, applet.mouseX);
    }
    
    public function testDefaultMouseY() {
        assertEquals(0.0, applet.mouseY);
    }
    
    ////////////////////////////////////////////////////////////////////////////
    // Methods
    
//    public function testFill() {
//        applet.fill(100);
//        assertEquals(new Color(100, 100, 100, 255), applet.graphics.fillColor);
//    }
    
//    public function testNoFill() {
//        applet.noFill();
//        assertEquals(Color.NONE, applet.graphics.fillColor);
//    }
}