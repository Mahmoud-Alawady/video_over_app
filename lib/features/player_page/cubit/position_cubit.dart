import 'package:flutter_bloc/flutter_bloc.dart';

class PositionCubit extends Cubit<PositionState> {
  PositionCubit() : super(PositionState.initial());

  void emitNewPosition(Duration p) {
    emit(PositionState(position: p.inMilliseconds / 1000));
  }
}

class PositionState {
  final double position;

  const PositionState({required this.position});

  factory PositionState.initial() => const PositionState(position: 0.0);
}
