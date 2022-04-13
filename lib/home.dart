import 'package:budgetapp/add_item.dart';
import 'package:budgetapp/item_list.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _controller = ScrollController();

  void newItem() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        context: context,
        builder: (context) => const ItemType());
  }

  bool hasItems = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      'assets/icons/logo.png',
                      width: 40,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                    border: Border.all(color: Colors.white,width: 0.5),
                    borderRadius: BorderRadius.circular(10),
                    
                  ),),
                  GestureDetector(
                    onTap: () {
                   
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
                          fontWeight: FontWeight.bold),
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
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Column(
                  children: [
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
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'PROJECTS',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
                Column(
                  children: [
                    CircularPercentIndicator(
                      radius: 50.0,
                      lineWidth: 4.0,
                      percent: 0.25,
                      backgroundColor: const Color.fromRGBO(72, 185, 132, 1),
                      center: const Text(
                        '25%',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            ),
                      ),
                      progressColor: Colors.orangeAccent,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'WISHLIST',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w300),
                    ),

                  ],
                ),
              ]),
              const SizedBox(),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0,10,0,50),
        child: NotificationListener<ScrollUpdateNotification>(
          onNotification: (notification) {
            print(notification.scrollDelta);
            return true;
          },
          child: ListView.builder(
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
                            builder: (context) => const AddProject());
                      },
                        leading: const Icon(
                                Icons.construction,
                                size: 20,
                                color: Colors.pinkAccent,
                              ),
                            
                        title: const Text(
                          'You have no projects, create one',
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

              }),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left:25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
              FloatingActionButton.extended(
                label: const Text('Quick List'),
                icon: const Icon(Icons.edit),
                onPressed: (){
                                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const BudgetLists()));
                },
                backgroundColor: const Color.fromRGBO(72, 191, 132, 1),

                ),
             FloatingActionButton(
               heroTag: 'New',
              backgroundColor: const Color.fromRGBO(72, 191, 132, 1),
              onPressed: newItem,
              tooltip: 'New item',
              child: const Icon(Icons.add),
            )
          ],
        ),
      ),
    );
  }
}
