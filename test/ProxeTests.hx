import haxe.unit.TestRunner;

import proxe.ColorTest;

class ProxeTests {
    static function main() {
        var runner = new TestRunner();

        runner.add(new ColorTest());
        
        runner.run();
    }
}
