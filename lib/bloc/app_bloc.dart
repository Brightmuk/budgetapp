
import 'package:flutter_bloc/flutter_bloc.dart';

class AppEvent {}

class AppState {}

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(AppState()) {
    on<AppEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
