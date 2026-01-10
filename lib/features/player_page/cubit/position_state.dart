part of 'position_cubit.dart';

class PositionState {
  final double position;

  const PositionState({required this.position});

  factory PositionState.initial() => const PositionState(position: 0.0);
}
