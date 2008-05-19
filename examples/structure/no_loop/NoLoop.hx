/*
 * @Processing: http://processing.org/learning/examples/setupdraw.html
 * 
 * Setup and Draw.
 *
 * The draw() function creates a structure in which to write programs that
 * change with time.
 */

import proxe.Applet;

class NoLoop extends Applet {

    var y:Float;

    /**
    * The statements in the setup() function execute once when the program begins
    */
    public function setup() {
        size(200, 200);  // Size should be the first statement
        stroke(255);     // Set line drawing color to white
        frameRate(30);
        y = 100;
        
        noLoop();
    }

  /**
   * The statements in draw() are executed until the program is stopped. Each
   * statement is executed in sequence and after the last line is read, the
   * first line is executed again.
   */
  public function draw() {
        background(0);   // Set the background to black
        y = y - 1;
        if (y < 0) {
            y = height;
        }
        line(0, y, width, y);  
    }

    public static function main() {
        new NoLoop().init();
    }
}
