import 'package:budgetapp/constants/colors.dart';
import 'package:budgetapp/constants/sizes.dart';
import 'package:budgetapp/providers/app_state_provider.dart';
import 'package:budgetapp/services/toast_service.dart';
import 'package:flutter/material.dart';
import 'package:pay/pay.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class RemoveAds extends StatefulWidget {
  const RemoveAds({
    Key? key,
  }) : super(key: key);

  @override
  _RemoveAdsState createState() => _RemoveAdsState();
}

class _RemoveAdsState extends State<RemoveAds> {
  bool isComplete = false;

  final _paymentItems = [
    const PaymentItem(
      label: 'Total',
      amount: '3',
      status: PaymentItemStatus.final_price,
    )
  ];

  @override
  Widget build(BuildContext context) {
    final AppState _appState = Provider.of<AppState>(context);
    switch (_appState.adPaymentState) {

      case AdPaymentState.initial:
        return Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          height: AppSizes(context: context).screenHeight * 0.6,
          width: AppSizes(context: context).screenWidth * 0.8,
          child: Scaffold(
            body: SingleChildScrollView(
              child: Column(children: <Widget>[
                SizedBox(
                  height: 100.sp,
                  child:
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.clear,
                          color: Colors.grey,
                        ))
                  ]),
                ),
                const Center(
                    child: Text(
                  'Remove all Ads ',
                  style: TextStyle(fontSize: 26),
                )),
                SizedBox(
                  height: 10.sp,
                ),
                Center(
                    child: Text(
                  'One time payment ',
                  style: TextStyle(
                      color: Colors.grey, fontSize: AppSizes.titleFont.sp),
                )),
                const Divider(),
                SizedBox(
                  height: AppSizes(context: context).screenHeight * 0.4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                          child: Text(
                        'TOTAL',
                        style: TextStyle(
                            color: AppColors.themeColor,
                            fontSize: AppSizes.titleFont.sp,
                            fontWeight: FontWeight.w300),
                      )),
                      SizedBox(
                        height: 10.sp,
                      ),
                      const Text(
                        '\$3.00',
                        style: TextStyle(fontSize: 40),
                      ),
                    ],
                  ),
                ),
                GooglePayButton(
                  width: 300,
                  paymentConfigurationAsset:
                      'default_payment_profile_google_pay.json',
                  paymentItems: _paymentItems,
                  style: GooglePayButtonStyle.black,
                  type: GooglePayButtonType.pay,
                  margin: const EdgeInsets.only(top: 15.0),
                  onPaymentResult: (Map<String, dynamic> value) {
                  
                    _appState.setInitialResult(result: value, state: AdPaymentState.summary);
                  },
                  loadingIndicator: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ]),
            ),
          ),
        );
      case AdPaymentState.summary:
        return Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          height: AppSizes(context: context).screenHeight * 0.6,
          width: AppSizes(context: context).screenWidth * 0.8,
          child: Scaffold(
            body: SingleChildScrollView(
              child: Column(children: <Widget>[
                SizedBox(
                  height: 100.sp,
                  child:
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.clear,
                          color: Colors.grey,
                        ))
                  ]),
                ),
                const Center(
                    child: Text(
                  'Summary ',
                  style: TextStyle(fontSize: 26),
                )),
                SizedBox(
                  height: 10.sp,
                ),
                Center(
                    child: Text(
                  'Review Order',
                  style: TextStyle(
                      color: Colors.grey, fontSize: AppSizes.titleFont.sp),
                )),
                const Divider(),
                SizedBox(
                  height: AppSizes(context: context).screenHeight * 0.4,
                  child: Column(

                    children: [
                      SizedBox(
                        height: 10.sp,
                      ),
                      ListTile(
                        leading: Text(_appState.gPayResult!.email),
                        
                      ),
                      const ListTile(
                        leading: Text('Total'),
                        trailing: Text('\$3.00'),
                      ),
                      ListTile(
                        title: const Text('Payment Method'),
                        trailing: Text('Google Pay ${_appState.gPayResult!.cardDetail}'),
                      ),
                    ],
                  ),
                ),
                MaterialButton(
                    minWidth: 300,
                    color: AppColors.themeColor,
                    child: const Text(
                      'Make Payment',
                    ),
                    onPressed: () {
                      _appState.updateAdPaymentState(AdPaymentState.complete);
                    })
              ]),
            ),
          ),
        );
              case AdPaymentState.complete:
        return Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          height: AppSizes(context: context).screenHeight * 0.6,
          width: AppSizes(context: context).screenWidth * 0.8,
          child: Scaffold(
            body: SingleChildScrollView(
              child: Column(children: <Widget>[
                SizedBox(
                  height: 100.sp,
                  child:
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.clear,
                          color: Colors.grey,
                        ))
                  ]),
                ),
                const Center(
                    child: Text(
                  'Transaction complete!',
                  style: TextStyle(fontSize: 26),
                )),
                SizedBox(
                  height: 10.sp,
                ),
                Center(
                    child: Text(
                  'No Ads',
                  style: TextStyle(
                      color: Colors.grey, fontSize: AppSizes.titleFont.sp),
                )),
                const Divider(),
                SizedBox(
                  height: AppSizes(context: context).screenHeight * 0.3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Center(
                          child: Icon(
                        Icons.check_circle_outline,
                        color: AppColors.themeColor,
                        size: 20,
                      )),
                      SizedBox(
                        height: 10.sp,
                      ),
                      Center(
                          child: Text(
                        'The purchase was successfully processed using Google Pay',
                        style: TextStyle(
                            color: AppColors.themeColor,
                            fontSize: AppSizes.titleFont.sp,
                            fontWeight: FontWeight.w300),
                      )),
                      SizedBox(
                        height: 20.sp,
                      ),
                      const Text(
                        'Ads will no longer be shown to you. Check your email for your receipt',
                      ),
                    ],
                  ),
                ),
                MaterialButton(
                    minWidth: 300,
                    color: AppColors.themeColor,
                    child: const Text(
                      'Done',
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    })
              ]),
            ),
          ),
        );
      case AdPaymentState.failed:
        return Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          height: AppSizes(context: context).screenHeight * 0.6,
          width: AppSizes(context: context).screenWidth * 0.8,
          child: Scaffold(
            body: SingleChildScrollView(
              child: Column(children: <Widget>[
                SizedBox(
                  height: 100.sp,
                  child:
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.clear,
                          color: Colors.grey,
                        ))
                  ]),
                ),
                const Center(
                    child: Text(
                  'Remove all Ads ',
                  style: TextStyle(fontSize: 26),
                )),
                SizedBox(
                  height: 10.sp,
                ),
                Center(
                    child: Text(
                  'One time payment ',
                  style: TextStyle(
                      color: Colors.grey, fontSize: AppSizes.titleFont.sp),
                )),
                const Divider(),
                SizedBox(
                  height: AppSizes(context: context).screenHeight * 0.4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                          child: Text(
                        'TOTAL',
                        style: TextStyle(
                            color: AppColors.themeColor,
                            fontSize: AppSizes.titleFont.sp,
                            fontWeight: FontWeight.w300),
                      )),
                      SizedBox(
                        height: 10.sp,
                      ),
                      const Text(
                        '\$3.00',
                        style: TextStyle(fontSize: 40),
                      ),
                    ],
                  ),
                ),
                MaterialButton(
                    minWidth: 300,
                    color: AppColors.themeColor,
                    child: const Text(
                      'Try again',
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    })
              ]),
            ),
          ),
        );
    }
  }
}
