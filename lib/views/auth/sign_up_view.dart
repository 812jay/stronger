import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stronger/provider/auth_provider.dart';
import 'package:stronger/utils/define.dart';
import 'package:stronger/widgets/common/common_card.dart';

class SignUpView extends StatefulWidget {
  static const routeName = 'signup';
  const SignUpView({Key? key}) : super(key: key);

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  late AuthProvider _authProvider;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController(); // 포커스노트 선언

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '회원가입',
          style: TextStyle(fontSize: 32.0),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 32,
                ),
                Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      width: 100.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                        // color: ColorsStronger.lightGrey,
                        image: const DecorationImage(
                            image: AssetImage('assets/auth/pony.jpeg'),
                            fit: BoxFit.cover),
                        border: Border.all(width: 5.0),
                        borderRadius: BorderRadius.circular(60.0),
                      ),

                      // child: Image.asset('assets/auth/main.jpg'),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(60.0),
                        ),
                        height: 40.0,
                        child: Image.asset(
                          'assets/icons/pen.png',
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 52,
                ),
                CommonCard(
                  child: TextFormField(
                    validator: (name) {
                      if (name!.isEmpty) {
                        return '이름을 입력하세요.';
                      } else if (name.length > 8) {
                        return '이름을 8글자 아래로 적어주세요';
                      }
                      return null;
                    },
                    autofocus: true,
                    textCapitalization: TextCapitalization.words,
                    maxLines: 1,
                    keyboardType: TextInputType.name,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '이름',
                    ),
                    controller: _nameController,
                    onSaved: (value) => _nameController.text = value!.trim(),
                  ),
                ), //이름 입력칸
                const SizedBox(
                  height: 32,
                ),
                CommonCard(
                  child: TextFormField(
                    validator: (email) {
                      print(_authProvider.emailAlarm);
                      if (_authProvider.emailAlarm != '') {
                        return _authProvider.emailAlarm;
                      } else if (email!.isEmpty) {
                        return '이메일을 입력하세요.';
                      } else if (!email.contains('@')) {
                        return '@를 입력해주세요';
                      } else if (!email.contains('.')) {
                        return '.을 입력해주세요';
                      }
                      return null;
                    },
                    maxLines: 1,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '이메일',
                    ),
                    controller: _emailController,
                    onSaved: (value) => _emailController.text = value!.trim(),
                  ),
                ), // 이메일 입력칸
                const SizedBox(
                  height: 32,
                ),
                CommonCard(
                  child: TextFormField(
                    validator: (password) {
                      if (_authProvider.passwordAlarm != '') {
                        return _authProvider.passwordAlarm;
                      } else if (password!.isEmpty) {
                        return '비밀번호를 입력하세요.';
                      }
                      return null;
                    },
                    maxLines: 1,
                    keyboardType: TextInputType.visiblePassword,
                    autocorrect: false,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '비밀번호',
                    ),
                    controller: _passwordController,
                    onSaved: (value) =>
                        _passwordController.text = value!.trim(),
                  ),
                ), //비밀번호 입력칸
                const SizedBox(
                  height: 32,
                ),
                CommonCard(
                  child: TextFormField(
                    validator: (passwordConfirm) {
                      if (passwordConfirm!.isEmpty) {
                        return '비밀번호 확인을 입력하세요.';
                      } else if (passwordConfirm != _passwordController.text) {
                        return '비밀번호가 일치하지 않습니다.';
                      }
                      return null;
                    },
                    maxLines: 1,
                    keyboardType: TextInputType.visiblePassword,
                    autocorrect: false,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '비밀번호 확인',
                    ),
                    controller: _passwordConfirmController,
                    onSaved: (value) =>
                        _passwordConfirmController.text = value!.trim(),
                  ),
                ), //비밀번호 확인 입력칸
                const SizedBox(
                  height: 100,
                ),
                GestureDetector(
                  onTap: () async {
                    await _authProvider.signUp(
                      name: _nameController.text,
                      email: _emailController.text,
                      password: _passwordController.text,
                    );
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      Navigator.of(context).popAndPushNamed('stronger');
                    }
                  },
                  child: const CommonCard(
                    // width: width * 0.8,
                    // padding: EdgeInsets.symmetric(vertical: 20.0),
                    cardColor: Colors.black,
                    child: Center(
                      child: Text(
                        '회원가입',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
