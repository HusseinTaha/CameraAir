/**
 * Created by husseintaha on 4/30/15.
 */
package {
import flash.display.Bitmap;
import flash.utils.Dictionary;

import starling.textures.Texture;

public class Assets {


    [Embed(source="../medias/graphics/camera.png")]
    public static var CameraTexture:Class;


    [Embed(source="../medias/graphics/cancel.png")]
    public static var CancelTexture:Class;

    [Embed(source="../medias/graphics/frame.png")]
    public static var Frame:Class;


    private static var gameTextures:Dictionary = new Dictionary();



    public static function getTexture(name:String):Texture
    {
        if (gameTextures[name] == undefined)
        {
            var bitmap:Bitmap = new Assets[name]();
            gameTextures[name] = Texture.fromBitmap(bitmap);
        }
        return gameTextures[name];
    }

}
}
