import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marbre/application/auth/auth_bloc.dart';
import 'package:marbre/application/tab/app_tab.dart';
import 'package:marbre/application/tab/tab_bloc.dart';
import 'package:marbre/presentation/pages/feed/feed_page.dart';
import 'package:marbre/presentation/pages/settings/settings_page.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tabBloc = BlocProvider.of<TabBloc>(context);
    return BlocBuilder<TabBloc, AppTab>(
      builder: (context, activeTab) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {

                },
              ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () {
                  BlocProvider.of<AuthBloc>(context).add(
                    LoggedOut(),
                  );
                },
              )
            ]
          ),
          body: activeTab == AppTab.feed ? FeedPage()
            : SettingsPage(),
          bottomNavigationBar: BottomNavyBar(
            selectedIndex: AppTab.values.indexOf(activeTab),
            onItemSelected: (index) => tabBloc.add(UpdateTab(AppTab.values[index])),
            items: [
              BottomNavyBarItem(
                icon: Icon(Icons.rss_feed),
                title: Text('Feed'),
                activeColor: Colors.amber,
              ),
              BottomNavyBarItem(
                icon: Icon(Icons.settings),
                title: Text('Settings'),
                activeColor: Colors.amber,
              ),
            ],
          ),
        );
      }
    );
  }
}