
import 'package:budgetapp/core/colors.dart';
import 'package:budgetapp/core/formatters.dart';
import 'package:budgetapp/core/sizes.dart';
import 'package:budgetapp/models/wish.dart';
import 'package:budgetapp/providers/app_state_provider.dart';
import 'package:budgetapp/router.dart';
import 'package:budgetapp/services/wish_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class WishListTab extends StatefulWidget {
  const WishListTab({Key? key}) : super(key: key);

  @override
  _WishListTabState createState() => _WishListTabState();
}

class _WishListTabState extends State<WishListTab> {
  final ScrollController _controller = ScrollController();

  bool hasItems = false;

  @override
  Widget build(BuildContext context) {
    final ApplicationState _appState = Provider.of<ApplicationState>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: StreamBuilder<List<Wish>>(
          stream: WishService(context: context, appState: _appState).wishStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }

            if (snapshot.hasData) {
              List<Wish>? wishes = snapshot.data;
              return ListView.separated(
                  controller: _controller,
                  itemCount: wishes!.length,
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 3,
                    );
                  },
                  itemBuilder: (context, index) {
                    return WishTile(wish: wishes[index], index: index);
                  });
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    
                    
                   
                    Text(
                      'No wishes yet',
                      style: TextStyle(fontSize: AppSizes.normalFontSize.sp),
                    ),
                    SizedBox(
                      height: 30.sp,
                    ),
                    FilledButton.tonal(
                        
                        onPressed: () {
                          context.push(AppLinks.addWish);
                        
                        },
                        child: const Text(
                          'CREAT ONE',
                          style: TextStyle(color: AppColors.themeColor),
                        )),
                  ],
                ),
              );
            }
          }),
    );
  }
}

class WishTile extends StatelessWidget {
  final Wish wish;
  final int index;
  const WishTile({Key? key, required this.index, required this.wish})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateFormat dayDate = DateFormat('EEE dd, yyy');
    final ApplicationState _appState = Provider.of<ApplicationState>(context);


    return ListTile(
              tileColor: AppColors.themeColor.withOpacity(0.03),
              onTap: () {
            context.push(
              AppLinks.singleWish,
              extra: wish.id,
            );
              },
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.shopping_cart_outlined,
              size: AppSizes.iconSize.sp,
              color: Colors.orangeAccent,
            ),
          ),
          title: Text(
            wish.name,
            style: TextStyle(fontSize: AppSizes.normalFontSize.sp),
          ),
          subtitle: Text(dayDate.format(wish.creationDate),
              style: TextStyle(fontSize: AppSizes.normalFontSize.sp)),
          trailing: Text(
            '${AppFormatters.moneyCommaStr(wish.price)} ${_appState.currentCurrency}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: AppSizes.normalFontSize.sp,
            ),
          ),
            );

  }
}
