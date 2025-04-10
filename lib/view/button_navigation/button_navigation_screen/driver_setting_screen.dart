import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DriverSettingsScreen extends StatefulWidget {
  @override
  _DriverSettingsScreenState createState() => _DriverSettingsScreenState();
}

class _DriverSettingsScreenState extends State<DriverSettingsScreen> {
  // ... (keep your existing state variables)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Driver Settings'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          // ... (keep your existing widgets up to the Legal & Policy section)

          Divider(),
          _buildLegalPolicySection(),
          Divider(),
          _buildSupportHelpSection(),
        ],
      ),
    );
  }

  Widget _buildLegalPolicySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Legal & Policy',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
        ),
        _buildPolicyTile(
          icon: Icons.description,
          title: 'Terms & Conditions',
          onTap: () => _showTermsAndConditions(context),
        ),
        _buildPolicyTile(
          icon: Icons.lock,
          title: 'Privacy Policy',
          onTap: () => _showPrivacyPolicy(context),
        ),
        _buildPolicyTile(
          icon: Icons.gavel,
          title: 'Community Guidelines',
          onTap: () => _showCommunityGuidelines(context),
        ),
      ],
    );
  }

  Widget _buildSupportHelpSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Support & Help',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
        ),
        _buildSupportTile(
          icon: Icons.help_center,
          title: 'Help Center',
          onTap: () => _openHelpCenter(),
        ),
        _buildSupportTile(
          icon: Icons.contact_support,
          title: 'Contact Support',
          onTap: () => _contactSupport(),
        ),
        _buildSupportTile(
          icon: Icons.live_help,
          title: 'FAQs',
          onTap: () => _openFAQs(),
        ),
        _buildSupportTile(
          icon: Icons.report_problem,
          title: 'Report an Issue',
          onTap: () => _reportIssue(),
        ),
      ],
    );
  }

  Widget _buildPolicyTile({required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildSupportTile({required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(title),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  void _showTermsAndConditions(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text('Terms & Conditions')),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Driver Terms of Service',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text(
                  'Last Updated: January 1, 2023',
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 24),
                _buildPolicySection(
                  title: '1. Driver Requirements',
                  content:
                  'To drive with our platform, you must maintain a valid driver\'s license, vehicle registration, and insurance. Your vehicle must meet our quality standards and pass regular inspections.',
                ),
                _buildPolicySection(
                  title: '2. Service Fees',
                  content:
                  'We charge a service fee for each completed trip. This fee helps us operate the platform and provide services like customer support and app development.',
                ),
                _buildPolicySection(
                  title: '3. Cancellation Policy',
                  content:
                  'Excessive cancellations may result in penalties or account suspension. Please cancel only when absolutely necessary.',
                ),
                // Add more sections as needed
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text('Privacy Policy')),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Driver Privacy Policy',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text(
                  'Effective Date: January 1, 2023',
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 24),
                _buildPolicySection(
                  title: '1. Information We Collect',
                  content:
                  'We collect information you provide when you register, including your name, contact details, driver\'s license, and vehicle information. We also collect trip data, location data, and ratings.',
                ),
                _buildPolicySection(
                  title: '2. How We Use Your Information',
                  content:
                  'We use your information to provide our services, process payments, improve our platform, and ensure safety. We may also use it for analytics and marketing purposes.',
                ),
                _buildPolicySection(
                  title: '3. Data Sharing',
                  content:
                  'We may share your information with riders during trips, with law enforcement when required, and with service providers who assist our operations.',
                ),
                // Add more sections as needed
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCommunityGuidelines(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text('Community Guidelines')),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Driver Community Guidelines',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 24),
                _buildPolicySection(
                  title: 'Respect for All',
                  content:
                  'We expect all drivers to treat riders with respect, regardless of their background, gender, or beliefs. Discrimination of any kind will not be tolerated.',
                ),
                _buildPolicySection(
                  title: 'Professional Conduct',
                  content:
                  'Maintain professional behavior at all times. This includes proper dress, vehicle cleanliness, and appropriate conversation.',
                ),
                _buildPolicySection(
                  title: 'Safety First',
                  content:
                  'Follow all traffic laws, avoid distracted driving, and never drive under the influence. Your safety and your rider\'s safety are our top priority.',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPolicySection({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(content),
        ],
      ),
    );
  }

  Future<void> _openHelpCenter() async {
    const url = 'https://help.cabapp.com/drivers';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open help center')),
      );
    }
  }

  Future<void> _contactSupport() async {
    final result = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Contact Support'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('Call Support'),
              subtitle: Text('24/7 driver support line'),
              onTap: () {
                Navigator.pop(context, 'call');
              },
            ),
            ListTile(
              leading: Icon(Icons.email),
              title: Text('Email Support'),
              subtitle: Text('Response within 24 hours'),
              onTap: () {
                Navigator.pop(context, 'email');
              },
            ),
            ListTile(
              leading: Icon(Icons.chat),
              title: Text('Live Chat'),
              subtitle: Text('Available 6am-10pm daily'),
              onTap: () {
                Navigator.pop(context, 'chat');
              },
            ),
          ],
        ),
      ),
    );

    if (result == 'call') {
      const phone = 'tel:+91 6200725150';
      if (await canLaunch(phone)) {
        await launch(phone);
      }
    } else if (result == 'email') {
      const email = 'mailto:naushad02012002@gmail.com';
      if (await canLaunch(email)) {
        await launch(email);
      }
    } else if (result == 'chat') {
      // Implement live chat functionality
      _showLiveChat(context);
    }
  }

  void _showLiveChat(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text('Live Chat Support')),
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(16),
                  children: [
                    _buildChatMessage(
                      text: 'Hello! How can we help you today?',
                      isSupport: true,
                    ),
                    // Add more chat messages as needed
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Type your message...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatMessage({required String text, bool isSupport = false}) {
    return Align(
      alignment: isSupport ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSupport ? Colors.grey[200] : Colors.blue[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(text),
      ),
    );
  }

  Future<void> _openFAQs() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text('Frequently Asked Questions')),
          body: ListView(
            children: [
              ExpansionTile(
                title: Text('How do I get paid?'),
                children: [
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Payments are processed weekly and deposited directly to your bank account. You can track your earnings in the Earnings section of the app.',
                    ),
                  ),
                ],
              ),
              ExpansionTile(
                title: Text('What if a rider cancels?'),
                children: [
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'If a rider cancels after a certain time, you may be eligible for a cancellation fee. This will be automatically calculated and added to your earnings.',
                    ),
                  ),
                ],
              ),
              // Add more FAQs as needed
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _reportIssue() async {
    final issue = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Report an Issue'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Rider Behavior'),
              onTap: () => Navigator.pop(context, 'Rider Behavior'),
            ),
            ListTile(
              title: Text('Payment Issue'),
              onTap: () => Navigator.pop(context, 'Payment Issue'),
            ),
            ListTile(
              title: Text('App Problem'),
              onTap: () => Navigator.pop(context, 'App Problem'),
            ),
            ListTile(
              title: Text('Other'),
              onTap: () => Navigator.pop(context, 'Other'),
            ),
          ],
        ),
      ),
    );

    if (issue != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: Text('Report: $issue')),
            body: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Describe the issue',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 5,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Report submitted successfully')),
                      );
                      Navigator.pop(context);
                    },
                    child: Text('Submit Report'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }


}
