import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_over_app/features/player_page/model/transcript.dart';

class LoopCubit extends Cubit<Sentence?> {
  LoopCubit() : super(null);

  void toggleLoop(Sentence sentence) {
    if (state == sentence) {
      emit(null);
    } else {
      emit(sentence);
    }
  }

  void clearLoop() => emit(null);
}
