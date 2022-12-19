import 'package:deviceshop_admin/ui/admin/category/all_categories_screen.dart';
import 'package:deviceshop_admin/ui/admin/products/all_products_screen.dart';
import 'package:deviceshop_admin/ui/admin/users/all_users_screen.dart';
import 'package:deviceshop_admin/ui/chat/chat_screen.dart';
import 'package:deviceshop_admin/utils/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  _printFCMTOKEN() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print("FCM TOKEN:$token");
  }

  _handleFirebaseNotificationMessages() async {
    //Foregrounddan kelgan messagelarni tutib olamiz
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Foregroundda message ushladim!');
      print('Message data: ${message.data}');
      if (message.notification != null) {
        print('Notification bor: ${message.notification}');
        print(message.notification!.title);
        print(message.notification!.body);
      }
    });
  }

  _setupInteractedMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    //Terminateddan kirganda bu ishlaydi
    if (initialMessage != null) {
      if (initialMessage.data['route'] == 'chat') {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const ChatScreen()));
      }
    }

    //Backgounddan kirganda shu ishlaydi
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.data['route'] == 'chat') {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const ChatScreen()));
      }
    });
  }

  @override
  void initState() {
    _printFCMTOKEN();
    _handleFirebaseNotificationMessages();
    _setupInteractedMessage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(FirebaseMessaging.instance.getToken());
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            child: Text(
              "Log Out",
              style: GoogleFonts.raleway(
                color: MyColors.appBarText,
              ),
            ),
          ),
        ],
        title: Text(
          "Admin Page",
          style: GoogleFonts.raleway(color: MyColors.appBarText),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          ListTile(
            title: Text(
              "Products",
              style: GoogleFonts.raleway(),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AllProductsScreen()));
            },
          ),
          ListTile(
            title: Text(
              "Categories",
              style: GoogleFonts.raleway(),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AllCategoriesScreen()));
            },
          ),
          ListTile(
            title: Text(
              "Users",
              style: GoogleFonts.raleway(),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AllUsersScreen()));
            },
          ),
        ],
      ),
    );
  }
}
