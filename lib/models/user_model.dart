import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String emailAddress;
  final String name;
  final String uid;
  final String profileImage;
  final List<String> categories;
  final List<String> tools;

  const UserModel({
    required this.emailAddress,
    required this.name,
    required this.uid,
    required this.profileImage,
    required this.categories,
    required this.tools,
  });

  UserModel copyWith({
    String? emailAddress,
    String? name,
    String? uid,
    String? profileImage,
    List<String>? categories,
    List<String>? tools,
  }) {
    return UserModel(
      emailAddress: emailAddress ?? this.emailAddress,
      name: name ?? this.name,
      uid: uid ?? this.uid,
      profileImage: profileImage ?? this.profileImage,
      categories: categories ?? this.categories,
      tools: tools ?? this.tools,
    );
  }

  factory UserModel.fromDocument(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return UserModel(
      emailAddress: data['emailAddress'],
      name: data['name'],
      uid: data['uid'],
      profileImage: data['profileImage'],
      categories: List.castFrom<dynamic, String>(data['categories']),
      tools: List.castFrom<dynamic, String>(data['tools']),
    );
  }

  factory UserModel.empty() {
    return const UserModel(
      emailAddress: '',
      name: '',
      uid: '',
      profileImage: '',
      categories: [],
      tools: [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'emailAddress': emailAddress,
      'name': name,
      'uid': uid,
      'profileImage': profileImage,
      'categories': categories,
      'tools': tools,
    };
  }

  @override
  List<Object?> get props => [
        emailAddress,
        name,
        uid,
        profileImage,
        categories,
        tools,
      ];
}
