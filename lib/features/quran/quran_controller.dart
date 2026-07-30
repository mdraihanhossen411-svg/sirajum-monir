
import 'package:get/get.dart';

import 'quran_state.dart';

class QuranController extends GetxController {
  final Rx<QuranState> state = const QuranState().obs;

  @override
  void onInit() {
    super.onInit();
    loadQuran();
  }

  Future<void> loadQuran() async {
    state.value = state.value.copyWith(isLoading: true);

    await Future.delayed(const Duration(milliseconds: 800));

    state.value = state.value.copyWith(isLoading: false);
  }
}
