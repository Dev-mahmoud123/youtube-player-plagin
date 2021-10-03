import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/snack_bar_widget.dart';
import 'package:video_player/text_widget.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class HomeScreen extends StatefulWidget {
 final  String ids;
  const HomeScreen({Key? key, required this.ids,})
      : super(key: key);


  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late YoutubePlayerController _controller;
  late TextEditingController _idController;

  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _isMuted = false;
  bool _isPlayerReady = false;

  final List<String> _ids = [
    'nPt8bK2gbaU',
    'gQDByCdjUXw',
    'iLnmTe5Q2Qw',
    '_WoCV4c6XOE',
    'KmzdUe0RSJo',
    '6jZDSSZZxjQ',
    'p2lYr3vM_1w',
    '7QUtEmBT_-w',
    '34_PXCzGw1M',
  ];

  void runYoutubePlayer() {
    final videoId = YoutubePlayer.convertUrlToId(widget.ids);
    _controller = YoutubePlayerController(
      initialVideoId: videoId.toString(),
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        isLive: false,
        enableCaption: true,
        mute: false,
        disableDragSeek: false,
        loop: false,
        forceHD: false,
      ),
    )..addListener(listener);
    _idController = TextEditingController();
    _playerState = PlayerState.unknown;
  }
  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  void initState() {
    runYoutubePlayer();
    super.initState();
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  // TODO :  Space between widgets
  Widget get _space => const SizedBox(height: 10);

  @override
  void dispose() {
    // Discards any resources used by the object,the object is not in a usable state
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      onExitFullScreen: () {
        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      },
      player: YoutubePlayer(
        controller: _controller,
        progressIndicatorColor: Colors.blueAccent,
        showVideoProgressIndicator: true,
        topActions: [
          Expanded(
            child: Text(
              _controller.metadata.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () {
              log('settings tabbed');
            },
          ),
        ],
        onReady: () {
          _isPlayerReady = true;
        },
        onEnded: (data) {
          _controller
              .load(_ids[(_ids.indexOf(data.videoId) + 1) % _ids.length]);
          showSnackBar(
            message: 'Next Video Started',
            context: context,
          );
        },
      ),
      builder: (context, player) {
        return Scaffold(
          appBar: AppBar(
            leading: Image.asset('assets/ypf.png'),
            title: const Text('Flutter Youtube Player'),
            actions: [
              IconButton(
                icon: const Icon(Icons.video_library),
                onPressed: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => const Scaffold(),
                    ),
                  );
                },
              )
            ],
          ),
          body: ListView(
            children: [
              player,
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _space,

                    /// Video title of the currently loaded video
                    text('Title: ', _controller.metadata.title),
                    _space,

                    /// Channel name or uploader of the currently loaded video
                    text('Channel: ', _controller.metadata.author),
                    _space,
                    Row(
                      children: [
                        //   Quality of video
                        text('Playback Quality: ',
                            _controller.value.playbackQuality ?? ''),
                        const Spacer(),
                        //  speed of playing video
                        text('Playback rate: ',
                            '${_controller.value.playbackRate}x'),
                        _space,
                      ],
                    ),
                    _space,
                    TextField(
                        enabled: _isPlayerReady,
                        controller: _idController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter youtube <video id> or <link>',
                          filled: true,
                          hintStyle: const TextStyle(
                            fontWeight: FontWeight.w300,
                            color: Colors.blueAccent,
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () => _idController.clear(),
                          ),
                        )),

                    /// TODO : Load Cue Buttons
                    _space,
                    Row(
                      children: [
                        _loadCueButton('LOAD'),
                        const SizedBox(width: 10.0),
                        _loadCueButton('CUE'),
                      ],
                    ),

                    /// TODO : Buttons Controllers
                    _space,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.skip_previous),
                          onPressed: () {
                            _isPlayerReady
                                ? _controller.load(_ids[(_ids.indexOf(
                                            _controller.metadata.videoId) -
                                        1) %
                                    _ids.length])
                                : null;
                          },
                        ),
                        IconButton(
                            icon: _controller.value.isPlaying
                                ? const Icon(Icons.play_arrow)
                                : const Icon(Icons.pause),
                            onPressed: _isPlayerReady
                                ? () {
                                    _controller.value.isPlaying
                                        ? _controller.pause()
                                        : _controller.play();

                                    setState(() {});
                                  }
                                : null),
                        IconButton(
                          icon: Icon(
                              _isMuted ? Icons.volume_off : Icons.volume_up),
                          onPressed: _isPlayerReady
                              ? () {
                                  _isMuted
                                      ? _controller.unMute()
                                      : _controller.mute();
                                  setState(() {
                                    _isMuted = !_isMuted;
                                  });
                                }
                              : null,
                        ),
                        IconButton(
                          icon: const Icon(Icons.skip_next),
                          onPressed: () {
                            _isPlayerReady
                                ? _controller.load(_ids[(_ids.indexOf(
                                            _controller.metadata.videoId) +
                                        1) %
                                    _ids.length])
                                : null;
                          },
                        ),
                        FullScreenButton(
                          controller: _controller,
                          color: Colors.blueAccent,
                        ),
                      ],
                    ),

                    /// TODO : Volume
                    _space,
                    Row(
                      children: [
                        const Text(
                          'Volume',
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        Expanded(
                          child: Slider(
                            value: _volume,
                            inactiveColor: Colors.transparent,
                            min: 0.0,
                            max: 100.0,
                            divisions: 10,
                            label: '${_volume.round()}',

                            /// Returns the integer closest to this number
                            onChanged: _isPlayerReady
                                ? (double value) {
                                    setState(() {
                                      _volume = value;
                                    });
                                    _controller.setVolume(_volume.round());
                                    if (_volume == 0) {
                                      _isMuted = true;
                                    } else {
                                      _isMuted = false;
                                    }
                                  }
                                : null,
                          ),
                        ),
                      ],
                    ),

                    _space,
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 800),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: _getStateColor(_playerState),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          _playerState.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // TODO : Load Cue  Button
  Widget _loadCueButton(String action) {
    return Expanded(
      child: MaterialButton(
        color: Colors.blueAccent,
        onPressed: _isPlayerReady
            ? () {
                if (_idController.text.isNotEmpty) {
                  var id = YoutubePlayer.convertUrlToId(
                        _idController.text,
                      ) ??
                      '';
                  if (action == 'LOAD') _controller.load(id);
                  if (action == 'CUE') _controller.cue(id);
                  FocusScope.of(context).requestFocus(FocusNode());
                } else {
                  showSnackBar(
                      message: 'Source can\'t be empty!', context: context);
                }
              }
            : null,
        disabledColor: Colors.grey,
        disabledTextColor: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          child: Text(
            action,
            style: const TextStyle(
              fontSize: 18.0,
              color: Colors.white,
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Color _getStateColor(PlayerState state) {
    switch (state) {
      case PlayerState.unknown:
        return Colors.grey[700]!;
      case PlayerState.unStarted:
        return Colors.pink;
      case PlayerState.ended:
        return Colors.red;
      case PlayerState.playing:
        return Colors.blueAccent;
      case PlayerState.paused:
        return Colors.orange;
      case PlayerState.buffering:
        return Colors.yellow;
      case PlayerState.cued:
        return Colors.blue[900]!;
      default:
        return Colors.blue;
    }
  }
}
