import 'package:budgetapp/cubit/app_setup_cubit.dart';
import 'package:budgetapp/l10n/app_localizations.dart';
import 'package:budgetapp/providers/app_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:provider/provider.dart';

class TourScreen extends StatefulWidget {
  final bool isFirstTime;
  const TourScreen({Key? key, required this.isFirstTime}) : super(key: key);

  @override
  State<TourScreen> createState() => _TourScreenState();
}

class _TourScreenState extends State<TourScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual, 
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cubit = Provider.of<AppSetupCubit>(context, listen: false);
    final l10n = AppLocalizations.of(context)!;
        final _appState = Provider.of<ApplicationState>(context);
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      
      body: IntroductionScreen(
        pages: [
          PageViewModel(
            title: l10n.welcome_to_spenditize,
            body: l10n.the_smart_way_to_track_your_spending_and_achieve_your_financial_goals,
            image: Center(child: Image.asset('assets/images/welcome_slide.png', height: 250)),
            decoration: _getPageDecoration(theme),
          ),
          PageViewModel(
            title: l10n.quick_spending_lists,
            body: l10n.create_lists_on_the_fly_while_shopping_to_stay_within_your_budget,
            image: Center(child: Image.asset('assets/images/quick_list_slide.png', height: 250)),
            decoration: _getPageDecoration(theme),
          ),
          // New Spaced Repetition / Mastery Slide
          PageViewModel(
            title: l10n.remember_for_life,
            body: l10n.we_will_remind_you_when_to_fulfil_your_purchase,
            image: Center(child: Image.asset('assets/images/wish_list_slide.png', height: 250)),
            decoration: _getPageDecoration(theme),
          ),
        ],
        onDone: () {
          _appState.init(context);
          cubit.viewTour();
        },
        onSkip: (){
          _appState.init(context);
          cubit.viewTour();
        },
        showSkipButton: true,
        skip: Text(l10n.skip, style: TextStyle(color: theme.colorScheme.primary)),
        next: Icon(Icons.arrow_forward, color: theme.colorScheme.primary),
        done: Text(l10n.get_started, 
            style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
        
        // M3 Style Dots
        dotsDecorator: DotsDecorator(
          size: const Size.square(10.0),
          activeSize: const Size(22.0, 10.0),
          activeColor: theme.colorScheme.primary,
          color: theme.colorScheme.outlineVariant,
          spacing: const EdgeInsets.symmetric(horizontal: 3.0),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
      ),
    );
    
  }
  

  PageDecoration _getPageDecoration(ThemeData theme) {
    return PageDecoration(
      titleTextStyle: theme.textTheme.headlineMedium!.copyWith(
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.onSurface,
      ),
      bodyTextStyle: theme.textTheme.bodyLarge!.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
      ),
      imagePadding: const EdgeInsets.only(top: 100),
      titlePadding: const EdgeInsets.only(top: 40, bottom: 20),
      bodyPadding: const EdgeInsets.symmetric(horizontal: 40),
      pageColor: theme.colorScheme.surface,
    );
  }
}