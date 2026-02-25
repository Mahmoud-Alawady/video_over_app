part of 'section_cubit.dart';

@immutable
abstract class SectionState {
  const SectionState();
}

class SectionsInitial extends SectionState {
  const SectionsInitial();
}

class SectionsLoading extends SectionState {
  const SectionsLoading();
}

class SectionsLoaded extends SectionState {
  final List<Section> sections;
  const SectionsLoaded(this.sections);
}

class SectionsError extends SectionState {
  final String message;
  const SectionsError(this.message);
}
