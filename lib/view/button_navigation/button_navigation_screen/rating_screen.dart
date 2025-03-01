import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  double _rating = 0;
  final TextEditingController _feedbackController = TextEditingController();
  final List<Map<String, dynamic>> _reviews = [];

  void _submitRating() {
    if (_rating == 0) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Please select a rating before submitting.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('OK'),
            )
          ],
        ),
      );
      return;
    }

    setState(() {
      _reviews.add({
        'rating': _rating,
        'feedback': _feedbackController.text,
        'date': DateTime.now().toString().substring(0, 10),
      });
      _rating = 0;
      _feedbackController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Thank you for your feedback!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rate Our App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.thumb_up_alt),
            onPressed: () {
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'How would you rate our app?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    RatingBar.builder(
                      initialRating: _rating,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        setState(() {
                          _rating = rating;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _feedbackController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Additional Feedback (optional)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: 'Tell us what you like or how we can improve...',
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.send),
                      label: const Text('Submit Review'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: _submitRating,
                    ),
                  ],
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.only(top: 20, bottom: 10),
              child: Text(
                'Recent Reviews:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _reviews.length,
                itemBuilder: (context, index) {
                  final review = _reviews.reversed.toList()[index];
                  return ReviewTile(
                    rating: review['rating'],
                    feedback: review['feedback'],
                    date: review['date'],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReviewTile extends StatelessWidget {
  final double rating;
  final String feedback;
  final String date;

  const ReviewTile({
    super.key,
    required this.rating,
    required this.feedback,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.only(bottom: 10),
        child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundColor: Colors.amber.withOpacity(0.2),
              child: Text(
                rating.toStringAsFixed(1),
                style: const TextStyle(color: Colors.amber),
              ),
            ),
            title: Text(feedback.isNotEmpty ? feedback : 'No feedback provided'),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 16),
                  Text(' $rating • $date'),
                ],
              ),
            ),
        ),
        );
    }
}
