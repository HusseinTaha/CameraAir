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
        _scalingFactor = height / 100;
        _spacing = 10 * _scalingFactor;

        this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    private var _scalingFactor:Number;
    private var _height:Number;
    private var _btnOn:Button;
    private var _btnOff:Button;

    private var _spacing:Number = 20;

    public function get spacing():Number {
        return _spacing;
    }

    public function set spacing(value:Number):void {
        _spacing = value;
    }

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
        this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        _bg.width = _bg.width * _height / _bg.height;
        _bg.height = _height;

        width = _bg.width;
        height = _bg.height;
        var h:Number = _imgOff.height;

        _imgOff.height = _height - spacing * 2;
        _imgOn.height = _imgOff.height;

        _imgOff.width = _imgOff.width / h * _imgOff.height;
        _imgOn.width = _imgOff.width;

        _btnOff = new Button();
        _btnOff.defaultIcon = _imgOff;

        _btnOn = new Button();
        _btnOn.defaultIcon = _imgOn;


        this.addChild(_bg);
        this.showLabels = false;

        this.height = _bg.height;

        this.paddingLeft = _spacing;
        this.paddingRight = _spacing;

        this.trackLayoutMode = ToggleSwitch.TRACK_LAYOUT_MODE_ON_OFF;
        this.addEventListener(Event.CHANGE, toggleChangeHandler);
        this.setSelectionWithAnimation(true);
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
