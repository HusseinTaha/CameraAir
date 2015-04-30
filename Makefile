run: Main.swf
	adl -profile extendedDesktop Main-app.xml .

Main.swf: src/Main.as src/MainSprite.as src/fovea/ui/camera/CameraView.as src/fovea/ui/CameraScreen.as src/Assets.as starling.swc
	amxmlc --library-path=starling.swc --source-path=as3corelib/src src/Main.as
	mv src/Main.swf Main.swf

starling.swc:
	curl https://raw.githubusercontent.com/Gamua/Starling-Framework/master/starling/bin/starling.swc > starling.swc
