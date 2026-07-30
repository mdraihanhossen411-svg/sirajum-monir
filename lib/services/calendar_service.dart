class CalendarService {
  Future<String> getHijriDate() async {
    return "1 Muharram 1448 AH";
  }

  Future<String> getGregorianDate() async {
    return "29 July 2026";
  }

  Future<List<String>> getIslamicEvents() async {
    return [
      "Ramadan",
      "Eid-ul-Fitr",
      "Eid-ul-Adha",
      "Ashura",
      "Mawlid-un-Nabi",
    ];
  }

  Future<void> refreshCalendar() async {
    // Calendar data will be updated here.
  }
}
