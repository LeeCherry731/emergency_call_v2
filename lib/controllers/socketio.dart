// import 'package:emergency_call_v2/main.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;

// final SocketIO socketio = SocketIO();

// IO.Socket? socket;

// class SocketIO {
//   final ip_prod = "https://socketa1.ausirisnext.com/pushNotiNsp";
//   final ip_local = "http://192.168.1.134:3000";
//   final token =
//       "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1laWQiOiIwOTQ0Njk0Zi02ZmE5LTRiZGItYjIyYy1iMjkxYjQyMTJkMmQiLCJ1bmlxdWVfbmFtZSI6Im1ob29udW1AZ21haWwuY29tIiwidGtleSI6Im53dVZVSTAwM2xjaHpodExBMkhHR3JrV1JNSXRhNUFSV2d4TmJqbkVTR1ZCTGxkTVo0MVlaYmpxUkVhdkRoTlB2cy80TjFXdlRPdHhYUUhUY3NOZHN3PT0iLCJ1c2VyVHlwZSI6IiIsImNsaWVudElEIjoiIiwic2NoZW1hIjoiRiIsIm5iZiI6MTY5NjM5MjQxNywiZXhwIjoxNjk2NDAzMjE3LCJpYXQiOjE2OTYzOTI0MTcsImlzcyI6Imh0dHA6Ly9sb2NhbGhvc3QiLCJhdWQiOiJodHRwOi8vbG9jYWxob3N0In0.4059b_Wn3PpGbcSjHBY-5oFKTxxSV8X50HhFNNVs37o";

//   init() {
//     // if (socket != null && socket.connected) {
//     //   return;
//     // }
//     print("Init Socket");
//     try {
//       Map<String, String> headers = {
//         'token': token,
//         'memberId': "E0673DE2-1EF1-4240-95D1-6546D583CED6"
//       };

//       socket = IO.io(ip_local, <String, dynamic>{
//         'transports': ['websocket'],
//         'extraHeaders': headers,
//       });

//       socket?.connect();
//       socket?.onConnect((data) {
//         print(socket?.connected);
//         socket?.on('test', (data) => print(data));
//         socket?.on('noti', (data) async {
//           print(data);
//           await NotificationService.showNotification(
//             title: data["title"],
//             body: data["message"],
//           );
//         });
//       });
//     } catch (e) {
//       print(e);
//     }
//   }

//   sentNoti() {
//     try {
//       print(socket);
//       socket?.emit(
//         "msg",
//         {
//           "title": "sentNoti",
//           "message": "sentNoti",
//         },
//       );
//     } catch (e) {
//       print(e);
//     }
//   }
// }
