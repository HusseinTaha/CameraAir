/**
 * Created by husseintaha on 4/29/15.
 */
package fovea.ui.camera {


import com.adobe.images.JPGEncoder;
import com.adobe.images.PNGEncoder;

import flash.display.BitmapData;
import flash.display3D.textures.Texture;
import flash.events.Event;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import flash.media.Camera;
import flash.media.Video;
import flash.utils.ByteArray;

import starling.display.Image;
import starling.display.Sprite;
import starling.extensions.pixelmask.PixelMaskDisplayObject;
import starling.textures.Texture;

/**
 * Handles the display of a camera in Starling
 *
 * @author mtanenbaum
 */
public class CameraView extends Sprite
{
    /** Minimum allowable downsample size */
    private static const DOWNSAMPLE_MIN:Number = 0.001;

    /** Maximum frame rate (not acutally enforced, just generates a warning) */
    private static const MAX_FRAME_RATE:int = 99;

    //Native

    public static function encodePNG(bitmapData:BitmapData):ByteArray {
        var png:ByteArray = PNGEncoder.encode(bitmapData);
        return png;
    }

    public static function encodeJPEG(bitmapData:BitmapData):ByteArray {
        var j:JPGEncoder = new JPGEncoder();
        var jpg:ByteArray = j.encode(bitmapData);
        return jpg;
    }

    /**
     * Class constructor
     */
    public function CameraView() {
    }

    //Starling
    private var camera:Camera;

    //Configs
    private var video:Video;
    private var bmd:BitmapData;
    private var image:Image;
    private var screenRect:Rectangle;
    private var fps:uint = 24;
    private var downSample:Number = 1;
    private var rotate:Boolean = false;
    private var matrix:Matrix;
    private var _imagePixelMask:PixelMaskDisplayObject;

    private var _mirror:Boolean = false;

    /**
     * Get the current reflection setting
     */
    public function get mirror():Boolean
    {
        return _mirror;
    }

    private var _imgFrame:Image;

    public function get imgFrame():Image {
        return _imgFrame;
    }

    public function set imgFrame(value:Image):void {
        _imgFrame = value;
    }

    /**
     * Set up the capture parameters
     *
     * @param screenRect The "viewport" for the camera
     * @param fps         A uint 0-n for the camera speed. Lower fps will of course improve performance
     * @param downSample A value >0 && <=1 for reducing the size of the image. Can drastically improve performance at the cost of image quality
     * @param rotate     Fix for bug on Air for IOS/Android. Set to true when on these platforms to correct rotation
     */
    public function init(screenRect:Rectangle, fps:uint = 24, downSample:Number = 1, rotate:Boolean = false):void
    {
        trace("CameraView in rotate mode", rotate);

        this.screenRect = screenRect;
        this.fps = fps;
        if (fps == 0) {
            trace("WARNING::You're setting camera fps to 0. That's kinda lame.");
        }
        else if (fps > MAX_FRAME_RATE) {
            trace("WARNING::You're setting camera fps to", fps, "which is processor-intensive and probably too high to be useful.");
        }

        //Clamp the downsample between .1% and 1
        this.downSample = Math.max(DOWNSAMPLE_MIN, downSample);
        this.downSample = Math.min(1, this.downSample);

        this.rotate = rotate;

        matrix = new Matrix();
        matrix.scale(downSample, downSample);
        if (_mirror) {
            matrix.a *= -1;
            matrix.tx = (matrix.tx == 0) ? screenRect.width : 0;
        }

        if (rotate) {
            matrix.rotate(Math.PI / 2);
        }

    }

    /**
     * Stop updates
     */
    public function pause():void
    {
        if (video) {
            video.removeEventListener(Event.ENTER_FRAME, onVideoUpdate);
        }
    }

    public function resume():void
    {
        if (video) {
            video.addEventListener(Event.ENTER_FRAME, onVideoUpdate);
        }
    }

    /**
     * Pick a camera by id
     */
    public function selectCamera(cameraId:uint):void
    {
        if (video) {
            video.attachCamera(null);
            video.removeEventListener(Event.ENTER_FRAME, onVideoUpdate);
            camera = null;
        }

        camera = Camera.getCamera(cameraId.toString());
        if (camera) {
            var w:Number = camera.width;
            var h:Number = camera.height;


            if (rotate) {
                video = new Video(screenRect.height, screenRect.width);
            }
            else {
                video = new Video(screenRect.width, screenRect.height);
            }


            bmd = new BitmapData(screenRect.width * downSample, screenRect.height * downSample);


            video.addEventListener(Event.ENTER_FRAME, onVideoUpdate);
            var texture:starling.textures.Texture = starling.textures.Texture.fromBitmapData(bmd, false, false, downSample);
            image = new Image(texture);
            x = screenRect.x;
            y = screenRect.y;
            width = screenRect.width;
            height = screenRect.height;

            if (w / h > screenRect.width / screenRect.height) {
                w = w / h * screenRect.height;
                h = screenRect.height;
            } else {
                h = h / w * screenRect.width;
                w = screenRect.width;
            }

            camera.setMode(w, h, fps, false);
            video.attachCamera(camera);

            image.width = screenRect.width;
            image.height = screenRect.height;
            addChild(image);

            imgFrame.x = 0;
            imgFrame.y = 0;
            imgFrame.width = image.width;
            imgFrame.height = image.height;


            addChild(imgFrame);

            _imagePixelMask = new PixelMaskDisplayObject();
            _imagePixelMask.mask = imgFrame;
            _imagePixelMask.addChild(image);

            addChild(_imagePixelMask);
        }
        else {
            trace("couldn't find camera", cameraId, "among cameras", Camera.names);
        }
    }

    /**
     * Toggle the camera between reflecting & not
     *
     * Mirorring is false by default, so if you want it on, call this method directly after <code>init()</code>
     */
    public function reflect():void
    {
        _mirror = !_mirror;
        if (matrix) {
            matrix.a *= -1;
            matrix.tx = (_mirror) ? (screenRect.width * downSample) : 0;
        }
    }

    /**
     * Retrieve a still from the camera
     *
     * This method doesn't downsample, so your image is full resolution
     *
     * @return a BitmapData snapshot from the camera
     */
    public function getImage():BitmapData
    {
        var retv:BitmapData = new BitmapData(screenRect.width, screenRect.height);
        var m:Matrix = matrix.clone();
        m.scale(1 / downSample, 1 / downSample);

        retv.draw(video, m);
        return retv;
    }

    /**
     * Draw to the GPU every frame
     */
    private function onVideoUpdate(event:*):void {
        bmd.draw(video, matrix);
        flash.display3D.textures.Texture(image.texture.base).uploadFromBitmapData(bmd);
    }
}


}
