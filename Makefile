run: Main.swf
	adl -profile extendedDesktop Main-app.xml .

Main.swf: src/Main.as src/MainSprite.as src/fovea/ui/camera/CameraView.as src/fovea/ui/CameraScreen.as src/Assets.as starling.swc feathers.swc
	amxmlc --library-path=starling.swc --library-path=feathers.swc --source-path=as3corelib/src --source-path=pixelmask/src src/Main.as
	mv src/Main.swf Main.swf

starling.swc:
	curl https://raw.githubusercontent.com/Gamua/Starling-Framework/master/starling/bin/starling.swc > starling.swc

feathers.swc:
	curl https://github.com/joshtynjala/feathers/releases/download/v2.1.1/feathers-2.1.1.zip > feathers-2.1.1.zip
	unzip -p -x feathers-2.1.1.zip swc/feathers.swc > feathers.swc
