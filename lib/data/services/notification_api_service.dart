import 'dart:convert';
import 'package:http/http.dart' as https;
import 'package:http/http.dart';

class NotificationApiService {
  static Future<int> sendNotificationToUser(
      {required String fcmToken, required String message}) async {
    String key =
        "key=AAAAEkn9Pdk:APA91bGN0gyu_E66Q0HRroq_5IWewlTSbe55OXUY8JR41Qwo__9eKSdUEy21NZjJWemfyKvltpihQIXsOGw5rWkGWlOTx5P0VAlgxTOCGQFDHtcL-kAOmZVRNP1oljH5maDjYUs2ZJ8E";
    var body = {
      "to": fcmToken,
      "notification": {"title": "Diqqat! Notification keldi", "body": message},
      "data": {
        "name": "Abdulloh",
        "age": 22,
        "job": "Programmer",
        "route": "chat"
      }
    };

    Uri uri = Uri.parse("https://fcm.googleapis.com/fcm/send");

    try {
      Response response = await https.post(
        uri,
        headers: {"Authorization": key, "Content-Type": "application/json"},
        body: json.encode(body),
      );
      if (response.statusCode == 200) {
        var t = jsonDecode(response.body);
        print("RESPONSE:$t");
        return jsonDecode(response.body)["success"] as int;
      } else {
        throw Exception();
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<String> sendNotificationToAll(String topicName) async {
    String key =
        "key=AAAAEkn9Pdk:APA91bGN0gyu_E66Q0HRroq_5IWewlTSbe55OXUY8JR41Qwo__9eKSdUEy21NZjJWemfyKvltpihQIXsOGw5rWkGWlOTx5P0VAlgxTOCGQFDHtcL-kAOmZVRNP1oljH5maDjYUs2ZJ8E";

    Map<String, dynamic> body = {
      "to": "/topics/$topicName",
      "notification": {
        "title": "Hello mofo! This is just a notification",
        "body": "notification supposed to be here"
      },
      "data": {
        "name": "Abdulloh",
        "age": 22,
        "job": "Programmer",
        "route": "chat"
      }
    };

    Uri uri = Uri.parse("https://fcm.googleapis.com/fcm/send");
    try {
      Response response = await https.post(
        uri,
        headers: {
          "Authorization": key,
          "Content-Type": "application/json",
        },
        body: json.encode(body),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body)["message_id"].toString();
      } else {
        throw Exception();
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
