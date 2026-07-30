import 'package:get/get.dart';

import 'home_state.dart';

class HomeController extends GetxController {
  final Rx<HomeState> state = const HomeState().obs;

  @override
  void onInit() {
    super.onInit();
    loadHome();
  }

  void loadHome() async {
    state.value = state.value.copyWith(isLoading: true);

    await Future.delayed(const Duration(milliseconds: 800));

    state.value = state.value.copyWith(isLoading: false);
  }

  void changeBottomIndex(int index) {
    state.value = state.value.copyWith(
      currentIndex: index,
    );
  }
}
