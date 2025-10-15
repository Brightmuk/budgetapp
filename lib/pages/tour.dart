import 'package:budgetapp/constants/colors.dart';
import 'package:budgetapp/constants/sizes.dart';
import 'package:budgetapp/constants/style.dart';
import 'package:budgetapp/pages/home.dart';
import 'package:budgetapp/services/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class TourScreen extends StatefulWidget {
  final bool isFirstTime;
  const TourScreen({Key? key, required this.isFirstTime}) : super(key: key);

  @override
  State<TourScreen> createState() => _TourScreenState();
}

class _TourScreenState extends State<TourScreen> {
  final List<String> pages = [
    'assets/images/welcome_slide.png',
    'assets/images/quick_list_slide.png',
    'assets/images/wish_list_slide.png',
    'assets/images/spending_list_slide.png',
    'assets/images/done_slide.png'
  ];

  int viewIndex = 0;
  final Uri _introVideo = Uri.parse(
      "https://www.youtube.com/watch?v=qcvBxIzlSwc&t=4s");
  Widget indicator(currentIndex) {
    return SizedBox(
        height: 30.sp,
        width: pages.length * 30,
        child: ListView.separated(
            itemCount: pages.length,
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) {
              return const SizedBox(
                width: 10,
              );
            },
            itemBuilder: (context, index) {
              return Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  color: currentIndex == index
                      ? AppColors.themeColor
                      : Colors.white.withOpacity(0.1),
                  border: Border.all(
                      color: Colors.white.withOpacity(0.2), width: 0.6),
                  borderRadius: BorderRadius.circular(10),
                ),
              );
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.themeColor,
      body: Container(
        height: AppSizes(context: context).screenHeight,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromRGBO(72, 191, 132, 1),
            Color.fromRGBO(50, 84, 67, 1),
          ],
        )),
        child: Padding(
          padding: EdgeInsets.fromLTRB(10.sp, 100.sp, 10.sp, 10.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MaterialButton(
                    elevation: 0,
                    color: Colors.transparent,
                    onPressed: () {
                      widget.isFirstTime
                          ? SharedPrefs().setSeenTour().then((value) =>
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const MyHomePage())))
                          : Navigator.pop(context);
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 50.sp,
              ),
              CarouselSlider.builder(
                  options: CarouselOptions(
                    onPageChanged: (index, reason) {
                      setState(() {
                        viewIndex = index;
                      });
                    },
                    height: AppSizes(context: context).screenHeight * 0.6,
                    aspectRatio: 16 / 9,
                    viewportFraction: 1,
                    initialPage: 0,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    scrollDirection: Axis.horizontal,
                  ),
                  itemCount: pages.length,
                  itemBuilder:
                      (BuildContext context, int index, int pageViewIndex) =>
                          Image.asset(
                            pages[index],
                          )),
              SizedBox(
                height: 50.sp,
              ),
              Visibility(
                  visible: viewIndex == pages.length - 1,
                  child: OutlinedButton(
                   
                    child: Text('Watch Video'),
                    onPressed: () {
                      _launchUrl(_introVideo);
                    },
                  )),
              SizedBox(
                height: 200.sp,
              ),
              indicator(viewIndex),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Visibility(
        visible: viewIndex == pages.length - 1,
        child: FilledButton(
          onPressed: () {
            widget.isFirstTime
                ? SharedPrefs().setSeenTour().then((value) =>
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const MyHomePage())))
                : Navigator.pop(context);
          },
         
          child: const Text('Get Started'),
        ),
      ),
    );
  }

  void _launchUrl(Uri url) async {
    if (!await launchUrl(url)) throw 'Could not launch url';
  }
}
