import 'package:budgetapp/cubit/app_setup_cubit.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:provider/provider.dart';

class TourScreen extends StatelessWidget {
  final bool isFirstTime;
  const TourScreen({Key? key, required this.isFirstTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cubit = Provider.of<AppSetupCubit>(context, listen: false);

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: IntroductionScreen(
        pages: [
          PageViewModel(
            title: 'Welcome to Spenditize',
            body: 'The smart way to track your spending and achieve your financial goals.',
            image: Center(child: Image.asset('assets/images/welcome_slide.png', height: 250)),
            decoration: _getPageDecoration(theme),
          ),
          PageViewModel(
            title: 'Quick Spending Lists',
            body: 'Create lists on the fly while shopping to stay within your budget.',
            image: Center(child: Image.asset('assets/images/quick_list_slide.png', height: 250)),
            decoration: _getPageDecoration(theme),
          ),
          // New Spaced Repetition / Mastery Slide
          PageViewModel(
            title: 'Remember for Life',
            body: 'We use a scientifically proven algorithm to schedule your reviews at the exact moment you\'re about to forget.',
            image: Center(child: Image.asset('assets/images/wish_list_slide.png', height: 250)),
            decoration: _getPageDecoration(theme),
          ),
        ],
        onDone: () => cubit.viewTour(),
        onSkip: () => cubit.viewTour(),
        showSkipButton: true,
        skip: Text('Skip', style: TextStyle(color: theme.colorScheme.primary)),
        next: Icon(Icons.arrow_forward, color: theme.colorScheme.primary),
        done: Text('Get Started', 
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