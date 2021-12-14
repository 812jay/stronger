import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stronger/provider/library_provider.dart';
import 'package:stronger/views/setting/setting_view.dart';
import 'package:stronger/views/workouts_calendar/workouts_calendar.dart';
import 'package:stronger/views/workouts_library/library_view.dart';

const List<Map<String, dynamic>> itemList = [
  {
    'text': '캘린더',
    'icon': CupertinoIcons.calendar,
    'currentIndex': 0,
  },
  {
    'text': '운동 목록',
    'icon': CupertinoIcons.airplane,
    'currentIndex': 1,
  },
  {
    'text': '프로필',
    'icon': CupertinoIcons.airplane,
    'currentIndex': 2,
  },
];

class Home extends StatefulWidget {
  static const routeName = '/home';
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _navigators,
      ),
      bottomNavigationBar: Container(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              offset: Offset(4, 4),
              blurRadius: 4,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: itemList.map((item) {
            return GestureDetector(
              onTap: () {
                final int currentIndex = item['currentIndex'];
                setState(() {
                  if (_selectedIndex != currentIndex) {
                    _selectedIndex = currentIndex;
                  } else {
                    final GlobalKey<NavigatorState> state =
                        _navigators[currentIndex].key
                            as GlobalKey<NavigatorState>;

                    state.currentState!.popUntil((route) => route.isFirst);
                  }
                });
              },
              child: Container(
                width: 75,
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Icon(
                        item['icon'],
                        color: _selectedIndex == item['currentIndex']
                            ? Colors.black
                            : Colors.grey,
                      ),
                    ),
                    Text(
                      item['text'],
                      style: TextStyle(
                        fontSize: 11,
                        color: _selectedIndex == item['currentIndex']
                            ? Colors.black
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  final List<Navigator> _navigators = [
    Navigator(
      key: GlobalKey<NavigatorState>(),
      initialRoute: WorkoutsCalendar.routeName,
      onGenerateRoute: (settings) {
        WidgetBuilder builder;

        switch (settings.name) {
          case WorkoutsCalendar.routeName:
            builder = (_) => const WorkoutsCalendar();
            break;

          default:
            throw Exception('[CALENDER] Invalid route name: ${settings.name}');
        }
        return MaterialPageRoute(builder: builder, settings: settings);
      },
    ),
    Navigator(
      key: GlobalKey<NavigatorState>(),
      initialRoute: LibraryView.routeName,
      onGenerateRoute: (settings) {
        WidgetBuilder builder;

        switch (settings.name) {
          case LibraryView.routeName:
            builder = (_) => const LibraryView();
            break;

          default:
            throw Exception('[LIBRARY] Invalid route name: ${settings.name}');
        }
        return MaterialPageRoute(builder: builder, settings: settings);
      },
    ),
    Navigator(
      key: GlobalKey<NavigatorState>(),
      initialRoute: SettingView.routeName,
      onGenerateRoute: (settings) {
        WidgetBuilder builder;

        switch (settings.name) {
          case SettingView.routeName:
            builder = (_) => const SettingView();
            break;

          default:
            throw Exception('[PLAN] Invalid route name: ${settings.name}');
        }
        return MaterialPageRoute(builder: builder, settings: settings);
      },
    ),
  ];
}
