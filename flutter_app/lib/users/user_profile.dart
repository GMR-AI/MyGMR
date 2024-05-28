import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'user_class.dart';
import '../functions/user_requests.dart';

class UserProfile extends StatefulWidget {
  final MyUser user;

  UserProfile({required this.user});

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  late TextEditingController _nameController;
  late TextEditingController _mailController;
  bool _isEditing = false;

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
        title: Text('Profile'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50.0,
                child: Image.network(widget.user.imagePath ?? ''),
              ),
            ),
            SizedBox(height: 20.0),
            Center(
              child: _isEditing
                  ? TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              )
                  : Text(
                widget.user.name ?? 'No Name',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Divider(),
            _isEditing
                ? TextFormField(
              controller: _mailController,
              decoration: InputDecoration(labelText: 'Email'),
            )
                : ListTile(
              leading: Icon(Icons.email, color: Colors.grey),
              title: Text(
                widget.user.mail ?? 'No Email',
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
