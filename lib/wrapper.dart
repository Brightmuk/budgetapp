import 'package:budgetapp/cubit/app_setup_cubit.dart';
import 'package:budgetapp/pages/home.dart';
import 'package:budgetapp/pages/tour.dart';
import 'package:budgetapp/providers/app_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ApplicationState>(context, listen: false).init(context);
    });
  }
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

