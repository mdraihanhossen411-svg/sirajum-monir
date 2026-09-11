class HomeFeature {
  final String title;
  final String icon;
  final String route;

  const HomeFeature({
    required this.title,
    required this.icon,
    required this.route,
  });
}

const List<HomeFeature> homeFeatures = [
  HomeFeature(
    title: "কুরআন",
    icon: "assets/icons/quran.png",
    route: "/quran",
  ),
  HomeFeature(
    title: "হাদিস",
    icon: "assets/icons/hadith.png",
    route: "/hadith",
  ),
  HomeFeature(
    title: "দোয়া",
    icon: "assets/icons/dua.png",
    route: "/dua",
  ),
  HomeFeature(
    title: "তাসবিহ",
    icon: "assets/icons/tasbih.png",
    route: "/tasbih",
  ),
  HomeFeature(
    title: "নামাজ",
    icon: "assets/icons/prayer.png",
    route: "/prayer",
  ),
  HomeFeature(
    title: "কিবলা",
    icon: "assets/icons/qibla.png",
    route: "/qibla",
  ),
  HomeFeature(
    title: "হিজরি",
    icon: "assets/icons/hijri.png",
    route: "/hijri",
  ),
  HomeFeature(
    title: "সেটিংস",
    icon: "assets/icons/settings.png",
    route: "/settings",
  ),
];