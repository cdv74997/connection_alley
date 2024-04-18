import 'package:connection_alley/widgets/list_tile.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  final void Function()? onProfileTap;
  final void Function()? onSignOut;
  final void Function()? onFriendsTap;
  const MyDrawer({super.key, required this.onProfileTap, required this.onSignOut, required this.onFriendsTap});

  @override 
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(children: [
            // header
          const DrawerHeader(
            child: Icon(
              Icons.person,
              color: Colors.white,
              size: 64,
            ),
          ),

          // home list tile
          MyListTile(icon: Icons.home, text: 'H O M E', onTap: () => Navigator.pop(context),),

          // profile list tile
          MyListTile(icon: Icons.person, text: 'P R O F I L E', onTap: onProfileTap),

          MyListTile(icon: Icons.supervised_user_circle, text: 'F R I E N D S', onTap: onFriendsTap),
          ],),
          // logout button
          Padding(
            padding: const EdgeInsets.only(bottom: 25.0),
            child: MyListTile(icon: Icons.logout, text: 'L O G O U T', onTap: onSignOut),
          ),
        ],
      ),
    );
  }
}