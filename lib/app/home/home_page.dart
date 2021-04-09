import 'package:flutter/material.dart';
import 'package:login_screen/app/home/cupertino_home_scaffold.dart';
import 'package:login_screen/app/home/guests/guests_page.dart';
import 'package:login_screen/app/home/models/event.dart';
import 'package:login_screen/app/home/tab_item.dart';
import 'package:login_screen/screens/temp_home_page.dart';
import 'package:login_screen/services/database.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key, @required this.database, @required this.event}) : super(key: key);
  final Database database;
  final Event event;


  static Future<void> show(BuildContext context, Event event) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: false,
        builder: (context) => HomePage(database: database, event: event),
      ),
    );
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.guests;

  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.guests: GlobalKey<NavigatorState>(),
    TabItem.tasks: GlobalKey<NavigatorState>(),
    TabItem.budgets: GlobalKey<NavigatorState>(),
    TabItem.vendors: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, WidgetBuilder> get widgetBuilders {
    return {
      TabItem.guests: (_) => GuestsPage(database: widget.database, event: widget.event),
      TabItem.tasks: (_) => TempHomePage(),
      TabItem.budgets: (_) => TempHomePage(),
      TabItem.vendors: (_) => TempHomePage(),
    };
  }

  void _select(TabItem tabItem) {
    if (tabItem == _currentTab) {
      // pop to first route
      navigatorKeys[tabItem].currentState.popUntil((route) => route.isFirst);
    } else {
      setState(() => _currentTab = tabItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !await navigatorKeys[_currentTab].currentState.maybePop(),
      child: CupertinoHomeScaffold(
        currentTab: _currentTab,
        onSelectTab: _select,
        widgetBuilders: widgetBuilders,
        navigatorKeys: navigatorKeys,
      ),
    );
  }

}