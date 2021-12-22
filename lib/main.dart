import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:stronger/provider/auth_provider.dart';
import 'package:stronger/provider/calender_provider.dart';
import 'package:stronger/provider/library_provider.dart';
import 'package:stronger/provider/schedule_provider.dart';
import 'package:stronger/provider/user_provider.dart';
import 'package:stronger/views/auth/sign_up_view.dart';
import 'package:stronger/views/setting/category_edit_view.dart';
import 'package:stronger/views/setting/tool_edit_view.dart';
import 'package:stronger/views/stronger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // initializeDateFormatting().then((_) => runApp(const MyApp()));

  initializeDateFormatting().then((_) => runApp(const MyApp()));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (BuildContext context) => AuthProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => LibraryProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => CalendarProvider()),
        ChangeNotifierProvider(create: (context) => ScheduleProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Do_Hyeon',
          scaffoldBackgroundColor: Colors.white,
        ),
        initialRoute: Stronger.routeName,
        routes: {
          Stronger.routeName: (context) {
            return const Stronger();
          },
          ToolEditView.routeName: (context) {
            return const ToolEditView();
          },
          CategoryEditView.routeName: (context) {
            return const CategoryEditView();
          },
          SignUpView.routeName: (context) {
            return const SignUpView();
          }
        },
      ),
    );
  }
}
