import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _profileImage;
  String _name = "Suraj Kumar";
  String _phone = "8651204362";
  bool _isOnline = true;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
        ...children,
        Divider(height: 1),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              padding: EdgeInsets.only(top: 50, bottom: 16, left: 16, right: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blueAccent, Colors.teal],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Header
                  Row(
                    children: [
                      GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white,
                          backgroundImage: _profileImage != null
                              ? FileImage(_profileImage!)
                              : null,
                          child: _profileImage == null
                              ? Icon(Icons.person, size: 40, color: Colors.grey)
                              : null,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Row(
                              children: [
                                Text(_name,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.white),
                                  onPressed: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditProfileScreen(
                                          name: _name,
                                          phone: _phone,
                                        ),
                                      ),
                                    );
                                    if (result != null) {
                                      setState(() {
                                        _name = result['name'] ?? _name;
                                        _phone = result['phone'] ?? _phone;
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                            Text(_phone,
                                style: TextStyle(color: Colors.white70)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),

            // Main Content
            _buildSection("Vehicle Information", [
              _buildListTile(Icons.directions_car, "Vehicle Details"),
              _buildListTile(Icons.description, "Documents"),
            ]),

            _buildSection("Performance", [
              _buildListTile(Icons.star_rate, "Ratings & Feedback"),
              _buildListTile(Icons.attach_money, "Earnings Summary"),
            ]),

            _buildSection("Account & Payments", [
              _buildListTile(Icons.account_balance_wallet, "Bank Details"),
              _buildListTile(Icons.history, "Payment History"),
            ]),

            _buildSection("Safety", [
              _buildListTile(Icons.emergency, "Emergency Contacts"),
              _buildListTile(Icons.location_on, "Live Location Sharing"),
            ]),

            _buildSection("Preferences", [
              SwitchListTile(
                title: Text("Online Status"),
                value: _isOnline,
                onChanged: (value) => setState(() => _isOnline = value),
              ),
              _buildListTile(Icons.language, "Language Settings"),
            ]),

            _buildSection("Support", [
              _buildListTile(Icons.help, "Help Center"),
              _buildListTile(Icons.report_problem, "Report Issue"),
            ]),

            Padding(
              padding: EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                icon: Icon(Icons.logout),
                label: Text("Logout"),
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  minimumSize: Size(double.infinity, 50),

                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[600]),
      title: Text(title),
      trailing: Icon(Icons.chevron_right, color: Colors.green),
      onTap: onTap ?? () {
        switch(title) {
          case "Vehicle Details":
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => VehicleDetailsScreen()));
            break;
          case "Documents":
            break;
        }
      },
    );
  }
}
class EditProfileScreen extends StatefulWidget {
  final String name;
  final String phone;

  const EditProfileScreen({Key? key, required this.name, required this.phone})
      : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _phoneController = TextEditingController(text: widget.phone);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {
                  'name': _nameController.text,
                  'phone': _phoneController.text,
                });
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}

class VehicleDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Vehicle Details"),
        ),
        body: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                      labelText: "Vehicle Number",
                      border: OutlineInputBorder()),
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                      labelText: "Vehicle Model",
                      border: OutlineInputBorder()),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () {},
                    child: Text("Save Vehicle Details")),
              ],
            ),
            ),
        );
    }
}
