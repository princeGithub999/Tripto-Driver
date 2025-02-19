import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../view_model/provider/form_fillup_provider/form_fillup_provider.dart';

class ProfileDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<FormFillupProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Profile Details')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: profileProvider.profileImage != null
                    ? FileImage(profileProvider.profileImage!)
                    : AssetImage('assets/profile_placeholder.png') as ImageProvider,
              ),
            ),
            SizedBox(height: 20),
            buildProfileRow("Full Name", profileProvider.name),
            buildProfileRow("Email", profileProvider.email),
            buildProfileRow("Mobile", profileProvider.mobile),
            buildProfileRow("Address", profileProvider.address),
          ],
        ),
      ),
    );
  }

  Widget buildProfileRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text(value, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
