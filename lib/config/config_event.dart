import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:firebase_chat_app/config/index.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ConfigEvent extends Equatable {
  @override
  List<dynamic> get props => [];

  Future<ConfigState> applyAsync({ConfigState currentState, ConfigBloc bloc});
}

class LoadConfigEvent extends ConfigEvent {
  @override
  String toString() => 'LoadConfigEvent';

  @override
  Future<ConfigState> applyAsync(
      {ConfigState? currentState, ConfigBloc? bloc}) async {
    try {
      await Future.delayed(Duration(seconds: 3));
      return InConfigState();
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return ErrorConfigState(_.toString());
    }
  }
}
