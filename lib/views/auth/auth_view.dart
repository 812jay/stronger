import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stronger/provider/auth_provider.dart';
import 'package:stronger/utils/define.dart';
import 'package:stronger/widgets/common/common_card.dart';

class AuthView extends StatefulWidget {
  static const routeName = '/signin';
  const AuthView({Key? key}) : super(key: key);

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late AuthProvider _authProvider;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              height: height * 0.38,
              // width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/auth/main.jpg'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: height * 0.345,
                ),
                Image.asset(
                  'assets/splash/weightlifting.png',
                  height: 58.0,
                ),
                const Text('STRONGER'),
                const SizedBox(
                  height: 32,
                ),
                CommonCard(
                  child: TextFormField(
                    maxLines: 1,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'email',
                    ),
                    controller: _emailController,
                    onSaved: (value) => _emailController.text = value!.trim(),
                  ),
                ),
                const SizedBox(
                  height: 22,
                ),
                CommonCard(
                  child: TextFormField(
                    maxLines: 1,
                    keyboardType: TextInputType.visiblePassword,
                    autocorrect: false,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'password',
                    ),
                    controller: _passwordController,
                    onSaved: (value) =>
                        _passwordController.text = value!.trim(),
                  ),
                ),
                SizedBox(
                  height: 22,
                ),
                CommonCard(
                  // width: width * 0.8,
                  // padding: EdgeInsets.symmetric(vertical: 20.0),
                  cardColor: ColorsStronger.primaryBG,
                  child: GestureDetector(
                    onTap: () {
                      //userProvider가 먼저 실행되지않도록 설정 걸어두자. async await

                      _authProvider.signIn(
                        _emailController.text,
                        _passwordController.text,
                      );
                    },
                    child: const Center(
                      child: Text(
                        '로그인',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 22,
                ),
                GestureDetector(
                  onTap: () {},
                  child: const Text(
                    '비밀번호가 기억이 안나시나요?',
                  ),
                ),
                const SizedBox(
                  height: 82,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '아직 회원이 아니신가요?',
                      style: TextStyle(
                        color: ColorsStronger.grey,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _authProvider.signUp(
                          email: _emailController.text,
                          password: _passwordController.text,
                          name: '이름',
                        );
                      },
                      child: const Text(
                        ' 회원가입',
                        style: TextStyle(fontSize: 22),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
