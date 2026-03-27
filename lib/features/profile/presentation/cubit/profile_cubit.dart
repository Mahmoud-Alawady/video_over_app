import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_over_app/features/auth/data/models/user_model.dart';
import 'package:video_over_app/features/profile/data/repositories/profile_repository.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserModel user;
  ProfileLoaded(this.user);
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}

class ProfileDeleted extends ProfileState {}

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _profileRepository;

  ProfileCubit(this._profileRepository) : super(ProfileInitial());

  Future<void> fetchProfile() async {
    emit(ProfileLoading());
    try {
      final user = await _profileRepository.getMe();
      emit(ProfileLoaded(user));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> deleteAccount() async {
    emit(ProfileLoading());
    try {
      await _profileRepository.deleteMe();
      emit(ProfileDeleted());
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
