package proxe.graphics;

import proxe.Sprite;

class MockGraphics extends Graphics {

    public var sprite:Sprite;

    public function new(sprite:Sprite) {
        this.sprite = sprite;
    }
}
