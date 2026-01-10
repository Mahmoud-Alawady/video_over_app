// import 'package:flutter/material.dart';
// import 'package:youtube_player_iframe/youtube_player_iframe.dart';

// class AppYoutubePlayer extends StatefulWidget {
//   final String url;
//   final 
//   final int? start;
//   final int? end;

//   const AppYoutubePlayer({super.key, required this.url, this.start, this.end});

//   @override
//   State<AppYoutubePlayer> createState() => _AppYoutubePlayerState();
// }

// class _AppYoutubePlayerState extends State<AppYoutubePlayer> {

//   @override
//   void initState() {
//     super.initState();

//     final videoId = YoutubePlayerController.convertUrlToId(widget.url)!;

//     _controller = YoutubePlayerController(
//       params: YoutubePlayerParams(
//         // startAt: widget.start,
//         // endAt: widget.end,
//         origin: 'https://www.youtube-nocookie.com',
//         showControls: true,
//         showFullscreenButton: false,
//         strictRelatedVideos: true,
//         showVideoAnnotations: true,
//       ),
//     )..loadVideoById(videoId: videoId);

//     YoutubePlayer(controller: _controller);
//   }


//   @override
//   Widget build(BuildContext context) {
//     return 

//     return Column(
//       children: [
//         // Youtube Player
//         AspectRatio(
//           aspectRatio: 16 / 9,
//           child: YoutubePlayer(controller: _controller),
//         ),

//         const SizedBox(height: 12),

//         // Custom Controls
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             IconButton(
//               icon: const Icon(Icons.replay_10),
//               onPressed: () async {
//                 final pos = await _controller.currentTime;
//                 _controller.seekTo(seconds: pos - 10);
//               },
//             ),
//             IconButton(
//               icon: const Icon(Icons.play_arrow),
//               onPressed: _controller.playVideo,
//             ),
//             IconButton(
//               icon: const Icon(Icons.pause),
//               onPressed: _controller.pauseVideo,
//             ),
//             IconButton(
//               icon: const Icon(Icons.forward_10),
//               onPressed: () async {
//                 final pos = await _controller.currentTime;
//                 _controller.seekTo(seconds: pos + 10);
//               },
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
