package {

import flash.display.Sprite;
import flash.geom.Rectangle;
import flash.media.Camera;
import flash.media.Video;
import flash.text.TextField;

import starling.core.Starling;

import starling.display.Button;

public class Main extends Sprite {


    private var camera:Camera;

    private var myStarling:Starling;

    public function Main() {

        /*camera = Camera.getCamera();
        if (camera == null)
        {
            trace( "No camera is installed.");
        }
        else
        {
            trace("Camera is installed.");
            camera.setMode( 320, 240, 10, true );
            connectCamera();
        }*/


        myStarling = new Starling(CameraScreen, stage);
        myStarling.antiAliasing = 1;
        myStarling.start();



    }

    private function connectCamera():void
    {
        var video:Video = new Video(camera.width, camera.height);
        video.x = 10;
        video.y = 10;/**/
        video.attachCamera(camera);
        addChild(video);
    }
}
}
