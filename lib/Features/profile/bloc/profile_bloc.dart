import 'package:bloc/bloc.dart';
import 'package:ecom/Features/profile/model/profile_model.dart';
import 'package:ecom/Features/profile/repository/profile_repository.dart';
import 'package:equatable/equatable.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;

  ProfileBloc(this.profileRepository) : super(ProfileInitial()) {

    // Load Profile Event Handler
    on<LoadProfileEvent>((event, emit) async {
      emit(ProfileLoadingState());

      try {
        final profile = await profileRepository.fetchProfile(
          userId: event.userId,
        );
        emit(ProfileLoadedState(profileModel: profile));
      } catch (e) {
        emit(ProfileErrorState(erMsg: e.toString()));
      }
    });
  }
}