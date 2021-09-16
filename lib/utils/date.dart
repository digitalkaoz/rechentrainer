String formatDuration(Duration duration) {
  duration.toString();
  return [duration.inMinutes.remainder(60), duration.inSeconds.remainder(60)]
      .map((seg) {
    return seg.toString().padLeft(2, '0');
  }).join(':');
}
