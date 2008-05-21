import haxe.unit.TestRunner;

import proxe.AppletTest;
import proxe.ColorTest;

class ProxeTests {
    public static function main() {
        var runner = new TestRunner();
        
        runner.add(new AppletTest());
        runner.add(new ColorTest());
        
        runner.run();
    }
}