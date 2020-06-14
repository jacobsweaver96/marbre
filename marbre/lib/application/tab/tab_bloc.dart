import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'app_tab.dart';

part 'tab_event.dart';

class TabBloc extends Bloc<TabEvent, AppTab> {
  @override
  AppTab get initialState => AppTab.feed;

  @override
  Stream<AppTab> mapEventToState(
    TabEvent event,
  ) async* {
    if (event is UpdateTab) {
      yield event.tab;
    }
  }
}
