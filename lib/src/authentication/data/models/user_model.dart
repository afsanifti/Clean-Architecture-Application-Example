import 'package:clean_arch_examples/core/utils/typedefs.dart';
import 'package:clean_arch_examples/src/authentication/domain/entities/user.dart';

class LocalUserModel extends LocalUser {
  const LocalUserModel({
    required super.uid,
    required super.email,
    required super.points,
    required super.fullName,
    super.groupId,
    super.enrollCourseIds,
    super.following,
    super.followers,
    super.profilePic,
    super.bio,
  });

  const LocalUserModel.empty()
    : this(
        uid: '',
        email: '',
        points: 0,
        fullName: '',
        groupId: const [],
        enrollCourseIds: const [],
        following: const [],
        followers: const [],
      );

  LocalUserModel.fromMap(DataMap map)
    : this(
        uid: map['uid'] as String,
        email: map['email'] as String,
        points: (map['points'] as num).toInt(),
        fullName: map['fullName'] as String,
        profilePic: map['profilePic'] as String?,
        bio: map['bio'] as String?,
        // This is a way of casting
        groupId: (map['groupId'] as List<dynamic>).cast<String>(),
        // This is another way of casting
        enrollCourseIds: List<String>.from(
          map['enrollCourseIds'] as List<dynamic>,
        ),
        following: (map['following'] as List<dynamic>).cast<String>(),
        followers: (map['followers'] as List<dynamic>).cast<String>(),
      );

  LocalUserModel copyWith({
    String? uid,
    String? email,
    String? profilePic,
    String? bio,
    int? points,
    String? fullName,
    List<String>? groupId,
    List<String>? enrollCourseIds,
    List<String>? following,
    List<String>? followers,
  }) {
    return LocalUserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      profilePic: profilePic ?? this.profilePic,
      bio: bio ?? this.bio,
      points: points ?? this.points,
      fullName: fullName ?? this.fullName,
      groupId: groupId ?? this.groupId,
      enrollCourseIds: enrollCourseIds ?? this.enrollCourseIds,
      following: following ?? this.following,
      followers: followers ?? this.followers,
    );
  }

  DataMap toMap() => {
    'uid': uid,
    'email': email,
    'profilePic': profilePic,
    'bio': bio,
    'points': points,
    'fullName': fullName,
    'groupId': groupId,
    'enrollCourseIds': enrollCourseIds,
    'following': following,
    'followers': followers,
  };
}
