class HomeState {
  final bool isLoading;
  final int currentIndex;

  const HomeState({
    this.isLoading = false,
    this.currentIndex = 0,
  });

  HomeState copyWith({
    bool? isLoading,
    int? currentIndex,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }
}
