import 'package:flutter/material.dart';
import 'package:video_over_app/core/di.dart';
import 'package:video_over_app/features/player_page/repository/starred_words_repository.dart';
import 'package:video_over_app/features/player_page/model/transcript.dart';

class TranslationPage extends StatefulWidget {
  final Sentence sentence;

  const TranslationPage({super.key, required this.sentence});

  @override
  State<TranslationPage> createState() => _TranslationPageState();
}

class _TranslationPageState extends State<TranslationPage> {
  final Set<String> _starredWords = {};

  void _toggleStar(String wordText, String meaning) async {
    final repository = getIt<StarredWordsRepository>();
    final isStarred = _starredWords.contains(wordText);

    setState(() {
      if (isStarred) {
        _starredWords.remove(wordText);
      } else {
        _starredWords.add(wordText);
      }
    });

    try {
      if (isStarred) {
        await repository.unstarWord(wordText);
      } else {
        await repository.starWord(wordText, meaning);
      }
    } catch (e) {
      // Revert state on error
      setState(() {
        if (isStarred) {
          _starredWords.add(wordText);
        } else {
          _starredWords.remove(wordText);
        }
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to update: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final wordsWithMeanings = widget.sentence.words
        .where((w) => w.meaning != null)
        .toList();

    return Scaffold(
      backgroundColor: Colors.black, // Matching the premium dark aesthetic
      appBar: AppBar(
        title: const Text(
          'Translation',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Original Text Card
              Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  // border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: SelectableText(
                  widget.sentence.text,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Translation Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.translate,
                      color: Theme.of(context).primaryColor,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Meaning',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Translation Text Card
              if (widget.sentence.meaning != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(20),
                    // border: Border.all(color: Colors.white.withOpacity(0.1)),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).shadowColor.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: SelectableText(
                    widget.sentence.meaning!,
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      height: 1.6,
                      color: Colors.white,
                    ),
                  ),
                )
              else
                const Center(
                  child: Text(
                    'No translation available',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ),

              if (wordsWithMeanings.isNotEmpty) ...[
                const SizedBox(height: 40),
                // New Words Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.auto_awesome,
                        color: Colors.orange,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'New Words',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.orange,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Words List
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: wordsWithMeanings.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final word = wordsWithMeanings[index];
                    final isStarred = _starredWords.contains(word.text);
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(16),
                        // border: Border.all(
                        //   color: Colors.white.withOpacity(0.05),
                        // ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  word.text,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  word.meaning!,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            iconSize: 20,
                            icon: Icon(
                              isStarred ? Icons.star : Icons.star_border,
                              color: isStarred ? Colors.amber : Colors.white38,
                            ),
                            onPressed: () =>
                                _toggleStar(word.text, word.meaning!),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
