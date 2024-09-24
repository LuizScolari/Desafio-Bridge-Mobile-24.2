import 'dart:async';
import 'package:beat/models.dart';
import 'package:beat/utils/collections.dart';
import 'package:beat/utils/colors.dart';
import 'package:beat/utils/duration.dart';
import 'package:beat/widgets/beat_scaffold.dart';
import 'package:beat/widgets/favorite_button.dart';
import 'package:beat/widgets/image_gradient_background.dart';
import 'package:beat/widgets/track_menu.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

enum RepeatMode {
  none,
  repeat,
  repeatOne,
}

class PlayScreen extends StatefulWidget {
  final Track initialTrack;
  final List<Track> tracks;

  const PlayScreen({
    Key? key,
    required this.initialTrack,
    required this.tracks,
  }) : super(key: key);

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  final AudioPlayer audioPlayer = AudioPlayer();

  Duration? position;
  Duration? duration;

  RepeatMode repeat = RepeatMode.none;
  bool shuffle = false;

  late StreamSubscription<Duration> subPosition;
  late StreamSubscription<Duration> subDuration;
  late StreamSubscription<PlayerState> subState;

  late int currentIndex;
  late List<Track> tracks;

  Track get currentTrack => tracks[currentIndex];

  @override
  void initState() {
    super.initState();
    tracks = widget.tracks.toList();

    currentIndex = tracks.indexOf(widget.initialTrack);

    if (currentTrack.previewUrl != null) {
      audioPlayer.play(UrlSource(currentTrack.previewUrl!));
    }

    subPosition = audioPlayer.onPositionChanged.listen((Duration playerPosition) {
      if (mounted) setState(() => position = playerPosition);
    });
    subDuration = audioPlayer.onDurationChanged.listen((Duration playerDuration) {
      if (mounted) setState(() => duration = playerDuration);
    });
    subState = audioPlayer.onPlayerStateChanged.listen((PlayerState state) {});
    audioPlayer.onPlayerComplete.listen((_) {
      playNext();
    });
  }

  @override
  void dispose() {
    closePlayer();
    super.dispose();
  }

  Future<void> closePlayer() async {
    await subPosition.cancel();
    await subDuration.cancel();
    await subState.cancel();
    await audioPlayer.pause();
    await audioPlayer.stop();
    await Future.delayed(const Duration(seconds: 1));
    await audioPlayer.dispose();
  }

  Future<void> onPlayPressed() async {
    switch (audioPlayer.state) {
      case PlayerState.completed:
      case PlayerState.disposed:
        playNext();
        await audioPlayer.seek(Duration.zero);
        break;
      case PlayerState.stopped:
      case PlayerState.paused:
        await audioPlayer.resume();
        break;
      case PlayerState.playing:
        await audioPlayer.pause();
        break;
    }
  }

  void playNext() {
    final nextIndex = currentIndex + 1;
    switch (repeat) {
      case RepeatMode.none:
        if (nextIndex < tracks.length) {
          setState(() {
            currentIndex = nextIndex;
          });
          audioPlayer.play(UrlSource(currentTrack.previewUrl!));
        }
        break;
      case RepeatMode.repeat:
        setState(() {
          currentIndex = nextIndex == tracks.length ? 0 : nextIndex;
        });
        audioPlayer.play(UrlSource(currentTrack.previewUrl!));
        break;
      case RepeatMode.repeatOne:
        audioPlayer.play(UrlSource(currentTrack.previewUrl!));
        break;
    }
  }

  void playPrevious() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
      audioPlayer.play(UrlSource(currentTrack.previewUrl!));
    }
  }

  void toggleShuffle() {
    setState(() {
      shuffle = !shuffle;
    });
  }

  void toggleRepeat() {
    setState(() {
      repeat = cycleNext(repeat, RepeatMode.values);
    });
  }

  double get positionPercent {
    if (position == null || duration == null) {
      return 0.0;
    }
    return position!.inMilliseconds / duration!.inMilliseconds;
  }

  @override
  Widget build(BuildContext context) {
    return BeatScaffold(
      body: SingleChildScrollView(
        child: ImageGradientBackground(
          backgroundUrl: currentTrack.album.image ?? 'https://via.placeholder.com/300',
          foreground: buildControllers(),
        ),
      ),
    );
  }

  Widget buildControllers() {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    currentTrack.name,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    currentTrack.artistsNames,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            FavoriteButton(track: currentTrack),
            TrackMenu(track: currentTrack),
          ],
        ),
        const SizedBox(height: 28),
        Row(
          children: <Widget>[
            Text(
              durationToTimestamp(position ?? Duration.zero),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Text(
              durationToTimestamp(duration ?? Duration.zero),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Slider(
          value: positionPercent,
          onChanged: (value) async {
            await audioPlayer.seek(duration! * value);
            audioPlayer.resume();
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.shuffle),
              iconSize: 24,
              onPressed: toggleShuffle,
            ),
            IconButton(
              icon: const Icon(Icons.skip_previous),
              iconSize: 48,
              onPressed: playPrevious,
            ),
            StreamBuilder<PlayerState>(
              stream: audioPlayer.onPlayerStateChanged,
              builder: (context, snapshot) {
                return IconButton(
                  icon: Icon(
                    audioPlayer.state == PlayerState.playing ? Icons.pause_circle_filled : Icons.play_circle_filled,
                  ),
                  iconSize: 80,
                  onPressed: onPlayPressed,
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.skip_next),
              iconSize: 48,
              onPressed: playNext,
            ),
            IconButton(
              icon: buildRepeatIcon(),
              iconSize: 24,
              onPressed: toggleRepeat,
            ),
          ],
        ),
      ],
    );
  }

  Widget buildRepeatIcon() {
    switch (repeat) {
      case RepeatMode.none:
        return const Icon(Icons.repeat);
      case RepeatMode.repeat:
        return const Icon(Icons.repeat, color: BeatColors.blue);
      case RepeatMode.repeatOne:
        return const Icon(Icons.repeat_one, color: BeatColors.blue);
    }
  }
}
