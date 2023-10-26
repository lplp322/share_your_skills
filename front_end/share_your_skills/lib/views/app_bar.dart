import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:share_your_skills/views/add_event_page.dart';
import 'package:share_your_skills/views/chat_page.dart';
import 'package:share_your_skills/views/event_page.dart';
import 'package:share_your_skills/views/home_page.dart';
import 'package:share_your_skills/views/profile_page.dart';
import 'package:share_your_skills/models/app_state.dart';

class AppBar extends StatefulWidget {
  final token;
  const AppBar({@required this.token, super.key});

  @override
  State<AppBar> createState() => _AppBarState();
}

class _AppBarState extends State<AppBar> {
  late String userId;
  late String? userName;

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    userId = jwtDecodedToken['_id'];
    userName = jwtDecodedToken['name'];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
            body: Center(
              child: Consumer<AppState>(
                builder: (context, appState, _) {
                  // Use the selected index to determine the body widget
                  Widget selectedPage = _buildPage(appState.selectedIndex);
        
                  return selectedPage;
                },
              ),
            ),
            bottomNavigationBar: Consumer<AppState>(
              builder: (context, appState, _) {
                return BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  currentIndex: appState.selectedIndex,
                  onTap: (int newIndex) {
                    // Use the provided callback to update the state of the app
                    setState(() {
                      appState.selectedIndex = newIndex;
                    });
                  },
                  selectedItemColor: Colors.green, // Color for selected item
                  unselectedItemColor: Colors.grey, // Color for unselected items
                  items: const [
                    BottomNavigationBarItem(
                      label: 'My Posts',
                      icon: Icon(Icons.event),
                    ),
                    BottomNavigationBarItem(
                      label: 'Add Posts',
                      icon: Icon(Icons.add),
                    ),
                    BottomNavigationBarItem(
                      label: 'Home',
                      icon: Icon(Icons.home_filled),
                    ),
                    BottomNavigationBarItem(
                      label: 'Chat',
                      icon: Icon(Icons.chat_bubble),
                    ),
                    BottomNavigationBarItem(
                      label: 'Profile',
                      icon: Icon(Icons.person),
                    ),
                  ],
                );
              },
            ),
          ),
        
    );
  }

  Widget _buildPage(int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        return EventPage(
     
        );
      case 1:
        return AddEventPage(
   
        );
      case 2:
        return HomePage();
      case 3:
        return ChatPage();
      case 4:
        return ProfilePage();
      default:
        return EventPage();
    }
  }
}
