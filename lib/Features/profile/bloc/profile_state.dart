part of 'profile_bloc.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();
}

final class ProfileInitial extends ProfileState {
  @override
  List<Object> get props => [];
}

class ProfileLoadingState extends ProfileState{
  @override
  // TODO: implement props
  List<Object?> get props => [];

}

class ProfileLoadedState extends ProfileState{

  ProfileModel? profileModel;
  ProfileLoadedState({this.profileModel});
  @override
  // TODO: implement props
  List<Object?> get props => [profileModel];

}

class ProfileErrorState extends ProfileState{

  String? erMsg;
  ProfileErrorState({this.erMsg});
  @override

  List<Object?> get props => [erMsg];

}