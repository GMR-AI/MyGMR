import 'package:flutter/material.dart';
import 'package:my_gmr/globals.dart';
import 'user_class.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UserProfile extends StatefulWidget {
  final MyUser user;

  UserProfile({required this.user});

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final String pageTitle = 'Profile';
  late TextEditingController _nameController;
  late TextEditingController _mailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _mailController = TextEditingController(text: widget.user.mail);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            globalRobot = null;
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50.0,
                backgroundColor: Colors.transparent,
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: widget.user.imagePath ?? '',
                    placeholder: (context, url) => const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                    fit: BoxFit.cover,
                    width: 100.0,
                    height: 100.0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Center(
              child: Text(
                widget.user.name ?? 'No Name',
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.email, color: Colors.grey),
              title: Text(
                widget.user.mail ?? 'No Email',
                style: const TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
