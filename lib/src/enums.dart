enum PlaybackStatus {
  playing,
  paused,
  stopped;

  @override
  String toString() {
    return {
      PlaybackStatus.playing: "Playing",
      PlaybackStatus.paused: "Paused",
      PlaybackStatus.stopped: "Stopped",
    }[this]!;
  }
}

enum LoopStatus {
  none,
  track,
  playlist;

  factory LoopStatus.fromString(String status) {
    switch (status) {
      case "Track":
        return LoopStatus.track;
      case "Playlist":
        return LoopStatus.playlist;
      default:
        return LoopStatus.none;
    }
  }

  @override
  String toString() {
    return {
      LoopStatus.none: "None",
      LoopStatus.track: "Track",
      LoopStatus.playlist: "Playlist",
    }[this]!;
  }
}
