import 'package:equatable/equatable.dart';

abstract class ConfigState extends Equatable {
  @override
  List<Object> get props => [];

  ConfigState getStateCopy();
}

/// UnInitialized
class UnConfigState extends ConfigState {
  @override
  String toString() => 'UnConfigState';

  @override
  ConfigState getStateCopy() => UnConfigState();
}

/// Initialized
class InConfigState extends ConfigState {
  @override
  String toString() => 'InConfigState';

  @override
  ConfigState getStateCopy() => InConfigState();
}

class ErrorConfigState extends ConfigState {
  final String errorMessage;

  ErrorConfigState(this.errorMessage);

  @override
  String toString() => 'ErrorConfigState';

  @override
  ConfigState getStateCopy() => ErrorConfigState(errorMessage);
}
