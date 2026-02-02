class ArrayPlaybackState {
  final int index;
  final bool playing;

  const ArrayPlaybackState({this.index = 0, this.playing = false});

  ArrayPlaybackState copyWith({int? index, bool? playing}) {
    return ArrayPlaybackState(
      index: index ?? this.index,
      playing: playing ?? this.playing,
    );
  }

  static const empty = ArrayPlaybackState();
}
