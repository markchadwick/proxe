import haxe.unit.TestRunner;

//import proxe.ColorTest;
import proxe.SpriteTest;

class ProxeTests {
    static function main() {
        var runner = new TestRunner();

//        runner.add(new ColorTest());
        runner.add(new SpriteTest());
                
        runner.run();
    }
}
