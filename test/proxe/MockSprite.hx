package proxe;

import proxe.Sprite;

class MockSprite extends Sprite {
    public var setupCount:Int;
    public var drawCount:Int;

    public function setup() {
        if(setupCount == null) {
            setupCount = 0;
        }

        setupCount++;
        drawCount = 0;
    }

    public function draw() {
        drawCount++;
    }

    ////////////////////////////////////////////////////////////////////////////
    // Scope Busters

    public function isLooping() {
        return looping;
    }
}
