import 'package:budgetapp/cubit/app_setup_cubit.dart';
import 'package:budgetapp/pages/home.dart';
import 'package:budgetapp/pages/tour.dart';
import 'package:budgetapp/providers/app_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<AppSetupCubit,AppSetupState>(builder: (context,state){
      if(state is AppSetupDone){
        return const MyHomePage();
      }
      return const TourScreen(isFirstTime: true);
    
    });    
  }
}
