import 'package:budgetapp/pages/add_budget_plan.dart';
import 'package:budgetapp/pages/add_wish.dart';
import 'package:flutter/material.dart';


class HomeTabs extends StatefulWidget {
  const HomeTabs({ Key? key }) : super(key: key);

  @override
  _HomeTabsState createState() => _HomeTabsState();
}

class _HomeTabsState extends State<HomeTabs> {
    final ScrollController _controller = ScrollController();
      bool hasItems = true;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
                  controller: _controller,
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    bool indexEven = index % 2 == 0;
                    if(hasItems){
                    return InkWell(
                      child: Ink(
                        child: Dismissible(
                          background: Container(
                            color: Colors.greenAccent.withOpacity(0.2),
                          ),
                          key: Key(index.toString()),
                          child: ListTile(
                              onTap: (){
                                    showModalBottomSheet(
                                      isScrollControlled: true,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  context: context,
                                  builder: (context) => const AddBudgetPlan());
                              },
                              leading: indexEven
                                  ? const Icon(
                                      Icons.construction,
                                      size: 20,
                                      color: Colors.pinkAccent,
                                    )
                                  : const Icon(
                                      Icons.shopping_cart_outlined,
                                      size: 20,
                                      color: Colors.orangeAccent,
                                    ),
                              title: const Text(
                                'Fuel',
                              ),
                              subtitle: Text('${index + 20} may 2022'),
                              trailing: const Text(
                                'Ksh.30k',
                              )),
                        ),
                      ),
                    );
                    }else{
                    return InkWell(
                      child: Ink(
                        child: indexEven
                                ? ListTile(
                     onTap: () {
                            showModalBottomSheet(
                                isScrollControlled: true,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                context: context,
                                builder: (context) => const AddBudgetPlan());
                          },
                            leading: const Icon(
                                    Icons.construction,
                                    size: 20,
                                    color: Colors.pinkAccent,
                                  ),
                                
                            title: const Text(
                              'You have no budget plans, create one',
                            ),
                           
                            trailing: Icon(Icons.arrow_forward_ios,size: 15,)):
                            ListTile(
                            onTap: () {
                              showModalBottomSheet(
                                  isScrollControlled: true,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  context: context,
                                  builder: (context) => const AddWish());
                            },
                            leading: const Icon(
                                    Icons.shopping_cart_outlined,
                                    size: 20,
                                    color: Colors.orangeAccent,
                                  ),
                                
                            title: const Text(
                              'You have no wishes, create one',
                            ),
                            
                            trailing: const Icon(Icons.arrow_forward_ios,size: 15,)),
                      ),
                    );
                    }
              
                  });
  }
}