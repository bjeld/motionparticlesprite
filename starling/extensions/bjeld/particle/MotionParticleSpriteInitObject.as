/**
 * Created by martinbjeld on 9/4/14.
 */
package starling.extensions.bjeld.particle {
import starling.display.DisplayObject;
import starling.textures.Texture;

public class MotionParticleSpriteInitObject {

    /**
     * Keyframe where and if the particle should do a fade in
     */
    public var fadeInAt : int = -1;

    /**
     * Keyframe where and if the particle should do a fade out
     */
    public var fadeOutAt : int = -1;
    /**
     * Millisecond to wait before starting particle
     */
    public var delay : int = 0;
    /**
     * Array of of frames where you would like to have an event
     * dispatched.
     *
     */
    public var notifyAtFrames : Array;
    /**
     * Do you want the particle to hide when it reaches the last frame
     */
    public var hideWhenComplete: Boolean;

    /**
     * An optional Starling DisplayObject that will follow along the path og the particle.
     */
    public var extraGraphic:DisplayObject;

    /**
     * An optional boolean that decides if you extraGraphic should be above or below the particle.
     */
    public var extraGraphicOnTop:Boolean;

    /**
     *
     */
    public var frameRate:int = 12;

    private var _configXML:XML;
    private var _particleTexture:Texture;

    public function MotionParticleSpriteInitObject( configXML:XML, particleTexture:Texture ) {
        _particleTexture = particleTexture;
        _configXML = configXML;
    }

    public function get particleTexture():Texture
    {
        return _particleTexture;
    }
    public function get configXML():XML
    {
        return _configXML;
    }
}
}
