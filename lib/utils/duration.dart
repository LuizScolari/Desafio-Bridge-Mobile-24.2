String durationToTimestamp(Duration? duration) {
  if (duration == null) {
    return '-:--';
  }

  return '${(duration.inSeconds / 60).floor()}:${(duration.inSeconds % 60).floor().toString().padLeft(2, '0')}';
}
