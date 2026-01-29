import 'package:budgetapp/core/formatters.dart';
import 'package:budgetapp/core/utils/string_extension.dart';
import 'package:budgetapp/core/widgets/app_item_tile.dart';
import 'package:budgetapp/l10n/app_localizations.dart';
import 'package:budgetapp/models/wish.dart';
import 'package:budgetapp/providers/app_state_provider.dart';
import 'package:budgetapp/router.dart';
import 'package:budgetapp/services/wish_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
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
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
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
                    Text(l10n.no_wishes_yet,style: theme.textTheme.labelLarge!.copyWith(color: theme.colorScheme.outline),),
                    SizedBox(
                      height: 10,
                    ),
                    TextButton(
                      style: FilledButton.styleFrom(
                        minimumSize: Size(100, 50)
                      ),
                        onPressed: () {
                          context.push(AppLinks.addWish);
                        
                        },
                        child:  Text(
                          l10n.creat_one
                        )),
                  ]
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
  const WishTile({Key? key, required this.index, required this.wish}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<ApplicationState>(context);
    final dateStr = DateFormat('EEE dd, yyyy').format(wish.creationDate);
    final l10n = AppLocalizations.of(context)!;
    return AppItemTile(
      title: wish.name.capitalize,
      subtitle: l10n.added_on_datestr(dateStr),
      amount: '${appState.currentCurrency} ${AppFormatters.moneyCommaStr(wish.price)}',
      icon: Icons.auto_awesome_outlined,
      iconColor: Colors.orangeAccent,
      iconBgColor: Colors.orange.withOpacity(0.1),
      onTap: () => context.push(AppLinks.singleWish, extra: wish.id),
    );
  }
}
