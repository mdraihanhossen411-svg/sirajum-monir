import 'package:flutter/material.dart';

import '../../../core/notifications/notification_service.dart';

import '../controllers/prayer_controller.dart';
import '../models/bangladesh_location.dart';
import '../data/bangladesh_locations.dart';
import '../models/prayer_models.dart';

class PrayerPage extends StatefulWidget {
  const PrayerPage({super.key});

  @override
  State<PrayerPage> createState() => _PrayerPageState();
}

class _PrayerPageState extends State<PrayerPage> {
  final PrayerController _controller = PrayerController();

  late Future<PrayerDayTimes> _prayerTimesFuture;

  String _selectedDivision = 'ঢাকা';
  String _selectedDistrict = 'ঢাকা';
  bool _usingGps = false;
  bool _loadingLocation = true;

  static const Color green = Color(0xFF0A8754);
  static const Color gold = Color(0xFFC9A227);

  @override
  void initState() {
    super.initState();
    _loadSavedLocation();
  }

  Future<void> _loadSavedLocation() async {
    final location = await _controller.getSelectedLocation();

    if (!mounted) return;

    setState(() {
      _selectedDivision = location.division;
      _selectedDistrict = location.district;
      _loadingLocation = false;
      _loadPrayerTimes();
    });
  }

  void _loadPrayerTimes() {
    _prayerTimesFuture = _controller.getTodayPrayerTimes(
      useGps: _usingGps,
    );
  }

  Future<void> _refresh() async {
    setState(_loadPrayerTimes);
    await _prayerTimesFuture;
  }

  String _banglaNumber(int number) {
    const en = '0123456789';
    const bn = '০১২৩৪৫৬৭৮৯';

    return number
        .toString()
        .split('')
        .map((c) => bn[en.indexOf(c)])
        .join();
  }

  String _formatTime(DateTime time) {
    var hour = time.hour;
    final minute = time.minute;

    final period = hour >= 12 ? 'PM' : 'AM';

    hour = hour % 12;
    if (hour == 0) {
      hour = 12;
    }

    return '${_banglaNumber(hour)}:'
        '${_banglaNumber(minute).padLeft(2, '০')} '
        '$period';
  }


  List<PrayerTime> _orderedPeriods(PrayerDayTimes times) {
    return [
      times.fajr,
      PrayerTime(
        name: 'সূর্যোদয়',
        time: times.sunrise,
        endTime: times.dhuhr.time,
      ),
      times.dhuhr,
      times.asr,
      times.maghrib,
      times.isha,
    ];
  }

  PrayerTime _getCurrentPeriod(PrayerDayTimes times) {
    final now = DateTime.now();

    final periods = _orderedPeriods(times);

    for (final period in periods) {
      if (!now.isBefore(period.time) &&
          now.isBefore(period.endTime)) {
        return period;
      }
    }

    if (now.isBefore(times.fajr.time)) {
      return PrayerTime(
        name: 'ফজরের অপেক্ষা',
        time: times.fajr.time,
        endTime: times.fajr.time,
      );
    }

    return PrayerTime(
      name: 'এশা',
      time: times.isha.time,
      endTime: times.isha.endTime,
    );
  }

  PrayerTime _getNextPeriod(PrayerDayTimes times) {
    final now = DateTime.now();

    final periods = _orderedPeriods(times);

    for (final period in periods) {
      if (period.time.isAfter(now)) {
        return period;
      }
    }

    return PrayerTime(
      name: 'ফজর',
      time: times.fajr.time.add(const Duration(days: 1)),
      endTime: times.fajr.endTime.add(const Duration(days: 1)),
    );
  }

  bool _isCurrentPrayer(
    PrayerTime prayer,
    PrayerDayTimes times,
  ) {
    final current = _getCurrentPeriod(times);
    return current.name == prayer.name;
  }

  IconData _iconForPrayer(String name) {
    switch (name) {
      case 'ফজর':
        return Icons.wb_twilight;
      case 'যোহর':
        return Icons.wb_sunny;
      case 'আসর':
        return Icons.sunny;
      case 'মাগরিব':
        return Icons.wb_twilight;
      case 'এশা':
        return Icons.nightlight_round;
      default:
        return Icons.wb_sunny_outlined;
    }
  }

  Widget _currentNextCard(PrayerDayTimes times) {
    final current = _getCurrentPeriod(times);
    final next = _getNextPeriod(times);


    return Card(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0A8754),
              Color(0xFF087A3B),
            ],
          ),
        ),
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Expanded(
              child: _currentNextColumn(
                title: 'এখন',
                name: current.name,
                time: current.time,
                icon: _iconForPrayer(current.name),
                light: true,
              ),
            ),
            Container(
              width: 1,
              height: 95,
              color: Colors.white24,
            ),
            Expanded(
              child: _currentNextColumn(
                title: 'পরবর্তী',
                name: next.name,
                time: next.time,
                icon: _iconForPrayer(next.name),
                light: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _currentNextColumn({
    required String title,
    required String name,
    required DateTime time,
    required IconData icon,
    required bool light,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: light ? Colors.white : green,
          size: 27,
        ),
        const SizedBox(height: 5),
        Text(
          title,
          style: TextStyle(
            color: light ? Colors.white70 : Colors.grey,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          name,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: light ? Colors.white : Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          _formatTime(time),
          style: TextStyle(
            color: light ? Colors.white : green,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }


  Future<void> _selectDistrict() async {
    String division = _selectedDivision;
    String district = _selectedDistrict;

    final result = await showModalBottomSheet<BangladeshLocation>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final districts =
                BangladeshLocations.districtsOf(division);

            if (!districts.contains(district)) {
              district = districts.first;
            }

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'নামাজের অবস্থান নির্বাচন',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: division,
                      decoration: InputDecoration(
                        labelText: 'বিভাগ',
                        prefixIcon: const Icon(Icons.map_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: BangladeshLocations.divisions
                          .map(
                            (item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text('$item বিভাগ'),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) return;

                        setModalState(() {
                          division = value;
                          district =
                              BangladeshLocations.districtsOf(value).first;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: district,
                      decoration: InputDecoration(
                        labelText: 'জেলা',
                        prefixIcon:
                            const Icon(Icons.location_city_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: districts
                          .map(
                            (item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(item),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) return;

                        setModalState(() {
                          district = value;
                        });
                      },
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          final location =
                              BangladeshLocations.find(
                            division,
                            district,
                          );

                          if (location != null) {
                            Navigator.pop(context, location);
                          }
                        },
                        icon: const Icon(Icons.check),
                        label: const Text('এই অবস্থান ব্যবহার করুন'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (result == null || !mounted) return;

    await _controller.saveLocation(result);

    setState(() {
      _selectedDivision = result.division;
      _selectedDistrict = result.district;
      _usingGps = false;
      _loadPrayerTimes();
    });

    await _prayerTimesFuture;

    await NotificationService.instance
        .schedulePrayerNotifications(
      days: 7,
      useGps: false,
    );
  }

  Future<void> _useCurrentLocation() async {
    setState(() {
      _usingGps = true;
      _loadPrayerTimes();
    });

    try {
      await _prayerTimesFuture;

      await NotificationService.instance
          .schedulePrayerNotifications(
        days: 7,
        useGps: true,
      );
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _usingGps = false;
        _loadPrayerTimes();
      });
    }
  }

  Widget _locationSelector() {
    return Card(
      margin: const EdgeInsets.fromLTRB(12, 4, 12, 10),
      elevation: 1.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: green,
                  size: 22,
                ),
                SizedBox(width: 8),
                Text(
                  'নামাজের অবস্থান',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _selectDistrict,
                    icon: const Icon(Icons.map_outlined, size: 19),
                    label: Text(
                      '$_selectedDivision\n$_selectedDistrict',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _useCurrentLocation,
                    icon: const Icon(
                      Icons.my_location,
                      size: 19,
                    ),
                    label: const Text(
                      'বর্তমান\nঅবস্থান',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _usingGps
                  ? 'বর্তমান GPS অবস্থান ব্যবহার করা হচ্ছে'
                  : 'নির্বাচিত জেলার অবস্থান ব্যবহার করা হচ্ছে',
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _locationCard(PrayerDayTimes times) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 4, 12, 10),
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 11,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5EE),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.location_on,
            color: green,
            size: 22,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'অবস্থান: ${times.location}',
              style: const TextStyle(
                color: green,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _prayerCard(
    PrayerTime prayer,
    PrayerDayTimes times,
  ) {
    final active = _isCurrentPrayer(prayer, times);

    return Card(
      margin: const EdgeInsets.fromLTRB(12, 5, 12, 5),
      elevation: active ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: active ? gold : Colors.transparent,
          width: active ? 1.5 : 0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 13,
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 23,
              backgroundColor:
                  active ? green : const Color(0xFFE8F5EE),
              child: Icon(
                _iconForPrayer(prayer.name),
                color: active ? Colors.white : green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        prayer.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (active) ...[
                        const SizedBox(width: 7),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: gold,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'চলছে',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'শুরু ${_formatTime(prayer.time)}',
                    style: TextStyle(
                      color: active ? green : Colors.grey.shade700,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  'শেষ',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _formatTime(prayer.endTime),
                  style: const TextStyle(
                    color: green,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _sunCard(PrayerDayTimes times) {
    return Card(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            const Icon(
              Icons.wb_sunny_outlined,
              color: gold,
              size: 30,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'সূর্যোদয়',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _formatTime(times.sunrise),
                    style: const TextStyle(
                      color: green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  'সূর্যাস্ত',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _formatTime(times.sunset),
                  style: const TextStyle(
                    color: green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _forbiddenSection(PrayerDayTimes times) {
    return Card(
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 20),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 15, 14, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.red,
                  size: 25,
                ),
                SizedBox(width: 8),
                Text(
                  'নিষিদ্ধ ওয়াক্ত',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              'নামাজের নিষিদ্ধ সময়গুলো আলাদাভাবে দেখানো হয়েছে।',
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            ...times.forbiddenTimes.map(
              (item) => _forbiddenItem(item),
            ),
          ],
        ),
      ),
    );
  }

  Widget _forbiddenItem(ForbiddenPrayerTime item) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4F4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.red.shade100,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.block,
            color: Colors.red.shade700,
            size: 21,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    color: Colors.red.shade800,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_formatTime(item.start)} — ${_formatTime(item.end)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  item.description,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 23,
            decoration: BoxDecoration(
              color: gold,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('নামাজের সময়'),
        centerTitle: true,
        backgroundColor: green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _refresh,
            icon: const Icon(Icons.refresh),
            tooltip: 'সময় আপডেট করুন',
          ),
        ],
      ),
      body: FutureBuilder<PrayerDayTimes>(
        future: _prayerTimesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: green,
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'নামাজের সময় পাওয়া যায়নি',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton.icon(
                      onPressed: _refresh,
                      icon: const Icon(Icons.refresh),
                      label: const Text('আবার চেষ্টা করুন'),
                    ),
                  ],
                ),
              ),
            );
          }

          final times = snapshot.data;

          if (times == null) {
            return const Center(
              child: Text('নামাজের সময় পাওয়া যায়নি'),
            );
          }

          if (_loadingLocation) {
            return const Center(
              child: CircularProgressIndicator(
                color: green,
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            color: green,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 10),
              children: [
                _currentNextCard(times),
                _locationSelector(),
                _locationCard(times),
                _sectionTitle('৫ ওয়াক্ত নামাজ'),
                _prayerCard(times.fajr, times),
                _prayerCard(times.dhuhr, times),
                _prayerCard(times.asr, times),
                _prayerCard(times.maghrib, times),
                _prayerCard(times.isha, times),
                _sunCard(times),
                _sectionTitle('নিষিদ্ধ ওয়াক্ত'),
                _forbiddenSection(times),
              ],
            ),
          );
        },
      ),
    );
  }
}
