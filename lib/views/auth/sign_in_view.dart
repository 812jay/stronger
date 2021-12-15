import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stronger/provider/auth_provider.dart';

class SignInView extends StatelessWidget {
  static const routeName = '/signin';
  SignInView({Key? key}) : super(key: key);
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late AuthProvider _authProvider;

  @override
  Widget build(BuildContext context) {
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                maxLines: 1,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                decoration: InputDecoration(
                  hintText: 'email',
                ),
                controller: _emailController,
                onSaved: (value) => _emailController.text = value!.trim(),
              ),
              TextFormField(
                style: TextStyle(fontFamily: ''),
                maxLines: 1,
                keyboardType: TextInputType.visiblePassword,
                autocorrect: false,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'password',
                ),
                controller: _passwordController,
                onSaved: (value) => _passwordController.text = value!.trim(),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: ElevatedButton(
                  onPressed: () {
                    _authProvider.signIn(
                        _emailController.text, _passwordController.text);
                  },
                  child: Text('sign in'),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: ElevatedButton(
                  onPressed: () {
                    _authProvider.signUp(
                      email: _emailController.text,
                      password: _passwordController.text,
                      name: '이름',
                    );
                  },
                  child: Text('sign up'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
