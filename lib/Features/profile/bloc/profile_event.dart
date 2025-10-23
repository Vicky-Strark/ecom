part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();
}


class LoadProfileEvent extends ProfileEvent {
  final int userId;

  const LoadProfileEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}