import 'package:budgetapp/cubit/app_setup_cubit.dart';
import 'package:budgetapp/navigation/routes.dart';
import 'package:budgetapp/services/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class OnboardingItem {
  final String title;
  final String description;
  final String image;

  OnboardingItem({required this.title, required this.description, required this.image});
}

class TourScreen extends StatefulWidget {
  final bool isFirstTime;
  const TourScreen({Key? key, required this.isFirstTime}) : super(key: key);

  @override
  State<TourScreen> createState() => _TourScreenState();
}

class _TourScreenState extends State<TourScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingItem> _items = [
    OnboardingItem(
      title: 'Welcome to Spenditize',
      description: 'The smart way to track your spending and achieve your financial goals.',
      image: 'assets/images/welcome_slide.png',
    ),
    OnboardingItem(
      title: 'Quick Spending Lists',
      description: 'Create lists on the fly while shopping to stay within your budget.',
      image: 'assets/images/quick_list_slide.png',
    ),
    OnboardingItem(
      title: 'Your Personal Wishlist',
      description: 'Save items you want to buy later and get reminded when it\'s time.',
      image: 'assets/images/wish_list_slide.png',
    ),

  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    AppSetupCubit cubit = Provider.of<AppSetupCubit>(context);
    
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF48BF84), Color(0xFF325443)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top Bar: Skip button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                   
                  ],
                ),
              ),
              
              // Carousel Section
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) => setState(() => _currentPage = index),
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    return Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(item.image, height: 300),
                          const SizedBox(height: 40),
                          Text(
                            item.title,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            item.description,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Bottom Section: Indicators and Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: Column(
                  children: [
                    // M3 Pill Indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_items.length, (index) => _buildIndicator(index)),
                    ),
                    const SizedBox(height: 40),
                    
                    // Conditional Action Buttons
                    AnimatedCrossFade(
                      firstChild: SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.all(16),
                          ),
                          onPressed: () => _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
                         
                          label: const Text('Next'),
                        ),
                      ),
                      secondChild: SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF325443),
                            padding: const EdgeInsets.all(16),
                          ),
                          onPressed: ()=> cubit.viewTour(),
                          child: const Text('Get Started', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                      crossFadeState: _currentPage == _items.length - 1
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      duration: const Duration(milliseconds: 300),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIndicator(int index) {
    bool isActive = _currentPage == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  void _launchUrl(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not open video')));
    }
  }
}