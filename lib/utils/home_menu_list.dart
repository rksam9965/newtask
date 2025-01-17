import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class HomeMenuList extends StatefulWidget {
  HomeMenuList({Key? key}) : super(key: key);

  @override
  HomeMenuListState createState() => HomeMenuListState();
}

class HomeMenuListState extends State<HomeMenuList> {
  String userName = '';

  @override
  void initState() {
    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        child: Container(
          // width: MediaQuery.of(context).size.width/8,
          child: Column(
            children: [
              Container(
                height: 100,
                width: MediaQuery.of(context).size.width * 0.78,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30.0),
                  ),
                  color: Colors.white,
                ),
                child: Container(
                  margin: const EdgeInsets.only(top: 30, left: 20, bottom: 10),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.person,
                        size: 30,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        userName,
                        style: TextStyle(fontSize: 18, color: Colors.black),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.78,
                height: MediaQuery.of(context).size.height - 100,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(30.0),
                  ),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () => {},
                      child: menuItem(
                        icon: Icons.border_all,
                        text: 'Placed Order',
                      ),
                    ),
                    InkWell(
                      onTap: () => {},
                      child: menuItem(
                        icon: Icons.backup_table_outlined,
                        text: 'Add Cart',
                      ),
                    ),
                    // Signout Option
                    InkWell(
                      onTap: () => {},
                      child: menuItem(
                        icon: Icons.logout,
                        text: 'Signout',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Menu item helper method for reusability
  Widget menuItem({required IconData icon, required String text}) {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(left: 20),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(fontSize: 14, color: Colors.black),
          ),
        ],
      ),
    );
  }

  void showAlertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Are you sure you want to sign out?',
            textScaleFactor: 1),
        actions: <Widget>[
          CupertinoDialogAction(
            onPressed: () {},
            child: const Text('Yes', style: TextStyle(color: Colors.black)),
          ),
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            isDefaultAction: true,
            child: const Text('No', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}
