import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/hadith_models.dart';

class HadithController {
  static const String _assetPath = 'assets/json/hadith/bukhari_ifa.json';

  Future<List<Hadith>> loadHadiths() async {
    final jsonString = await rootBundle.loadString(_assetPath);
    final Map<String, dynamic> data = json.decode(jsonString);

    final List<dynamic> hadithList =
        data['hadiths'] as List<dynamic>? ?? <dynamic>[];

    return hadithList.map((item) {
      final Map<String, dynamic> json = item as Map<String, dynamic>;

      return Hadith(
        id: json['id'] as int,
        collection: data['collection'] as String,
        publisher: data['publisher'] as String,
        volume: data['volume'] as String,
        chapter: json['chapter'] as String,
        hadithNumber: json['hadithNumber'] as int,
        narrator: json['narrator'] as String,
        arabic: json['arabic'] as String,
        bengali: json['bengali'] as String,
        reference: json['reference'] as String,
        grade: json['grade'] as String? ?? '',
      );
    }).toList();
  }
}
