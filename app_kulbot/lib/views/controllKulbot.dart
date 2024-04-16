// import 'package:app_kulbot/views/chatScreen.dart';
// import 'package:app_kulbot/views/drivescreen.dart';
// import 'package:flutter/material.dart';
//
// class KulbotHome extends StatelessWidget {
//   const KulbotHome({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//         length: 2,
//         child: Scaffold(
//           appBar: AppBar(
//             backgroundColor: Colors.transparent,
//             title: const Text('Kulbot'),
//             centerTitle: true,
//           ),
//           body: TabBarView(
//             children: [
//               Container(
//                 alignment: Alignment.center,
//                 color: Colors.transparent,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                       padding: EdgeInsets.all(100),
//                       backgroundColor: Colors.green),
//                   onPressed: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => const DriveScreen()));
//                   },
//                   child: const Text(
//                     'drive',
//                     style: TextStyle(color: Colors.black, fontSize: 19),
//                   ),
//                 ),
//               ),
//               Container(
//                 alignment: Alignment.center,
//                 color: Colors.transparent,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                       padding: EdgeInsets.all(100),
//                       backgroundColor: Colors.green),
//                   onPressed: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => const ChatScreen()));
//                   },
//                   child: const Text('chat' ,style: TextStyle(fontSize: 20,color: Colors.black),),
//                 ),
//               ),
//             ],
//           ),
//         ));
//   }
// }
