import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/starred_word.dart';
import '../repository/starred_words_repository.dart';

abstract class StarredWordsState {}

class StarredWordsInitial extends StarredWordsState {}

class StarredWordsLoading extends StarredWordsState {}

class StarredWordsLoaded extends StarredWordsState {
  final List<StarredWord> words;
  StarredWordsLoaded(this.words);
}

class StarredWordsError extends StarredWordsState {
  final String message;
  StarredWordsError(this.message);
}

class StarredWordsCubit extends Cubit<StarredWordsState> {
  final StarredWordsRepository _repository;

  StarredWordsCubit(this._repository) : super(StarredWordsInitial());

  Future<void> fetchStarredWords() async {
    emit(StarredWordsLoading());
    try {
      final words = await _repository.getStarredWords();
      emit(StarredWordsLoaded(words));
    } catch (e) {
      emit(StarredWordsError(e.toString()));
    }
  }

  Future<void> unstarWord(String word) async {
    if (state is! StarredWordsLoaded) return;

    final currentWords = (state as StarredWordsLoaded).words;
    final updatedWords = currentWords.where((w) => w.word != word).toList();

    // Optimistic update
    emit(StarredWordsLoaded(updatedWords));

    try {
      await _repository.unstarWord(word);
    } catch (e) {
      // Revert on error
      emit(StarredWordsLoaded(currentWords));
      // You might want to emit a temporary error state here or use a side-effect channel
    }
  }
}
