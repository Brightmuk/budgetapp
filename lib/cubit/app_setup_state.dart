part of 'app_setup_cubit.dart';

@immutable
sealed class AppSetupState {}

final class AppSetupInitial extends AppSetupState {}
final class AppSetupDone extends AppSetupState {}