import proxe.CanvasTest;
import haxe.unit.TestRunner;

class ProxeTests {
    static function main() {
        var runner = new TestRunner();

        runner.add(new CanvasTest());
        
        runner.run();
    }
}