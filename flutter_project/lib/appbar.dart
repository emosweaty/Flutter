import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_project/screens/home.dart';
import 'package:flutter_project/screens/profile.dart'; 

enum MenuItem {home, add}
enum ProfileAction { profile, logout }

class Appbar extends StatelessWidget implements PreferredSizeWidget{
  const Appbar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(65);

  @override
  Widget build(BuildContext context) {
    final route = ModalRoute.of(context)?.settings.name;

    final selected  = (){
      switch (route){
        case '/home':
          return MenuItem.home;
        case '/add':
          return MenuItem.add;
        default:
          return MenuItem.home;
      }
    }();

    Widget buildIcon({
      required IconData icon,
      required MenuItem item,
      required VoidCallback ontap,
    }){
      final isSelected = selected == item;

      return InkWell(
        onTap: ontap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
              size: 30,
              color: isSelected ? const Color.fromARGB(255, 116, 220, 238) : const Color.fromARGB(255, 194, 195, 200)
            ),
            const SizedBox(height: 5),

            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 3,
              width: 24,
              decoration: BoxDecoration(
                color: isSelected ? Colors.blueAccent : Colors.transparent,
                borderRadius: BorderRadius.circular(2)
              ),
            )
          ],
        ),
      );
    }

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(
          color: Color.fromARGB(87, 0, 0, 0),
          blurRadius: 8,
        )]
      ),

      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 45),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  'BorrowBuddy',
                  style: TextStyle(
                    fontFamily: 'Dongle',
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 116, 220, 238)
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: 
                  Row(
                    children: [

                      buildIcon(
                        icon: Icons.home, 
                        item: MenuItem.home, 
                        ontap: (){
                          if (route != '/home'){
                            Navigator.pushReplacementNamed(context, '/home');
                          }
                        }
                      ),
                      
                      const SizedBox(width: 20),

                      buildIcon(
                        icon: Icons.add, 
                        item: MenuItem.add, 
                        ontap: (){
                          if (route != '/add'){
                            Navigator.pushReplacementNamed(context, '/add');
                          }
                        }
                      ),
                    ],
                  )
              ),

              StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(), 
                builder: (context, snapshot){
                  final user = snapshot.data;

                  if (user != null){
                    return PopupMenuButton<ProfileAction>(
                      icon: Icon(Icons.circle, size: 32, color: Colors.blue), 
                      offset: Offset(0, 50),
                      color: Colors.white,
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                      onSelected: (action) {
                        switch (action) {
                          case ProfileAction.profile:
                            Navigator.pushNamed(context, ProfileScreen.routeName);
                            break;
                          case ProfileAction.logout:
                            FirebaseAuth.instance.signOut();
                            Navigator.pushReplacementNamed(context, HomeScreen.routeName);
                            break;
                        }
                      },
                      itemBuilder: (ctx) => [
                        PopupMenuItem(
                          value: ProfileAction.profile,
                          child: Text('View Profile'),
                        ),
                        PopupMenuItem(
                          value: ProfileAction.logout,
                          child: Text('Sign Out'),
                        ),
                      ],
                    );
                  }

                  return ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/login'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)
                      ),
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      'Sign In',
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  );
                }
                )
            ],
          ),
        ),
      ),
    );
  }
}