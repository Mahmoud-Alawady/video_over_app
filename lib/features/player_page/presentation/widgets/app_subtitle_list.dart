// import 'package:flutter/material.dart';
// import 'package:video_over_app/model/subtitle_model.dart';

// class AppSubtitleList extends StatefulWidget {
//   final List<SubtitleModel> subtitles;
//   final Duration currentPosition;
//   final void Function(SubtitleModel subtitle) onSubtitleTap;

//   const AppSubtitleList({
//     super.key,
//     required this.subtitles,
//     required this.currentPosition,
//     required this.onSubtitleTap,
//   });

//   @override
//   State<AppSubtitleList> createState() => _AppSubtitleListState();
// }

// class _AppSubtitleListState extends State<AppSubtitleList> {
//   final ScrollController _scrollController = ScrollController();
//   final Map<int, GlobalKey> _itemKeys = {};

//   int _currentIndex = 0;

//   @override
//   void initState() {
//     super.initState();

//     // Pre-generate keys for items
//     for (var i = 0; i < 5000; i++) {
//       _itemKeys[i] = GlobalKey();
//     }
//   }

//   @override
//   void didUpdateWidget(covariant AppSubtitleList oldWidget) {
//     super.didUpdateWidget(oldWidget);

//     int newIndex = 0;
//     for (int i = 0; i < widget.subtitles.length; i++) {
//       if (widget.currentPosition >= widget.subtitles[i].start) {
//         newIndex = i;
//       } else {
//         break;
//       }
//     }

//     if (newIndex != _currentIndex) {
//       _currentIndex = newIndex;

//       // After the frame is built → scroll new current subtitle to TOP
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         _scrollCurrentToTop();
//       });
//     }
//   }

//   void _scrollCurrentToTop() {
//     final ctx = _itemKeys[_currentIndex]?.currentContext;
//     if (ctx == null || !_scrollController.hasClients) return;

//     Scrollable.ensureVisible(
//       ctx,
//       duration: const Duration(milliseconds: 300),
//       curve: Curves.easeOut,
//       alignment: 0.0, // put at TOP
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       controller: _scrollController,
//       itemCount: widget.subtitles.length,
//       itemBuilder: (context, index) {
//         final subtitle = widget.subtitles[index];
//         final isCurrent = index == _currentIndex;

//         return GestureDetector(
//           key: _itemKeys[index],
//           onTap: () => widget.onSubtitleTap(subtitle),
//           child: AnimatedContainer(
//             duration: const Duration(milliseconds: 250),
//             padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//             child: AnimatedDefaultTextStyle(
//               duration: const Duration(milliseconds: 250),
//               style: TextStyle(
//                 fontSize: isCurrent ? 20 : 18,
//                 fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
//                 color: isCurrent ? Colors.white : Colors.grey[300],
//               ),
//               child: Text(subtitle.text),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
