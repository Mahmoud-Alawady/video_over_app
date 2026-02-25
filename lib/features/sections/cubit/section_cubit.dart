import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/section_repository.dart';
import '../models/section.dart';

part 'section_state.dart';

class SectionCubit extends Cubit<SectionState> {
  final SectionRepository _repository;

  SectionCubit(this._repository) : super(const SectionsInitial());

  Future<void> fetchSections() async {
    emit(const SectionsLoading());
    try {
      final sections = await _repository.fetchSections();
      emit(SectionsLoaded(sections));
    } catch (e) {
      emit(SectionsError(e.toString()));
    }
  }
}
