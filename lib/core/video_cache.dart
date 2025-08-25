import 'package:video_player/video_player.dart';

class VideoCache {
	VideoCache._();
	static final VideoCache instance = VideoCache._();

	final Map<String, VideoPlayerController> _controllers = {};
	final Map<String, Future<void>> _initializations = {};

	Future<void> preload(String assetPath, {bool looping = true, double volume = 0.0}) {
		if (_controllers.containsKey(assetPath)) {
			return _initializations[assetPath] ?? Future.value();
		}
		final controller = VideoPlayerController.asset(assetPath)
			..setLooping(looping)
			..setVolume(volume);
		_controllers[assetPath] = controller;
		final initFuture = controller.initialize();
		_initializations[assetPath] = initFuture;
		return initFuture;
	}

	VideoPlayerController? getController(String assetPath) => _controllers[assetPath];
	Future<void>? getInitialization(String assetPath) => _initializations[assetPath];

	Future<void> release(String assetPath) async {
		final controller = _controllers.remove(assetPath);
		_initializations.remove(assetPath);
		await controller?.dispose();
	}
}


