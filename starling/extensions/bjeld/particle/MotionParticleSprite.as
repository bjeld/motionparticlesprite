/**
 * Created by martinbjeld on 9/4/14.
 */
package starling.extensions.bjeld.particle {
import flash.events.TimerEvent;
import flash.geom.Point;
import flash.utils.Timer;

import starling.core.Starling;

import starling.display.Sprite;
import starling.extensions.PDParticleSystem;

public class MotionParticleSprite extends Sprite {
    //-----------------------------------------------------------------------------------------
    //
    // NUMERICS
    //
    //
    private var _coords:Vector.<Point>;	// Stores all keyframes x and y coordinates.
    private var _currentFrame:int = 0;	// Keeps track of the current frame.
    private var _totalFrames:int;		// Stores the total amout of frames.
    private var _particle:PDParticleSystem
    private var _initObj:MotionParticleSpriteInitObject;
    private var _animationTimer:Timer;	// Main timer for the render loop (onTimerTick).
    public static const NOTIFY_FRAME:String = "notifyFrame";
    public static const PARTICLE_COMPLETE:String = "particleComplete";
    //-----------------------------------------------------------------------------------------
    //
    // DATA
    //
    //


    public function MotionParticleSprite(motionXML:XML, initObj:MotionParticleSpriteInitObject)
    {
        super();
        _initObj= initObj;
        prepare(motionXML);
    }

    //-----------------------------------------------------------------------------------------
    //
    // This function takes care of cleaning everything up.
    //
    public function kill():void
    {
        removeChildren(0,-1, true);
        _particle.stop();
        _particle.dispose();
        _particle = null;
        _animationTimer.stop();
        _animationTimer.removeEventListener(TimerEvent.TIMER, update);
        _animationTimer = null;
        Starling.juggler.remove(_particle);
        //trace("KILL " + this);
    }

    // ========================================================================================
    //
    //  PUBLIC FUNCTIONS
    //
    //
    public function initialize():void
    {
        if(_particle)
        {
            addChild(_particle);
            _particle.emitterX = _coords[0].x;
            _particle.emitterY = _coords[0].y;
            _particle.start();
        }

        if(_initObj.extraGraphic)
        {

            if(_initObj.extraGraphicOnTop){
                addChild(_initObj.extraGraphic);
            }
            else{
                addChildAt(_initObj.extraGraphic, 0);
            }

            _initObj.extraGraphic.pivotX = _initObj.extraGraphic.width/2;
            _initObj.extraGraphic.pivotY = _initObj.extraGraphic.height/2;
            _initObj.extraGraphic.x = _coords[0].x;
            _initObj.extraGraphic.y = _coords[0].y;
        }

        if(_initObj.extraGraphic && _initObj.fadeInAt != -1)
        {
            _initObj.extraGraphic.alpha = 0;
            _initObj.extraGraphic.alpha = 0;
        }
    }

    public function play():void
    {
        if(_initObj.delay)
            addStartDelay(_initObj.delay);
        else
            startAnimation();
    }

    private function prepare(motionXML:XML):void {

        var frames:XMLList = motionXML..element;
        _totalFrames = frames.length();
        _currentFrame = 0;
        _coords = new Vector.<Point>(_totalFrames);
        var i:int = 0;
        for each( var frame:XML in frames){
            var p:Point = new Point(frame.@x,frame.@y);
            _coords[i] = p;
            i++;
        }

        _animationTimer = new Timer(1000/_initObj.frameRate);
        _animationTimer.addEventListener(TimerEvent.TIMER, update);
        _particle = new PDParticleSystem( _initObj.configXML, _initObj.particleTexture );

    }

    //-----------------------------------------------------------------------------------------
    //
    // This function add a start delay to our animation by making a Timer responsible for
    // calling -> onStartDelay -> startAnimation() after a certain amount of time specified
    // by the _initObj.delay param. This function will only be called if that param exists.
    //
    private function addStartDelay(delay:Number):void
    {
        Starling.juggler.delayCall(startAnimation, _initObj.delay);
    }

    //-----------------------------------------------------------------------------------------
    //
    // This function starts the Timer that will call the onTimerTick (render loop) based on
    // the framerate parsed from the XML.
    //
    private function startAnimation():void
    {
        _particle.start();
        Starling.juggler.add( _particle );
        _animationTimer.start();
    }



    //-----------------------------------------------------------------------------------------
    //
    // This function is called in response to the _animationTimer's Timer Event running
    // throughout the amount of data in the _coods Vector (Number of frames).
    //
    // A number of things is hapening in this render loop:
    // - We check that more frames are available
    // - Positions the graphics based on the given coords of the current frame.
    // - Check if any of the related _initObj params gets triggered.
    // - Notifies about Events.
    //

    private function update(event:TimerEvent):void
    {
        // Are the more frame to be played?
        if(_currentFrame < _totalFrames)
        {
            var x:int = _coords[_currentFrame].x;
            var y:int = _coords[_currentFrame].y;

            // --------------------------------------------------------------------------------
            // Test if particle is available and then move its emitter to the coords.
            if(_particle)
            {
                _particle.emitterX = x;
                _particle.emitterY = y;
            }

            if(_initObj.extraGraphic != null)
            {
                _initObj.extraGraphic.x = x;
                _initObj.extraGraphic.y = y;
            }

            // --------------------------------------------------------------------------------
            // Looks for specific frames where a NOTIFY event should be dispatched.
            var naf:Array = _initObj.notifyAtFrames;
            if(naf)
            {
                for(var i:int = 0; i<naf.length; i++)
                {
                    var f:int = int(naf[i]);
                    if(f == _currentFrame)
                        dispatchEventWith(NOTIFY_FRAME, false, _currentFrame);
                }
            }

            // --------------------------------------------------------------------------------
            // Test if animation should fade in, and at the given frame.
            if(_initObj.fadeInAt == _currentFrame)
            {
                if(_particle)
                {
                    Starling.juggler.tween(_particle, 1, {alpha:1});
                }
                Starling.juggler.tween(_initObj.extraGraphic, 1, {alpha:1});
            }

            // --------------------------------------------------------------------------------
            // Test if animation should fade out, and at the given frame.
            if(_initObj.fadeOutAt == _currentFrame)
            {
                if(_particle)
                {
                    Starling.juggler.tween(_particle, 1, {alpha:0});
                }
                Starling.juggler.tween(_initObj.extraGraphic, 1, {alpha:0});
            }

            // Frame is now parsed, now go on to the next frame.
            _currentFrame++;
        }
        // No more frame to be played!
        else
        {
            // --------------------------------------------------------------------------------
            // Test if graphics should be removed when animation is completed.
            if(_initObj.hideWhenComplete)
            {
                if(_particle)
                    _particle.stop();

                _initObj.extraGraphic.visible = false;
            }

            // Tell that animation is complete.
            dispatchEventWith(PARTICLE_COMPLETE);

            //if(_initObj.autoRewind)
            _currentFrame = 0;
        }
    }
}
}
