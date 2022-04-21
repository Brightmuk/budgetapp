import 'package:budgetapp/pages/add_budget_plan.dart';
import 'package:budgetapp/pages/home_tabs.dart';
import 'package:budgetapp/pages/create_list.dart';
import 'package:budgetapp/pages/settings.dart';
import 'package:budgetapp/widgets/expense_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void newItem() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        context: context,
        builder: (context) => const ExpenseType());
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: Container(),
          toolbarHeight: 300,
          flexibleSpace: AnimatedContainer(
            duration: const Duration(seconds: 2),
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color.fromRGBO(72, 191, 132, 1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const SizedBox(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 40,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        border: Border.all(color: Colors.white, width: 0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                            context: context,
                            builder: (context) => const SettingsPage());

                      },
                      child: const Padding(
                        padding: EdgeInsets.all(20),
                        child: Icon(Icons.settings_outlined),
                      ),
                    )
                  ],
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text(
                        'Wed 13 Apr',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 35,
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
                const Text(
                  'COMPLETION',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w300),
                ),
                const Divider(
                  height: 0,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CircularPercentIndicator(
                        radius: 50.0,
                        lineWidth: 4.0,
                        percent: 0.5,
                        backgroundColor: const Color.fromRGBO(72, 185, 130, 1),
                        center: const Text(
                          '50%',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        progressColor: Colors.blueAccent,
                      ),
                      CircularPercentIndicator(
                        radius: 50.0,
                        lineWidth: 4.0,
                        percent: 0.7,
                        backgroundColor: const Color.fromRGBO(72, 185, 130, 1),
                        center: const Text(
                          '70%',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        progressColor: Colors.pinkAccent,
                      ),
                      CircularPercentIndicator(
                        radius: 50.0,
                        lineWidth: 4.0,
                        percent: 0.2,
                        backgroundColor: const Color.fromRGBO(72, 185, 130, 1),
                        center: const Text(
                          '20%',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        progressColor: Colors.orangeAccent,
                      ),
                    ]),
                const TabBar(
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorColor: Colors.white,
                    labelStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w300),
                    tabs: [
                      Tab(
                        text: 'ALL',
                      ),
                      Tab(
                        text: 'BUDGET PLANS',
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
          padding: EdgeInsets.fromLTRB(0, 10, 0, 50),
          child: TabBarView(
            children: [HomeTabs(), HomeTabs(), HomeTabs()],
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(left: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FloatingActionButton.extended(
                label: const Text(
                  'Quick List',
                  style: TextStyle(color: Colors.white),
                ),
                icon: const Icon(Icons.edit, color: Colors.white),
                onPressed: () {
                  showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) => const CreateList());
                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (context) => const BudgetLists())
                  //     );
                },
                backgroundColor: const Color.fromRGBO(72, 191, 132, 1),
              ),
              FloatingActionButton(
                heroTag: 'New',
                backgroundColor: const Color.fromRGBO(72, 191, 132, 1),
                onPressed: newItem,
                tooltip: 'New item',
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
