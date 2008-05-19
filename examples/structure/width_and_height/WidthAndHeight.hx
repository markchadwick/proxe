/*
 * @Processing: http://processing.org/learning/examples/widthheight.html
 * 
 *  Width and Height.
 *
 * The 'width' and 'height' variables contain the width and height
 * of the display window as defined in the size() function. 
 */

import proxe.Applet;

class WidthAndHeight extends Applet {
  
  public function setup() {
    size(200, 200);
    background(127);
    noStroke();

    var i = 0;
    while(i < height) {
      fill(0);
      rect(0, i, width, 10);
      fill(255);
      rect(i, 0, 10, height);

      i += 20;
    }
  }

  public static function main() {
    new WidthAndHeight().setup();
  }
}
