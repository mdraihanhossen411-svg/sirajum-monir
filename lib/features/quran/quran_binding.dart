class QuranState {
  final bool isLoading;

  const QuranState({
    this.isLoading = false,
  });

  QuranState copyWith({
    bool? isLoading,
  }) {
    return QuranState(
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
