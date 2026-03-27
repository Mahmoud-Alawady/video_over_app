import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/transcript.dart';
import '../repository/transcript_repository.dart';

abstract class TranscriptState {}

class TranscriptInitial extends TranscriptState {}

class TranscriptLoading extends TranscriptState {}

class TranscriptLoaded extends TranscriptState {
  final Transcript transcript;
  TranscriptLoaded(this.transcript);
}

class TranscriptError extends TranscriptState {
  final String message;
  TranscriptError(this.message);
}

class TranscriptCubit extends Cubit<TranscriptState> {
  final TranscriptRepository _repository;

  TranscriptCubit(this._repository) : super(TranscriptInitial());

  Future<void> loadTranscript(String filename) async {
    emit(TranscriptLoading());
    try {
      final transcript = await _repository.getTranscript(filename);
      emit(TranscriptLoaded(transcript));
    } catch (e) {
      if (kDebugMode) print(e);
      emit(TranscriptError(e.toString()));
    }
  }
}
