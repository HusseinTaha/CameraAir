/**
 * Created by husseintaha on 4/30/15.
 */
package {
import flash.geom.Rectangle;
import flash.utils.ByteArray;

import fovea.ui.CameraScreen;
import fovea.ui.controls.TriToggleSwitch;

import starling.display.Button;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;

public class MainSprite extends Sprite {

    public function MainSprite() {
        this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    private function onToggleChange(event:TriToggleSwitch):void {
        trace("toggle");
    }

    private function onAddedToStage(event:Event):void {
        this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        var s:CameraScreen = new CameraScreen();

        s.camPosition = new Rectangle(100, 100, 280, 280);
        s.foreground = new Image(Assets.getTexture("CameraTexture"));
        s.okButton = new Button(Assets.getTexture("CameraTexture"));
        s.cancelButton = new Button(Assets.getTexture("CancelTexture"));
        s.acceptButton = new Button(Assets.getTexture("CameraTexture"));
        s.discardButton = new Button(Assets.getTexture("CancelTexture"));
        addChild(s);

        s.addEventListener(CameraScreen.CLOSED, function (event:Event):void {
            trace("camera closed");
        });
        s.addEventListener(CameraScreen.ACCEPT_PICTURE, function (event:Event):void {
            trace("camera closed");
            var imgBytes:ByteArray = s.getJPEG();
        });

        var ts:TriToggleSwitch = new TriToggleSwitch(100);
        ts.imgOff = new Image(Assets.getTexture("ToggleOff"));
        ts.imgOn = new Image(Assets.getTexture("ToggleOn"));
        ts.bg = new Image(Assets.getTexture("ToggleBG"));
        ts.x = 200;
        ts.y = 0;

        addChild(ts);

//        ts.addEventListener(TriToggleSwitch.TOGGLE_CHANGED, onToggleChange);
    }


}
}
