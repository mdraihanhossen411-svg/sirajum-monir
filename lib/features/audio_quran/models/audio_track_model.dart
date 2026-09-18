class AudioTrackModel {
  final int surahNumber;
  final String surahName;
  final String arabicName;
  final String? audioUrl;

  const AudioTrackModel({
    required this.surahNumber,
    required this.surahName,
    required this.arabicName,
    this.audioUrl,
  });

  bool get hasAudio => audioUrl != null && audioUrl!.isNotEmpty;
}
