import 'package:bloc/bloc.dart';
import 'package:budgetapp/services/shared_prefs.dart';
import 'package:meta/meta.dart';

part 'app_setup_state.dart';

class AppSetupCubit extends Cubit<AppSetupState> {
  AppSetupCubit() : super(AppSetupInitial()){
    SharedPrefs().seenTour().then((value) {
      if(value == true){
        emit(AppSetupDone());
      }else{
        emit(AppSetupInitial());
      }
    });
  }
  void viewTour(){
     SharedPrefs().setSeenTour();
    emit(AppSetupDone());
  }
}
