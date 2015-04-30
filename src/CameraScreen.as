/**
 * Created by husseintaha on 4/29/15.
 */
package {
import flash.display.BitmapData;
import flash.filesystem.File;
import flash.geom.Rectangle;
import flash.utils.ByteArray;

import starling.display.Button;
import starling.display.Image;

import starling.display.Sprite;
import starling.events.Event;
import starling.textures.Texture;

public class CameraScreen extends Sprite {

    private var cameraView:CameraView;

    private var buttonShoot:Button;
    private var buttonCancel:Button;

    private var accepteButton:Button;
    private var discardButton:Button;

    private var docsDir:File = File.documentsDirectory;
    private var imgBytes:ByteArray;


    public function CameraScreen() {
        super ();
        this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    private function onAddedToStage(event:Event):void {
        this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        //Create a camera view
        cameraView = new CameraView();

        buttonShoot =  new Button(Assets.getTexture("CameraTexture"));
        buttonCancel =  new Button(Assets.getTexture("CancelTexture"));

        accepteButton=  new Button(Assets.getTexture("CameraTexture"));
        discardButton =  new Button(Assets.getTexture("CancelTexture"));

        //Initialize. Pass in:
        //1. a rect to define the camera "viewport"
        //2. a capture rate (fps, default 24)
        //3. a downsample value (.5 means half-height, half-width, default 1)
        //4. true if you want to rotate the camera (default false)
        cameraView.init(new Rectangle(0, 0, 320, 240), 20);
        //Each time you call reflect() you toggle mirroring on/off
        cameraView.reflect();
        //Put it onstage
        addChild(cameraView);
        //Select a webcam
        cameraView.selectCamera(0);
        buttonShoot.x = cameraView.width / 2 - buttonShoot.width / 2 + 40;
        buttonShoot.y = cameraView.height * .8 ;
        addChild(buttonShoot);

        buttonCancel.x = cameraView.width / 2 - buttonCancel.width / 2 - 40;
        buttonCancel.y = buttonShoot.y + 10 ;
        addChild(buttonCancel);

        discardButton.x = buttonCancel.x;
        discardButton.y = buttonCancel.y;

        accepteButton.x = buttonShoot.x;
        accepteButton.y = buttonShoot.y;

        addChild(discardButton);
        addChild(accepteButton);
        hideControls();

        this.addEventListener(Event.TRIGGERED, onClickCamera);

        trace("cameraview.height: " + cameraView.height);

    }

    private function onClickCamera(event:Event):void
    {
        var btn:Button = event.target as Button;

        if(btn == buttonShoot)
        {
            var bitmap:BitmapData = cameraView.getImage();
            var image:Image = new Image(Texture.fromBitmapData(bitmap));
            addChildAt(image, 3);
            cameraView.pause();
            imgBytes = CameraView.encodePNG(bitmap);
            showControls();
            /*try
            {
                docsDir.browseForSave("Save As");
                docsDir.addEventListener(Event.SELECT, saveData);
            }
            catch (error:Error)
            {
                trace("Failed:", error.message);
            }*/
        }else if(btn == buttonCancel)
        {

        }else if(btn == accepteButton)
        {

        }else if(btn == discardButton)
        {
            removeChildAt(3, true);
            image = null;
            hideControls();
            cameraView.resume();
        }
    }

    /*private function saveData(event:Event):void {
        var newFile:File = event.target as File;
        if (!newFile.exists) // remove this 'if' if overwrite is OK.
        {
            var stream:FileStream = new FileStream();
            stream.open(newFile, FileMode.WRITE);
            stream.writeBytes(imgBytes);
            stream.close();
        }
        else trace('Selected path already exists.');
    }*/

    private function hideControls():void
    {
        discardButton.visible = false;
        accepteButton.visible = false;
    }
    private function showControls():void
    {
        discardButton.visible = true;
        accepteButton.visible = true;
    }



}
}
