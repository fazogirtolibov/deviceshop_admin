import 'package:deviceshop_admin/data/models/user_model.dart';
import 'package:deviceshop_admin/data/services/notification_api_service.dart';
import 'package:deviceshop_admin/utils/color.dart';
import 'package:deviceshop_admin/view_models/users_view_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AllUsersScreen extends StatefulWidget {
  const AllUsersScreen({Key? key}) : super(key: key);

  @override
  State<AllUsersScreen> createState() => _AllUsersScreenState();
}

class _AllUsersScreenState extends State<AllUsersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          iconSize: 36,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_circle_left_outlined),
          color: MyColors.appBarText,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Users Admin",
          style: GoogleFonts.raleway(color: MyColors.appBarText),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                String messageId =
                    await NotificationApiService.sendNotificationToAll("users");
                print("NOTIFICATION SUCCESS:$messageId");
              },
              icon: const Icon(Icons.notification_add)),
        ],
      ),
      body: StreamBuilder<List<UserModel>>(
        stream:
            Provider.of<UsersViewModel>(context, listen: false).listenUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            List<UserModel> users = snapshot.data!;
            return ListView(
              children: List.generate(users.length, (index) {
                UserModel user = users[index];
                return ListTile(
                  title: Text(user.email),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () async {
                              String message = "";
                              await _showDialog((value) {
                                message = value;
                              });

                              int sendSuccess = await NotificationApiService
                                  .sendNotificationToUser(
                                fcmToken: user.fcmToken,
                                message: message,
                              );
                              print("NOTIF SUCESS:$sendSuccess");
                            },
                            icon: const Icon(Icons.notification_add)),
                      ],
                    ),
                  ),
                );
              }),
            );
          } else {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
        },
      ),
    );
  }

  Future<void> _showDialog(ValueChanged<String> message) async {
    final TextEditingController controller = TextEditingController();
    await showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: SizedBox(
                height: 200,
                child: Column(
                  children: [
                    TextField(
                      controller: controller,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          message.call(controller.text);
                          Navigator.pop(context);
                        },
                        child: const Text("Send")),
                  ],
                )),
          );
        });
  }
}
