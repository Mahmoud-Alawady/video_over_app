part of 'level_cubit.dart';

@immutable
abstract class LevelState {
  const LevelState();
}

class LevelsInitial extends LevelState {
  const LevelsInitial();
}

class LevelsLoading extends LevelState {
  const LevelsLoading();
}

class LevelsLoaded extends LevelState {
  final List<Level> levels;
  const LevelsLoaded(this.levels);
}

class LevelsError extends LevelState {
  final String message;
  const LevelsError(this.message);
}
