import 'package:equatable/equatable.dart';

class LocalUser extends Equatable {
  const LocalUser({
    required this.uid,
    required this.email,
    required this.points,
    required this.fullName,
    this.groupId = const [],
    this.enrollCourseIds = const [],
    this.following = const [],
    this.followers = const [],
    this.profilePic,
    this.bio,
  });

  const LocalUser.empty()
    : this(
        uid: '',
        email: '',
        points: 0,
        fullName: '',
        groupId: const [],
        enrollCourseIds: const [],
        following: const [],
        followers: const [],
        profilePic: '',
        bio: '',
      );

  final String uid;
  final String email;
  final String? profilePic;
  final String? bio;
  final int points;
  final String fullName;
  final List<String> groupId;
  final List<String> enrollCourseIds;
  final List<String> following;
  final List<String> followers;

  @override
  List<Object?> get props => [uid, email];

  @override
  String toString() {
    return 'LocalUser{uid: $uid, email: $email, bio: $bio, points: $points, '
        'fullName: $fullName}';
  }
}
