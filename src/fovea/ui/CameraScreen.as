/**
 * Created by husseintaha on 4/29/15.
 */
package fovea.ui {
import flash.display.BitmapData;
import flash.geom.Rectangle;
import flash.utils.ByteArray;

import fovea.ui.camera.CameraView;

import starling.display.Button;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.textures.Texture;

public class CameraScreen extends Sprite {

    public static const TAKE_PICTURE:String = "take_picture";
    public static const CLOSED:String = "closed";
    public static const ACCEPT_PICTURE:String = "accept_picture";
    public static const RETAKE:String = "retake";

    /**
     * CameraScreen: constructor
     * */
    public function CameraScreen() {
        super();
        this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    private var cameraView:CameraView;
    private var _bitmapData:BitmapData;
    private var imageIndex:Number = 3;

    private var _okButton:Button;

    public function get okButton():Button {
        return _okButton;
    }

    public function set okButton(value:Button):void {
        _okButton = value;
    }

    private var _cancelButton:Button;

    public function get cancelButton():Button {
        return _cancelButton;
    }

    public function set cancelButton(value:Button):void {
        _cancelButton = value;
    }

    private var _acceptButton:Button;

    public function get acceptButton():Button {
        return _acceptButton;
    }

    public function set acceptButton(value:Button):void {
        _acceptButton = value;
    }

    private var _discardButton:Button;

    public function get discardButton():Button {
        return _discardButton;
    }

    public function set discardButton(value:Button):void {
        _discardButton = value;
    }

    private var _camPosition:Rectangle;

    public function get camPosition():Rectangle {
        return _camPosition;
    }

    public function set camPosition(value:Rectangle):void {
        _camPosition = value;
    }

    private var _foreground:Image;

    public function get foreground():Image {
        return _foreground;
    }

    public function set foreground(value:Image):void {
        _foreground = value;
        if (value != null) imageIndex = 4;
    }

    private var _buttonSpacing:Number = 40;

    public function get buttonSpacing():Number {
        return _buttonSpacing;
    }

    public function set buttonSpacing(value:Number):void {
        _buttonSpacing = value;
    }

    public function getJPEG():ByteArray {
        return CameraView.encodeJPEG(_bitmapData);
    }

    public function getPNG():ByteArray {
        return CameraView.encodePNG(_bitmapData);
    }

    private function hideControls():void {
        _discardButton.visible = false;
        _acceptButton.visible = false;
    }

    private function showControls():void {
        _discardButton.visible = true;
        _acceptButton.visible = true;
    }

    private function onAddedToStage(event:Event):void {
        this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        //Create a camera view
        cameraView = new CameraView();

        if (_camPosition == null) _camPosition = new Rectangle(0, 0, 320, 240);
        cameraView.init(_camPosition, 20);
        //Each time you call reflect() you toggle mirroring on/off
        cameraView.reflect();
        //Put it onstage
        addChild(cameraView);

        if (_foreground) {
            _foreground.x = _camPosition.x;
            _foreground.y = _camPosition.y;
            addChild(_foreground);
        }
        //Select a webcam
        cameraView.selectCamera(0);
        _okButton.x = cameraView.width / 2 - _okButton.width / 2 + _buttonSpacing;
        _okButton.y = cameraView.height * .8;
        addChild(_okButton);

        _cancelButton.x = cameraView.width / 2 - _cancelButton.width / 2 - _buttonSpacing;
        _cancelButton.y = _okButton.y + 10;
        addChild(_cancelButton);

        _discardButton.x = _cancelButton.x;
        _discardButton.y = _cancelButton.y;

        _acceptButton.x = _okButton.x;
        _acceptButton.y = _okButton.y;

        addChild(_discardButton);
        addChild(_acceptButton);
        hideControls();

        this.addEventListener(Event.TRIGGERED, onClickCamera);

    }

    private function onClickCamera(event:Event):void {
        var btn:Button = event.target as Button;
        if (btn == _okButton) {
            _bitmapData = cameraView.getImage();
            var image:Image = new Image(Texture.fromBitmapData(_bitmapData));
            addChildAt(image, imageIndex);
            cameraView.pause();
            showControls();
            dispatchEvent(new Event(TAKE_PICTURE));
        } else if (btn == _cancelButton) {
            dispatchEvent(new Event(CLOSED));
        } else if (btn == _acceptButton) {
            dispatchEvent(new Event(ACCEPT_PICTURE));
        } else if (btn == _discardButton) {
            removeChildAt(imageIndex, true);
            hideControls();
            cameraView.resume();
            dispatchEvent(new Event(RETAKE));
        }
    }
}
}
