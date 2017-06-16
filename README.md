# motionparticlesprite
Mock up at motion path in Flash Pro and use it to guide a particle in your starling scene.

- Blog Post -> http://bjeld.com/tools/get-creative-with-particles/
- Video Demo -> https://vimeo.com/53717875

### Quick Start
I have created a Starling Extension that you can download below along with a very simple JSFL script used to output the motion you mock up in Flash Professional.

1. Mock up the path you want your particle to have in Flash Pro
2. Run the custom JSFL script (SimpleMotionXML.jsfl) to export your path to XML.
3. Now you have an XML copied to your clipboard. Now simply create a new MotionParticleSprite instane as follows:
```actionscript
// Create an init Object used to configure behavior. first param is the particle
// XML Config file that you exported from fx- Particle-Designer. The second param is
// the particle Texture.</pre>
var initObj:MotionParticleSpriteInitObject = new MotionParticleSpriteInitObject
(
     XML(new PARTICLE()),
     myAssetManager.getTexture( AssetConstants.PARTICLE )
 );
 
// Store the Clipboard XML
var xmlPastedFromClipboard:XML = PASTE_HERE;
 
// Create the MotionParticSprite and pass the XML and the Init Obj.
var motionParticleSprite:MotionParticleSprite = new MotionParticleSprite( xmlPastedFromClipboard , initObj);
addChild( motionParticleSprite );
motionParticleSprite.initialize(); // this takes care of making the particle ready.
motionParticleSprite.play(); // this starts the particle.
```

With the Init Object you can configure these properties.

- fadeInAt
- fadeOutAt
- delay
- notifyAtFrames
- hideWhenComplete
- extraGraphic
- extraGraphicOnTop
- frameRate
