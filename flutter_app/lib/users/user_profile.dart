import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'user_class.dart';

class UserProfile extends StatefulWidget {
  final User user;

  UserProfile({required this.user});

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  late TextEditingController _nameController;
  late TextEditingController _mailController;
  bool _isEditing = false;
  File? _image;

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

  Future<void> _getImage() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void _saveProfile() {
    setState(() {
      widget.user.name = _nameController.text;
      widget.user.mail = _mailController.text;
      if (_image != null) {
        widget.user.imagePath = _image!.path;
      }
      _isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          if (!_isEditing)
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: _isEditing ? _getImage : null,
                child: CircleAvatar(
                  radius: 50.0,
                  backgroundImage: _image != null
                      ? FileImage(_image!)
                      : AssetImage(widget.user.imagePath ?? 'assets/default_image.png') as ImageProvider,
                ),
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
            if (_isEditing)
              Center(
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  child: Text('Save'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
