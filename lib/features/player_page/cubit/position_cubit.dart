import 'package:flutter_bloc/flutter_bloc.dart';

class PositionCubit extends Cubit<int> {
  PositionCubit() : super(0);

  void emitNewPosition(Duration p) => emit(p.inMilliseconds);
}
