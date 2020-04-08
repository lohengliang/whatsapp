import 'package:flutter/material.dart';
import 'package:whatsup/home_scaffold.dart';
import 'package:whatsup/messages_page.dart';
import 'package:whatsup/settings_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.messages;

  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.messages: GlobalKey<NavigatorState>(),
    TabItem.settings: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, WidgetBuilder> get widgetBuilders {
    return {
      TabItem.messages: (_) => MessagesPage(),
      TabItem.settings: (context) => SettingsPage(),
    };
  }

  void _select(TabItem tabItem) {
    if (tabItem == _currentTab) {
      navigatorKeys[tabItem].currentState.popUntil((route) => route.isFirst);
    } else {
      setState(() => _currentTab = tabItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          !await navigatorKeys[_currentTab].currentState.maybePop(),
      child: HomeScaffold(
        currentTab: _currentTab,
        onSelectTab: _select,
        widgetBuilders: widgetBuilders,
        navigatorKeys: navigatorKeys,
      ),
    );
  }
}

enum TabItem { messages, settings }

class TabItemData {
  const TabItemData(
      {@required this.key, @required this.title, @required this.icon});

  final String key;
  final String title;
  final IconData icon;

  static const Map<TabItem, TabItemData> allTabs = {
    TabItem.messages: TabItemData(
      key: "messageTab",
      title: "Messages",
      icon: Icons.message,
    ),
    TabItem.settings: TabItemData(
      key: "settingsTab",
      title: "Settings",
      icon: Icons.settings,
    ),
  };
}
