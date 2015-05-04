/**
 * Created by husseintaha on 5/4/15.
 */
package fovea.ui.controls {
import feathers.controls.Button;
import feathers.controls.ToggleSwitch;

import starling.display.Image;
import starling.events.Event;

public class TriToggleSwitch extends ToggleSwitch {

    public static const TOGGLE_CHANGED:String = "toggle_changed";

    public function TriToggleSwitch(height:Number) {
        super();
        _height = height;
        this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    private var _height:Number;

    private var _bg:Image;

    public function get bg():Image {
        return _bg;
    }

    public function set bg(value:Image):void {
        _bg = value;
    }

    private var _imgOn:Image;

    public function get imgOn():Image {
        return _imgOn;
    }

    public function set imgOn(value:Image):void {
        _imgOn = value;
    }

    private var _imgOff:Image;

    public function get imgOff():Image {
        return _imgOff;
    }

    public function set imgOff(value:Image):void {
        _imgOff = value;
    }

    private function onAddedToStage(event:Event):void {
        _bg.width = _bg.width * _height / _bg.height;
        height = _height;

        this.addChild(_bg);
        this.thumbProperties.defaultSkin = _imgOff;
        this.showLabels = false;

        this.height = _bg.height;
        this.width = _bg.width;


        this.onTrackFactory = function ():Button {
            var button:Button = new Button();
            //skin the on track here
            button.defaultSkin = _imgOn;
            return button;
        }

        this.offTrackFactory = function ():Button {
            var offTrack:Button = new Button();
            offTrack.defaultSkin = _imgOff;
            return offTrack;
        };

        this.trackLayoutMode = ToggleSwitch.TRACK_LAYOUT_MODE_ON_OFF;
        this.addEventListener(Event.CHANGE, toggleChangeHandler);
    }

    private function toggleChangeHandler(event:Event):void {
        var toggle:ToggleSwitch = event.target as ToggleSwitch;
        if (!this.isSelected) {
            toggle.thumbProperties.defaultSkin = _imgOff;
        }
        else {
            toggle.thumbProperties.defaultSkin = _imgOn;
        }
//        dispatchEventWith(TOGGLE_CHANGED);
    }
}
}
