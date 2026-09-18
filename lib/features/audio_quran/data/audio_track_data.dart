import '../models/audio_surah_model.dart';
import '../models/audio_track_model.dart';

class AudioTrackData {
  static List<AudioTrackModel> createTracks(
    List<AudioSurahModel> surahs,
  ) {
    return surahs
        .map(
          (surah) => AudioTrackModel(
            surahNumber: surah.number,
            surahName: surah.name,
            arabicName: surah.arabicName,
          ),
        )
        .toList();
  }
}
