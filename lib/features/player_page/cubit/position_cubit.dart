import 'package:flutter_bloc/flutter_bloc.dart';

part 'position_state.dart';

class PositionCubit extends Cubit<PositionState> {
  PositionCubit() : super(PositionState.initial());

  void emitNewPosition(Duration p) {
    emit(PositionState(position: p.inMilliseconds / 1000));
  }
}
