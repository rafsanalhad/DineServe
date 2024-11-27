import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../controller/AuthController.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
class ProfilePage extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfilePage> {
  bool pushNotifications = true;
  bool faceID = true;
  int _selectedIndex = 2; 
  final AuthController _authController = Get.find();
  late String username = '';
  late String email = '';
  late String profilePicture = 'default.jpg';
  final baseUrl = dotenv.env['BASE_URL'] ?? '';

  @override
  void initState() {
    super.initState();
    _getProfile();
  }

  Future<void> _getProfile() async {
    final response = await http.get(
      Uri.parse(
          baseUrl + '/profil?user_id=${_authController.username.value}'),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        username = data['username'];
        email = data['email'];

        if (data['profile_picture'] == null) {
          profilePicture = 'default.jpg';
        } else {
          profilePicture = data['profile_picture'];
        }
      });
    } else {
      print("Failed to load profile: ${response.body}");
    }
  }

  Future<void> _updateProfile() async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(baseUrl + '/profil/update'),
    );

    request.fields['user_id'] = _authController.username.value;
    request.fields['username'] = username; 
    request.fields['email'] = email; 
    request.fields['password'] = ''; 

    var response = await request.send();
    if (response.statusCode == 200) {
      print("Profile updated successfully!");
      Navigator.pushNamed(context, '/profile');
      await _getProfile();
      Get.snackbar(
        'Success',
        'Profile updated successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      print("Failed to update profile: ${response.statusCode}");
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        Navigator.pushNamed(context, '/history');
        break;
      case 2:
        Navigator.pushNamed(context, '/profil');
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(
                            baseUrl + '/uploads/$profilePicture'),
                      ),
                      SizedBox(height: 8),
                      Text(
                        username,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        email,
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/editProfile');
                        },
                        child: Text('Edit profile'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  'Inventories',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                ListTile(
                  leading: Icon(Icons.store),
                  title: Text('My Reservation'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.green,
                        radius: 12,
                        child: Text('2',
                            style:
                                TextStyle(color: Colors.white, fontSize: 12)),
                      ),
                      Icon(Icons.chevron_right),
                    ],
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/history');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.support_agent),
                  title: Text('Support'),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {
                  },
                ),
                SizedBox(height: 24),
                Text(
                  'Preferences',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SwitchListTile(
                  title: Text('Push notifications'),
                  value: pushNotifications,
                  onChanged: (bool value) {
                    setState(() {
                      pushNotifications = value;
                    });
                  },
                ),
                SwitchListTile(
                  title: Text('Face ID'),
                  value: faceID,
                  onChanged: (bool value) {
                    setState(() {
                      faceID = value;
                    });
                  },
                ),
                ListTile(
                  title: Text('Reset Password'),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {
                  },
                ),
                SizedBox(height: 16),
                ListTile(
                  leading: Icon(Icons.logout, color: Colors.red),
                  title: Text('Logout', style: TextStyle(color: Colors.red)),
                  onTap: () {
                    Navigator.pushNamed(context, '/login');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        selectedItemColor: const Color(0xFF18654A),
        unselectedItemColor: const Color(0xFF18654A),
        onTap: _onItemTapped,
      ),
    );
  }
}
