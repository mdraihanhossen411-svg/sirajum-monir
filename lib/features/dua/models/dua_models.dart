import 'dart:convert';
import 'package:flutter/services.dart';

class DuaItem {
  final String id;
  final String category;
  final String title;
  final String arabic;
  final String pronunciation;
  final String meaning;
  final String source;

  const DuaItem({
    required this.id,
    required this.category,
    required this.title,
    required this.arabic,
    required this.pronunciation,
    required this.meaning,
    required this.source,
  });
}

const _quranDuaRefs = <Map<String, Object>>[
  {'s': 2, 'a': 127, 't': 'কাবা নির্মাণের পর কবুলের দোয়া', 'c': 'কবুলিয়াত'},
  {'s': 2, 'a': 128, 't': 'আনুগত্য ও তওবার দোয়া', 'c': 'হিদায়াত'},
  {'s': 2, 'a': 201, 't': 'দুনিয়া ও আখিরাতের কল্যাণ', 'c': 'সাধারণ দোয়া'},
  {'s': 2, 'a': 250, 't': 'বিপদে ধৈর্য ও সাহায্যের দোয়া', 'c': 'বিপদ ও ধৈর্য'},
  {'s': 2, 'a': 286, 't': 'ক্ষমা ও দয়ার প্রার্থনা', 'c': 'ক্ষমা প্রার্থনা'},
  {
    's': 3,
    'a': 8,
    't': 'অন্তরকে হিদায়াতের পর বক্র না করার দোয়া',
    'c': 'হিদায়াত',
  },
  {'s': 3, 'a': 16, 't': 'জাহান্নাম থেকে মুক্তির প্রার্থনা', 'c': 'আখিরাত'},
  {'s': 3, 'a': 53, 't': 'সত্যের সাক্ষ্য ও আনুগত্যের দোয়া', 'c': 'ঈমান'},
  {'s': 3, 'a': 147, 't': 'ক্ষমা ও দৃঢ়তার দোয়া', 'c': 'ক্ষমা প্রার্থনা'},
  {'s': 3, 'a': 191, 't': 'জাহান্নাম থেকে রক্ষার প্রার্থনা', 'c': 'আখিরাত'},
  {'s': 3, 'a': 193, 't': 'ঈমানের আহ্বান কবুলের দোয়া', 'c': 'ঈমান'},
  {'s': 7, 'a': 23, 't': 'ক্ষমা ও রহমতের দোয়া', 'c': 'ক্ষমা প্রার্থনা'},
  {'s': 7, 'a': 47, 't': 'জালিমদের সঙ্গে না রাখার দোয়া', 'c': 'বিপদ ও ধৈর্য'},
  {
    's': 10,
    'a': 85,
    't': 'জালিমদের পরীক্ষায় না ফেলার দোয়া',
    'c': 'বিপদ ও ধৈর্য',
  },
  {
    's': 10,
    'a': 86,
    't': 'অবিশ্বাসীদের হাত থেকে মুক্তির দোয়া',
    'c': 'বিপদ ও ধৈর্য',
  },
  {'s': 14, 'a': 40, 't': 'নামাজ কায়েমের দোয়া', 'c': 'ইবাদত'},
  {
    's': 14,
    'a': 41,
    't': 'নিজের ও মুমিনদের জন্য ক্ষমার দোয়া',
    'c': 'ক্ষমা প্রার্থনা',
  },
  {
    's': 17,
    'a': 24,
    't': 'পিতা-মাতার প্রতি রহমতের দোয়া',
    'c': 'পরিবার ও পিতা-মাতা',
  },
  {'s': 18, 'a': 10, 't': 'রহমত ও সঠিক পথের দোয়া', 'c': 'হিদায়াত'},
  {'s': 20, 'a': 25, 't': 'বক্ষ প্রশস্ত করার দোয়া', 'c': 'কাজ ও সহজতা'},
  {'s': 20, 'a': 26, 't': 'কাজ সহজ করার দোয়া', 'c': 'কাজ ও সহজতা'},
  {'s': 20, 'a': 27, 't': 'কথার জড়তা দূর করার দোয়া', 'c': 'কাজ ও সহজতা'},
  {'s': 20, 'a': 28, 't': 'কথা বোঝার সুবিধার দোয়া', 'c': 'কাজ ও সহজতা'},
  {'s': 23, 'a': 109, 't': 'ক্ষমা ও রহমতের দোয়া', 'c': 'ক্ষমা প্রার্থনা'},
  {'s': 25, 'a': 65, 't': 'জাহান্নামের শাস্তি থেকে আশ্রয়', 'c': 'আখিরাত'},
  {
    's': 25,
    'a': 74,
    't': 'পরিবারকে চোখের শীতলতা করার দোয়া',
    'c': 'পরিবার ও পিতা-মাতা',
  },
  {
    's': 27,
    'a': 19,
    't': 'নেয়ামতের শুকরিয়া ও নেক আমলের দোয়া',
    'c': 'কৃতজ্ঞতা',
  },
  {
    's': 28,
    'a': 16,
    't': 'নিজের প্রতি জুলুমের ক্ষমা প্রার্থনা',
    'c': 'ক্ষমা প্রার্থনা',
  },
  {'s': 40, 'a': 7, 't': 'মুমিনদের জন্য ক্ষমার দোয়া', 'c': 'ক্ষমা প্রার্থনা'},
  {'s': 60, 'a': 4, 't': 'আল্লাহর ওপর ভরসার দোয়া', 'c': 'ঈমান'},
  {'s': 66, 'a': 8, 't': 'নূর পূর্ণতা ও ক্ষমার দোয়া', 'c': 'ক্ষমা প্রার্থনা'},
  {
    's': 71,
    'a': 28,
    't': 'নিজের, পিতা-মাতা ও মুমিনদের জন্য দোয়া',
    'c': 'ক্ষমা প্রার্থনা',
  },
];

const _surahNames = <int, String>{
  2: 'আল-বাকারা',
  3: 'আলে-ইমরান',
  7: 'আল-আ‘রাফ',
  10: 'ইউনুস',
  14: 'ইবরাহিম',
  17: 'আল-ইসরা',
  18: 'আল-কাহফ',
  20: 'ত্বা-হা',
  23: 'আল-মুমিনুন',
  25: 'আল-ফুরকান',
  27: 'আন-নামল',
  28: 'আল-কাসাস',
  40: 'গাফির',
  60: 'আল-মুমতাহিনা',
  66: 'আত-তাহরীম',
  71: 'নূহ',
};

const _knownPronunciations = <String, String>{
  'quran_2_201':
      'রব্বানা আতিনা ফিদ্দুনইয়া হাসানাতাঁও ওয়া ফিল আখিরাতি হাসানাতাঁও ওয়া কিনা আযাবান নার।',
  'quran_20_114': 'রব্বি যিদনি ইলমা।',
  'quran_7_23':
      'রব্বানা যলামনা আনফুসানা, ওয়া ইল্লাম তাগফির লানা ওয়া তারহামনা লানাকুনান্না মিনাল খাসিরিন।',
  'quran_14_41':
      'রব্বানাগফির লি ওয়া লিওয়ালিদাইয়া ওয়া লিলমুমিনিনা ইয়াওমা ইয়াকুমুল হিসাব।',
};

/// Offline Qur'an data থেকে দোয়ার আরবি ও বাংলা অনুবাদ লোড করে।
Future<List<DuaItem>> loadDuaItems() async {
  final cache = <int, List<dynamic>>{};
  final result = <DuaItem>[];

  for (final ref in _quranDuaRefs) {
    final surah = ref['s']! as int;
    final ayah = ref['a']! as int;
    final id = 'quran_${surah}_$ayah';

    if (!cache.containsKey(surah)) {
      final raw = await rootBundle.loadString(
        'assets/json/quran/core/surah_$surah.json',
      );
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      cache[surah] = decoded['ayahs'] as List<dynamic>;
    }

    final rows = cache[surah]!;
    final matches = rows.where(
      (row) => (row as Map<String, dynamic>)['number'] == ayah,
    );
    if (matches.isEmpty) {
      throw FormatException('কুরআনের আয়াত পাওয়া যায়নি: $surah:$ayah');
    }

    final verse = matches.first as Map<String, dynamic>;
    final arabic = (verse['arabicText'] as String? ?? '').trim();
    final meaning = (verse['banglaText'] as String? ?? '').trim();
    if (arabic.isEmpty || meaning.isEmpty) {
      throw FormatException('আয়াতের আরবি/বাংলা অনুবাদ ফাঁকা: $surah:$ayah');
    }

    result.add(
      DuaItem(
        id: id,
        category: ref['c']! as String,
        title: ref['t']! as String,
        arabic: arabic,
        pronunciation: _knownPronunciations[id] ?? '',
        meaning: meaning,
        source:
            'আল-কুরআন, সূরা ${_surahNames[surah] ?? surah.toString()} $surah:$ayah',
      ),
    );
  }

  return List<DuaItem>.unmodifiable(result);
}
