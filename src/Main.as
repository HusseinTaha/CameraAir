package {

import flash.display.Sprite;
import starling.core.Starling;

public class Main extends flash.display.Sprite {
    private var myStarling:Starling;

    public function Main() {
        myStarling = new Starling(MainSprite, stage);
        myStarling.antiAliasing = 1;
        myStarling.start();
    }
}
}

import starling.display.Button;
import starling.display.Sprite;
import flash.geom.Rectangle;
import starling.events.Event;

class MainSprite extends Sprite {

    public function MainSprite() {
        this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    private function onAddedToStage(event:Event):void {
        this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        var s:CameraScreen = new CameraScreen();
        /*
        s.camPosition = new Rectangle(10, 10, 280, 280);
        s.foreground = new Image(Assets.getTexture("CameraForeground"));
        s.okButton = new Button(Assets.getTexture("CameraTexture"));
        s.cancelButton = new Button(Assets.getTexture("CancelTexture"));
        s.acceptButton = new Button(Assets.getTexture("CameraTexture"));
        s.discardButton = new Button(Assets.getTexture("CancelTexture"));
        */
        addChild(s);
        /*
        s.addEventListener(CameraScreen.CLOSED, function():void {
            trace("camera closed");
        });
        s.addEventListener(CameraScreen.TRIGGERED, function():void {
            trace("camera closed");
            var imgBytes:ByteArray = s.getJPEG();
        });
        */
    }
}
