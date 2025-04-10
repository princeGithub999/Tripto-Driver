import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripto_driver/utils/constants/colors.dart';
import '../../view_model/provider/history_provider/my_ride_history_provider.dart';

class RideHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => RideHistoryProvider(),
        child: Scaffold(
            appBar: AppBar(
              title: const Text(
                "Ride History",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              centerTitle: true,
              elevation: 5,
              iconTheme: IconThemeData(color: Colors.white),
            ),
            body: Consumer<RideHistoryProvider>(
              builder: (context, rideHistoryProvider, child) {
                if (rideHistoryProvider.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }

                if (rideHistoryProvider.errorMessage.isNotEmpty) {
                  return Center(
                    child: Text(
                      "Error: ${rideHistoryProvider.errorMessage}",
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                }

                if (rideHistoryProvider.rides.isEmpty) {
                  return Center(
                    child: Text(
                      "No Ride History Found",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.all(12),
                  itemCount: rideHistoryProvider.rides.length,
                  itemBuilder: (context, index) {
                    var trip = rideHistoryProvider.rides[index];

                    // ✅ Properly handle date & time formatting
                    DateTime createdAt;
                    if (trip['createdAt'] != null) {
                      createdAt = DateTime.parse(trip['createdAt']);
                    } else {
                      createdAt = DateTime.now();
                    }

                    // String formattedDate = DateFormat('dd MMM yyyy, hh:mm a').format(createdAt);

                    // return Card(
                    //    color:trip['status'] == "accept" ? AppColors.blue900 : AppColors.blue900 ,
                    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    //   elevation: 3,
                    //   margin: EdgeInsets.symmetric(vertical: 8),
                    //   child: ListTile(
                    //     contentPadding: EdgeInsets.all(15),
                    //     leading: Icon(Icons.local_taxi, color: Colors.white, size: 30),
                    //     title: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Text("username: ${trip['userName']}", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.white)),
                    //         Text("From: ${trip['pickUpAddress']}", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.white)),
                    //         Text("To: ${trip['dropAddress']}", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.white
                    //         )),
                    //       ],
                    //     ),
                    //     subtitle: Text("Date: $formattedDate", style: TextStyle(color: Colors.white)),
                    //     trailing: Chip(
                    //       label: Text(
                    //         trip['status'].toUpperCase(),
                    //         style: TextStyle(color: Colors.white),
                    //       ),
                    //       backgroundColor: trip['status'] == "accept" ? Colors.green : Colors.red,
                    //     ),
                    //   ),
                    // );
                    return Card(
                      color: trip['status'] == "accept" ? AppColors.blue900 : AppColors.blue900,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      elevation: 3,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(15),
                        leading: Icon(Icons.local_taxi, color: Colors.white, size: 30),
                        title: Text(
                          "Name: ${trip['userName']}",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
                          overflow: TextOverflow.ellipsis, // Ensures text stays on one line
                          maxLines: 1, // Restrict to one line
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("From: ${trip['pickUpAddress']}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
                            Text("To: ${trip['dropAddress']}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
                            // Text("Date: $formattedDate", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white,)),
                          ],
                        ),
                        trailing: Chip(
                          label: Text(
                            trip['status'].toUpperCase(),
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: trip['status'] == "accept" ? Colors.green : Colors.red,
                        ),
                      ),
                    );

                  },
                );
              },
            ),
            ),
    );
    }
}