class Sound {
  final int id;
  String soundRoot;
  List<bool> playPause;
  double volume;

  Sound({
    required this.id,
    required this.soundRoot,
    required this.playPause,
    required this.volume
});
}
