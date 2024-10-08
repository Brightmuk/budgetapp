import 'package:admob_flutter/admob_flutter.dart';
import 'package:budgetapp/constants/colors.dart';
import 'package:budgetapp/constants/formatters.dart';
import 'package:budgetapp/constants/sizes.dart';
import 'package:budgetapp/models/budget_plan.dart';
import 'package:budgetapp/models/wish.dart';
import 'package:budgetapp/pages/homeTabs/spending_list_tab.dart';
import 'package:budgetapp/pages/homeTabs/wishlist_tab.dart';
import 'package:budgetapp/pages/create_list.dart';
import 'package:budgetapp/pages/info_screen.dart';
import 'package:budgetapp/pages/settings.dart';
import 'package:budgetapp/providers/app_state_provider.dart';
import 'package:budgetapp/services/budget_plan_service.dart';
import 'package:budgetapp/services/wish_service.dart';
import 'package:budgetapp/widgets/expense_type.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:animations/animations.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final DateFormat dayDate = DateFormat('EEE dd, yyy');

  ///Ads here
  AdmobBannerSize? bannerSize;
  late AdmobInterstitial interstitialAd;
  // late AdmobReward rewardAd;

  @override
  void initState() {
    super.initState();
    bannerSize = AdmobBannerSize.BANNER;
    Admob.requestTrackingAuthorization();

    interstitialAd = AdmobInterstitial(
      adUnitId: 'ca-app-pub-1360540534588513/6335620084',
      listener: (AdmobAdEvent event, Map<String, dynamic>? args) {
        if (event == AdmobAdEvent.closed) interstitialAd.load();
        // handleEvent(event, args, 'Interstitial');
      },
    );

    // rewardAd = AdmobReward(
    //   adUnitId: getRewardBasedVideoAdUnitId()!,
    //   listener: (AdmobAdEvent event, Map<String, dynamic>? args) {
    //     if (event == AdmobAdEvent.closed) rewardAd.load();
    //     handleEvent(event, args, 'Reward');
    //   },
    // );

    interstitialAd.load();
    // rewardAd.load();
  }

  @override
  void dispose() {
    interstitialAd.dispose();
    // rewardAd.dispose();
    super.dispose();
  }

  String bPTotal(List<SpendingPlan> plans) {
    int total = 0;
    for (var plan in plans) {
      total += plan.total;
    }
    return AppFormatters.moneyStr(total);
  }

  String wishTotal(List<Wish> wishes) {
    int total = 0;
    for (var wish in wishes) {
      total += wish.price;
    }

    return AppFormatters.moneyStr(total);
  }

  void newItem() async {
    // NotificationService().showTimeoutNotification(1000);
    await showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        context: context,
        builder: (context) => const ExpenseType());
  }

  @override
  Widget build(BuildContext context) {
    final AppState _appState = Provider.of<AppState>(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: Container(),
          toolbarHeight: AppSizes.maxToolBarHeight,
          flexibleSpace: AnimatedContainer(
            duration: const Duration(seconds: 2),
            height: AppSizes.maxToolBarHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.themeColor,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  height: 20.sp,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OpenContainer(
                      closedColor: AppColors.themeColor,
                      closedElevation: 0,
                      closedBuilder: (_, openContainer) {
                      return Padding(
                        padding: const EdgeInsets.all(20),
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: 80.sp,
                        ),
                      );
                    }, openBuilder: (_, closedContainer) {
                      return const InfoScreen();
                    }),
                    Container(
                      padding: EdgeInsets.all(10.sp),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        border: Border.all(color: Colors.white, width: 0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    IconButton(
                        padding: const EdgeInsets.all(20),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const SettingsPage()));
                        },
                        icon: Icon(Icons.settings_outlined,
                            size: AppSizes.iconSize.sp))
                  ],
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        dayDate.format(DateTime.now()),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 50.sp,
                            fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Divider(
                  height: 0,
                ),
                Text(
                  'TOTALS',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 35.sp,
                      fontWeight: FontWeight.w300),
                ),
                const Divider(
                  height: 0,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      StreamBuilder<List<SpendingPlan>>(
                          stream: BudgetPlanService(appState: _appState)
                              .budgetPlansStream,
                          builder: (context, snapshot) {
                            return CircularPercentIndicator(
                              animation: true,
                              linearGradient: const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.pinkAccent,
                                    AppColors.themeColor
                                  ]),
                              animateFromLastPercent: true,
                              radius: 150.0.sp,
                              lineWidth: 5.0.sp,
                              percent: 1,
                              backgroundColor: Colors.white.withOpacity(0.1),
                              center: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _appState.currentCurrency!,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.6),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                  Text(
                                    snapshot.hasData
                                        ? bPTotal(snapshot.data!)
                                        : '0',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            );
                          }),
                      StreamBuilder<List<Wish>>(
                          stream: WishService(appState: _appState).wishStream,
                          builder: (context, snapshot) {
                            return CircularPercentIndicator(
                              animation: true,
                              animateFromLastPercent: true,
                              linearGradient: const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.orangeAccent,
                                    AppColors.themeColor
                                  ]),
                              radius: 150.0.sp,
                              lineWidth: 5.0.sp,
                              percent: 1,
                              backgroundColor: Colors.white.withOpacity(0.1),
                              center: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _appState.currentCurrency!,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.6),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                  Text(
                                    snapshot.hasData
                                        ? wishTotal(snapshot.data!)
                                        : '0',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            );
                          }),
                    ]),
                TabBar(
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorColor: Colors.white,
                    labelStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w300),
                    tabs: const [
                      // Tab(
                      //   text: 'OVERVIEW',
                      // ),
                      Tab(
                        text: 'SPENDING PLANS',
                      ),
                      Tab(
                        text: 'WISHLIST',
                      )
                    ]),
                const SizedBox(),
              ],
            ),
          ),
        ),
        body: const Padding(
          padding: EdgeInsets.only(bottom: 50),
          child: TabBarView(
            children: [SpendingListTab(), WishListTab()],
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(left: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FloatingActionButton.extended(
                label: Text(
                  'Quick List',
                  style: TextStyle(color: Colors.white, fontSize: 35.sp),
                ),
                icon: Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: AppSizes.iconSize.sp,
                ),
                onPressed: () async {
                  await showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) => const CreateList(
                            expenses: [],
                          ));
                },
                backgroundColor: AppColors.themeColor,
              ),
              FloatingActionButton(
                heroTag: 'New',
                backgroundColor: AppColors.themeColor,
                onPressed: newItem,
                tooltip: 'New item',
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: AppSizes.iconSize.sp,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  //  void handleEvent(
  //     AdmobAdEvent event, Map<String, dynamic>? args, String adType) {
  //   switch (event) {
  //     case AdmobAdEvent.loaded:
  //       showSnackBar('New Admob $adType Ad loaded!');
  //       break;
  //     case AdmobAdEvent.opened:
  //       showSnackBar('Admob $adType Ad opened!');
  //       break;
  //     case AdmobAdEvent.closed:
  //       showSnackBar('Admob $adType Ad closed!');
  //       break;
  //     case AdmobAdEvent.failedToLoad:
  //       showSnackBar('Admob $adType failed to load. :(');
  //       break;
  //     case AdmobAdEvent.rewarded:
  //       showDialog(
  //         context: scaffoldState.currentContext!,
  //         builder: (BuildContext context) {
  //           return WillPopScope(
  //             onWillPop: () async {
  //               ScaffoldMessenger.of(context).hideCurrentSnackBar();
  //               return true;
  //             },
  //             child: AlertDialog(
  //               content: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: <Widget>[
  //                   Text('Reward callback fired. Thanks Andrew!'),
  //                   Text('Type: ${args!['type']}'),
  //                   Text('Amount: ${args['amount']}'),
  //                 ],
  //               ),
  //             ),
  //           );
  //         },
  //       );
  //       break;
  //     default:
  //   }
  // }
}
