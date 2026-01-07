//
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:task_manager/providers/auth_provider.dart';
// import 'package:task_manager/ui/controller/auth_controller.dart';
// import 'package:task_manager/ui/screens/update_profile_screen.dart';
//
//
// import '../../data/services/image_stroge.dart';
//
// class TMAppBar extends StatefulWidget implements PreferredSizeWidget {
//   const TMAppBar({
//     super.key,
//   });
//
//   @override
//   State<TMAppBar> createState() => _TMAppBarState();
//
//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);
// }
//
// class _TMAppBarState extends State<TMAppBar> {
//   Widget? _localPhotoWidget;
//   bool _isLoading = true;
//   String? _displayName;
//   String? _displayEmail;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadAllData();
//   }
//
//   Future<void> _loadAllData() async {
//     setState(() {
//       _isLoading = true;
//     });
//
//     try {
//       await AuthController.getUserData();
//
//
//       final photoWidget = await ImageStorage.getUserPhotoWidget(size: 40);
//
//       if (mounted) {
//         setState(() {
//           _localPhotoWidget = photoWidget;
//           _displayName = AuthController.fullName;
//           _displayEmail = AuthController.email;
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//           _displayName = 'User';
//           _displayEmail = '';
//         });
//       }
//     }
//   }
//
//
//   void _onAppBarTap(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => const UpdateProfileScreen(),
//       ),
//     ).then((result) {
//       if (result == true && mounted) {
//         _loadAllData();
//       }
//     });
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//
//     if (_isLoading) {
//       return AppBar(
//         backgroundColor: Colors.green,
//         title: Row(
//           children: [
//             CircleAvatar(
//               radius: 20,
//               backgroundColor: Colors.grey.shade200,
//               child: const CircularProgressIndicator(
//                 strokeWidth: 2,
//                 color: Colors.white,
//               ),
//             ),
//             const SizedBox(width: 12),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   width: 120,
//                   height: 16,
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.3),
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//
//                 Container(
//                   width: 150,
//                   height: 12,
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         actions: [
//           IconButton(
//             onPressed: () {
//               AuthController.clearUserData();
//               ImageStorage.deleteUserPhoto();
//               Navigator.pushNamedAndRemoveUntil(
//                 context,
//                 '/Login',
//                     (route) => false,
//               );
//             },
//             icon: const Icon(Icons.logout, color: Colors.white),
//           ),
//         ],
//       );
//     }
//
//
//     return AppBar(
//       backgroundColor: Colors.green,
//       title: InkWell(
//         onTap: () => _onAppBarTap(context),
//         child: Row(
//           children: [
//
//             if (_localPhotoWidget != null)
//               SizedBox(
//                 width: 40,
//                 height: 40,
//                 child: _localPhotoWidget,
//               )
//             else
//               CircleAvatar(
//                 radius: 20,
//                 backgroundColor: Colors.grey.shade200,
//                 child: const Icon(
//                   Icons.person,
//                   color: Colors.grey,
//                   size: 24,
//                 ),
//               ),
//
//             const SizedBox(width: 12),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   _displayName ?? 'User',
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 Text(
//                   _displayEmail ?? '',
//                   style: const TextStyle(
//                     color: Colors.white70,
//                     fontSize: 12,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//       actions: [
//         IconButton(
//           onPressed: () {
//             AuthController.clearUserData();
//             ImageStorage.deleteUserPhoto();
//             Navigator.pushNamedAndRemoveUntil(
//               context,
//               '/Login',
//                   (route) => false,
//             );
//           },
//           icon: const Icon(Icons.logout, color: Colors.white),
//         ),
//       ],
//     );
//   }
// }

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/providers/auth_provider.dart';
import 'package:task_manager/ui/controller/auth_controller.dart';

import '../screens/update_profile_screen.dart';
class TMAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TMAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userModel = authProvider.userModel;

    final profilePhoto = userModel?.photo ?? '';
    return AppBar(
      backgroundColor: Colors.green,
      title: InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>UpdateProfileScreen()));
        },
        child: Row(
          children: [

            CircleAvatar(
              child: profilePhoto.isNotEmpty ? Image.memory(jsonDecode(profilePhoto)) : Icon(Icons.person),
            ),
            SizedBox(width: 8,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${userModel!.firstName} ${userModel.lastName}',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Colors.white
                  ),
                ),

                Text(userModel.email,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white
                  ),
                )
              ],
            )
          ],
        ),
      ),
      actions: [
        IconButton(onPressed: (){
          authProvider.logout();
          Navigator.pushNamedAndRemoveUntil(context, '/Login', (predicate)=>false);
        }, icon: Icon(Icons.logout))
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize =>Size.fromHeight(kToolbarHeight);
}