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
  final _formKey = GlobalKey<FormState>();
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
      body: Form(
        key: _formKey,
        child: Center(
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
                      validator: (value) {
                        print(_authProvider.signInAlarm);
                        if (_authProvider.signInAlarm.isNotEmpty) {
                          return _authProvider.signInAlarm;
                        } else if (value!.isEmpty) {
                          return '???????????? ???????????????';
                        }
                      },
                      maxLines: 1,
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: '?????????',
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
                      validator: (value) {
                        print(_authProvider.signInAlarm);
                        if (_authProvider.signInAlarm.isNotEmpty) {
                          return _authProvider.passwordAlarm;
                        } else if (value!.isEmpty) {
                          return '??????????????? ???????????????';
                        }
                      },
                      maxLines: 1,
                      keyboardType: TextInputType.visiblePassword,
                      autocorrect: false,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: '????????????',
                      ),
                      controller: _passwordController,
                      onSaved: (value) =>
                          _passwordController.text = value!.trim(),
                    ),
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  GestureDetector(
                    onTap: () async {
                      //userProvider??? ?????? ????????????????????? ?????? ????????????. async await
                      await _authProvider.signIn(
                        _emailController.text,
                        _passwordController.text,
                      );
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                      }
                    },
                    child: const CommonCard(
                      // width: width * 0.8,
                      // padding: EdgeInsets.symmetric(vertical: 20.0),
                      cardColor: Colors.black,
                      child: Center(
                        child: Text(
                          '?????????',
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
                      '??????????????? ????????? ????????????????',
                    ),
                  ),
                  const SizedBox(
                    height: 82,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '?????? ????????? ????????????????',
                        style: TextStyle(
                          color: ColorsStronger.grey,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // _authProvider.signUp(
                          //   email: _emailController.text,
                          //   password: _passwordController.text,
                          //   name: '??????',
                          // );
                          Navigator.of(context).pushNamed('signup');
                        },
                        child: const Text(
                          ' ????????????',
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
      ),
    );
  }
}
