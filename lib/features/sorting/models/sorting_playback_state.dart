class SortingPlaybackState {
  final int index;
  final bool playing;

  const SortingPlaybackState({this.index = 0, this.playing = false});

  SortingPlaybackState copyWith({int? index, bool? playing}) {
    return SortingPlaybackState(
      index: index ?? this.index,
      playing: playing ?? this.playing,
    );
  }

  static const empty = SortingPlaybackState();
}
