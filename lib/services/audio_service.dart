class AudioService {
  bool _isPlaying = false;

  bool get isPlaying => _isPlaying;

  Future<void> play(String path) async {
    _isPlaying = true;
    // TODO: Play audio
  }

  Future<void> pause() async {
    _isPlaying = false;
    // TODO: Pause audio
  }

  Future<void> stop() async {
    _isPlaying = false;
    // TODO: Stop audio
  }
}
