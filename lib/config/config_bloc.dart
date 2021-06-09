import 'dart:async';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:firebase_chat_app/config/index.dart';

class ConfigBloc extends Bloc<ConfigEvent, ConfigState> {
  static final ConfigBloc _instance = ConfigBloc._internal();

  factory ConfigBloc() {
    return _instance;
  }

  ConfigBloc._internal() : super(UnConfigState());

  @override
  @override
  ConfigState get initialState => UnConfigState();

  bool darkMode = false;

  @override
  Stream<ConfigState> mapEventToState(
    ConfigEvent event,
  ) async* {
    try {
      yield UnConfigState();
      yield await event.applyAsync(currentState: state, bloc: this);
    } catch (_, stackTrace) {
      developer.log('$_', name: 'ConfigBloc', error: _, stackTrace: stackTrace);
      yield state;
    }
  }
}
