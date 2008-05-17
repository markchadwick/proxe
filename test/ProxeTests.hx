import haxe.unit.TestRunner;

import proxe.SpriteTest;
import proxe.graphics.GraphicsTest;

class ProxeTests {
    static function main() {
        var runner = new TestRunner();

        runner.add(new GraphicsTest());
        runner.add(new SpriteTest());
                
        runner.run();
    }
}
