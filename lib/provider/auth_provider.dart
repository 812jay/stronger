import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stronger/models/user_model.dart';
import 'package:stronger/provider/easy_notifier.dart';
import 'package:stronger/service/auth_service.dart';

class AuthProvider extends EasyNotifier {
  final authService = AuthService();
  final firebaseAuth = FirebaseAuth.instance;

  String? get uid => firebaseAuth.currentUser?.uid;

  String _signInAlarm = '';
  String get signInAlarm => _emailAlarm;

  String _emailAlarm = '';
  String get emailAlarm => _emailAlarm;

  String _passwordAlarm = '';
  String get passwordAlarm => _passwordAlarm;

  Future<void> signIn(String email, String password) async {
    log('email: $email, password: $password');
    notify(() {
      _signInAlarm = '';
    });
    try {
      authService.signIn(email, password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        log('invalid-email');
        notify(() {
          _signInAlarm = '해당 이메일이나 비밀번호가 일치하지 않습니다.';
        });
      } else if (e.code == 'user-not-found') {
        notify(() {
          _signInAlarm = '해당 이메일이나 비밀번호가 일치하지 않습니다.';
        });
        log('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        notify(() {
          _signInAlarm = '해당 이메일이나 비밀번호가 일치하지 않습니다.';
        });
        log('Wrong password provided for that user.');
      }
      log(e.code);
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      notify(() {
        _emailAlarm = '';
        _passwordAlarm = '';
      });
      UserCredential userCredential = await authService.signUp(email, password);

      if (userCredential.user != null) {
        final user = userCredential.user!;

        final String uid = user.uid;
        final String email = user.email!;

        final userModel = UserModel(
          emailAddress: email,
          name: name,
          uid: uid,
          profileImage: '',
          categories: const ['가슴', '코어', '등', '어깨', '팔', '하체'],
          tools: const ['바벨', '덤벨', '케틀벨', '맨몸', '기타'],
        );

        await authService.registerUser(userModel);
      }
      await FirebaseAuth.instance.signOut();
      log('success signup');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        log('The account already exists for that email.');
        notify(() {
          _emailAlarm = '이미 존재하는 이메일 입니다';
        });
      } else if (e.code == 'weak-password') {
        log('The password provided is too weak.');
        notify(() {
          _passwordAlarm = '비밀번호 보안성이 취약합니다';
        });
      }
    } catch (e) {
      log('$e');
    }
  }

  // Future<bool> validationCheck(
  //   String name,
  //   String email,
  //   String password,
  //   String confirmPassword,
  // ) async {
  //   bool result = false;
  //   try {
  //     notify(() {
  //       _nameAlarm = '';
  //       _emailAlarm = '';
  //       _passwordAlarm = '';
  //       _confirmPasswordAlarm = '';
  //       if (name == '') {
  //         _nameAlarm = '이름을 입력해주세요';
  //       } else if (name.length > 8) {
  //         _nameAlarm = '이름을 8글자 아래로 적어주세요';
  //       }

  //       if (email == '') {
  //         _emailAlarm = 'email을 입력해주세요';
  //       } else if (!email.contains('@')) {
  //         _emailAlarm = '@를 입력해주세요';
  //       } else if (!email.contains('.')) {
  //         _emailAlarm = '.을 입력해주세요';
  //       }

  //       // if (password == '') {
  //       //   _passwordAlarm = '비밀번호를 입력해주세요';
  //       // } else if (name.length < 6) {
  //       //   _passwordAlarm = '비밀번호를 6글자 이상 적어주세요';
  //       // }

  //       if (confirmPassword == '') {
  //         _confirmPasswordAlarm = '비밀번호 확인을 적어주세요';
  //       } else if (confirmPassword != password) {
  //         _confirmPasswordAlarm = '비밀번호와 일치하지 않습니다';
  //       }
  //     });
  //     result = true;
  //   } catch (e) {
  //     print(e);
  //   }

  //   return result;
  // }
}
