import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tripto_driver/utils/constants/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class TrainingTutorialsScreen extends StatelessWidget {

  final List<TutorialVideo> tutorials = [
    TutorialVideo(
      title: "Getting Started with Driver App",
      youtubeUrl: "https://youtube.com/shorts/IHBTnW-kM_g?si=CMMA_5o0MwuQogXw",
      description: "Complete guide to setting up your driver profile",
      thumbnail: "https://market-resized.envatousercontent.com/themeforest.net/files/258442062/Images_themeforest/01-Preview_Image.__large_preview.jpg?auto=format&q=94&cf_fit=crop&gravity=top&h=8000&w=590&s=b3fb3617062ad1e238991ee3263a2ffe11d5da2cf928fd297559a9fa2655f967",
    ),
    TutorialVideo(
      title: "How to Accept Rides",
      youtubeUrl: "https://youtu.be/2wR0OhR5Kp8",
      description: "Step-by-step process for accepting ride requests",
      thumbnail: "https://img.youtube.com/vi/2wR0OhR5Kp8/0.jpg",
    ),
    TutorialVideo(
      title: "Navigation Tips for Drivers",
      youtubeUrl: "https://youtu.be/7iX2TQf3N7k",
      description: "Master the in-app navigation system",
      thumbnail: "https://img.youtube.com/vi/7iX2TQf3N7k/0.jpg",
    ),
    TutorialVideo(
      title: "Maximizing Your Earnings",
      youtubeUrl: "https://youtu.be/V1aV1o1aJ6w",
      description: "Strategies to increase your daily profits",
      thumbnail: "https://img.youtube.com/vi/V1aV1o1aJ6w/0.jpg",
    ),
    TutorialVideo(
      title: "Safety Features Guide",
      youtubeUrl: "https://youtu.be/9PcG1kXjWtE",
      description: "How to use all safety features effectively",
      thumbnail: "https://img.youtube.com/vi/9PcG1kXjWtE/0.jpg",
    ),
    TutorialVideo(
      title: "Customer Service Best Practices",
      youtubeUrl: "https://youtu.be/3sR3B5FbqyE",
      description: "Provide excellent service to your passengers",
      thumbnail: "https://img.youtube.com/vi/3sR3B5FbqyE/0.jpg",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Training & Tutorials",
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.blue900,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.blue900, AppColors.black700],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFFF8F9FA)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Learn how to use the app effectively",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: tutorials.length,
                  itemBuilder: (context, index) {
                    return _buildTutorialCard(tutorials[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTutorialCard(TutorialVideo tutorial) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _launchYouTubeVideo(tutorial.youtubeUrl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // YouTube Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                tutorial.thumbnail,
                height: 180,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 180,
                    color: Colors.grey[200],
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 180,
                    color: Colors.grey[200],
                    child: Center(
                      child: Icon(Icons.error, color: Colors.red),
                    ),
                  );
                },
              ),
            ),
            // Video Info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tutorial.title,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    tutorial.description,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () => _launchYouTubeVideo(tutorial.youtubeUrl),
                    icon: Icon(Icons.play_arrow, size: 20,color: Colors.white,),
                    label: Text("Watch Now",style: TextStyle(color: Colors.white),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blue900,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchYouTubeVideo(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
    } else {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text("Could not launch YouTube"),
      //     backgroundColor: Colors.red,
      //   ),
      // );
    }
  }
}

class TutorialVideo {
  final String title;
  final String youtubeUrl;
  final String description;
  final String thumbnail;

  TutorialVideo({
  required this.title,
  required this.youtubeUrl,
  required this.description,
  required this.thumbnail,
  });
}
