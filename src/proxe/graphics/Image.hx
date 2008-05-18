package proxe.graphics;

class Image {
    ////////////////////////////////////////////////////////////////////////////
    // Public fields

    /**
     * Format for this image, one of RGB, ARGB or ALPHA. Note that RGB images
     * still require 0xff in the high byte because of how they'll be manipulated
     * by other functions
     */
    public var format:Int;

    public var pixels:Array<Int>;

    public var width:Int;
    public var height:Int;
}
