package proxe.graphics;

import flash.Lib;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.events.Event;
import flash.display.MovieClip;

import proxe.Applet;
import proxe.Color;
import proxe.Vertex;
import proxe.graphics.Graphics;

class FlashGraphics extends Graphics {
    private var flash:MovieClip;
    private var graphics:flash.display.Graphics;
    
    public function new(width:Int, height:Int, applet:Applet, ?path:String) {
        this.width = width;
        this.height = height;
        
        this.parent = applet;
        
        createMovie(width, height);
        
        defaults();
        bindEvents();
    }

    ////////////////////////////////////////////////////////////////////////////
    // Control Methods

    public function clear() {
        graphics.clear();
    }
    
    public function redraw() {
        if(!looping) {
            clear();
            parent.draw();
        }
    }

    public function frameRate(frameRate:Float) {

    }
    
    public function loop() {
        looping = true;
        Lib.current.addEventListener(Event.ENTER_FRAME,loopEvent);
    }
    
    public function noLoop() {
        looping = false;
        Lib.current.removeEventListener(Event.ENTER_FRAME,loopEvent);
    }

	private function loopEvent(e:Event) {
		parent.draw();
	}

    ////////////////////////////////////////////////////////////////////////////
    // Drawing Methods

    public function drawVertices() {
        var me = this;
        fillAndStroke(function() {
        
            var vertsDrawn:Int = 0;
            for(vertex in me.vertices) {
                if(vertsDrawn == 0) {
                    me.graphics.moveTo(vertex.x, vertex.y);
                } else {
                    me.graphics.lineTo(vertex.x, vertex.y);
                }
                vertsDrawn++;
            }
        });
    }
    
    ////////////////////////////////////////////////////////////////////////////
    // Event Binding

    private function bindEvents() {
        Lib.current.stage.addEventListener(MouseEvent.MOUSE_MOVE,
            mouseMovedEvent);
            
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_DOWN,
            mousePressedEvent);
            
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_UP,
            mouseReleasedEvent);
            
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN,
            keyTypedEvent); 
            
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP,
            keyReleasedEvent); 
    }
    
    /**
     * TODO: localX is local to the sprite -- think about it?
     */
    private function mouseMovedEvent(e:MouseEvent) {
        parent.mouseX = e.stageX;
        parent.mouseY = e.stageY;
    }
    
    private function mousePressedEvent(e:Event) {
        parent.mousePressed();
    }
    
    private function mouseReleasedEvent(e:Event) {
//        trace("Released Mouse");
    }
    
    private function keyTypedEvent(e:Event) {
//        trace("Typed Key");
    }
    
    private function keyReleasedEvent(e:Event) {
//        trace("Released Key");
    }

    ////////////////////////////////////////////////////////////////////////////
    // Private Methods
    
    private function fillAndStroke(func:Void -> Void) {
        if(currentShapeClosingType == CLOSE && !fillColor.equals(Color.NONE)) {
            graphics.beginFill(rgb(fillColor), alpha(fillColor));
        }

        if(!strokeColor.equals(Color.NONE)) {
            graphics.lineStyle(strokeWidth, rgb(strokeColor), alpha(strokeColor));
        } else {
            graphics.lineStyle();
        }
        
        func();
        
        graphics.endFill();
    }
    
    private function createMovie(width:Int, height:Int, ?parent:MovieClip) {
        if(parent == null) {
            parent = Lib.current;
        }
        
        flash = new MovieClip();
        parent.addChild(flash);
        
        graphics = flash.graphics;
    }
    
    private inline function rgb(color:Color):Int {
        return (color.red << 16) | (color.green << 8) | color.blue;
    }
    
    private inline function alpha(color:Color) : Float {
        return cast(color.alpha, Float)/255.0;
    }
}