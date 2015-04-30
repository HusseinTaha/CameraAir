package {

import flash.display.Sprite;
import flash.media.Camera;

import starling.core.Starling;

public class Main extends Sprite {


    public function Main() {

        myStarling = new Starling(MainSprite, stage);
        myStarling.antiAliasing = 1;
        myStarling.start();
    }
    private var camera:Camera;
    private var myStarling:Starling;

}
}
