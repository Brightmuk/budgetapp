import 'package:budgetapp/constants/colors.dart';
import 'package:budgetapp/constants/sizes.dart';
import 'package:budgetapp/pages/settings/about_us.dart';
import 'package:budgetapp/pages/settings/help.dart';
import 'package:budgetapp/pages/tour.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {

  const SettingsPage({
    Key? key, }) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final Uri _playStoreUrl = Uri.parse('https://flutter.dev');

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: Container(),
          toolbarHeight: AppSizes.minToolBarHeight,
          flexibleSpace: AnimatedContainer(
            padding: const EdgeInsets.all(15),
            duration: const Duration(seconds: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.themeColor,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 20.sp,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Settings',
                      style: TextStyle(
                          fontSize: AppSizes.titleFont.sp,
                          fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.clear_outlined),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            ListTile(
              leading: Icon(Icons.info_outline, size: AppSizes.iconSize.sp),
              title: Text(
                'Take a tour',
                style: TextStyle(fontSize: AppSizes.normalFontSize.sp),
              ),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (ctx) => const TourScreen(isFirstTime: false,)));
              },
            ),
            ListTile(
              leading: Icon(Icons.info_outline, size: AppSizes.iconSize.sp),
              title: Text(
                'About Us',
                style: TextStyle(fontSize: AppSizes.normalFontSize.sp),
              ),
              onTap: () {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) => const AboutUs());
              },
            ),
            ListTile(
              leading:
                  Icon(Icons.help_center_outlined, size: AppSizes.iconSize.sp),
              title: Text('Help',
                  style: TextStyle(fontSize: AppSizes.normalFontSize.sp)),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (ctx) => const Help()));
              },
            ),
            ListTile(
                leading: Icon(Icons.rate_review_outlined,
                    size: AppSizes.iconSize.sp),
                title: Text('Rate Us',
                    style: TextStyle(fontSize: AppSizes.normalFontSize.sp)),
                onTap: _launchUrl),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
            ),
            FutureBuilder<PackageInfo>(
                future: PackageInfo.fromPlatform(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    String version = snapshot.data!.version;
                    return Text(
                      'VERSION $version',
                      style: TextStyle(
                          color: AppColors.themeColor,
                          fontSize: AppSizes.normalFontSize.sp,
                          fontWeight: FontWeight.w300),
                    );
                  } else {
                    return Container();
                  }
                })
          ]),
        ),
      ),
    );
  }

  void _launchUrl() async {
    if (!await launchUrl(_playStoreUrl))
      throw 'Could not launch $_playStoreUrl';
  }
}
