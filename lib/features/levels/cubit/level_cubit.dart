import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/level_repository.dart';
import '../models/level.dart';

part 'level_state.dart';

class LevelCubit extends Cubit<LevelState> {
  final LevelRepository _repository;

  LevelCubit(this._repository) : super(const LevelsInitial());

  Future<void> fetchLevels() async {
    emit(const LevelsLoading());
    try {
      final levels = await _repository.fetchLevels();
      emit(LevelsLoaded(levels));
    } catch (e) {
      emit(LevelsError(e.toString()));
    }
  }
}
