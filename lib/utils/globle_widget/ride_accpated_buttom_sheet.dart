import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tripto_driver/utils/constants/colors.dart';

class RideAccpatedButtomSheet {
  bool isEnable = true;

  showRideRequestBottomSheet(BuildContext context) {
    var sizes = MediaQuery.of(context).size;

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          height: sizes.height * 0.4,
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: sizes.height * 0.1 - 70),
              Text(
                "Ride Request",
                style: GoogleFonts.aBeeZee(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              const Divider(),
              const SizedBox(height: 10),

              Row(
                children: [
                  const CircleAvatar(
                    maxRadius: 30,
                    backgroundColor: AppColors.blue900,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Prince Yadav', style: GoogleFonts.aBeeZee(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('Cash Payment', style: GoogleFonts.aBeeZee()),
                    ],
                  )
                ],
              ),

              const SizedBox(height: 10),

              const Row(
                children: [
                  Icon(Icons.pin_drop),
                  SizedBox(width: 5),
                  Text("Pickup: India Gate, Delhi", style: TextStyle(fontSize: 16)),
                ],
              ),
              const SizedBox(height: 10),

              const Row(
                children: [
                  Icon(Icons.local_fire_department_rounded),
                  SizedBox(width: 5),
                  Text("Drop: Connaught Place, Delhi", style: TextStyle(fontSize: 16)),
                ],
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.snackbar("Ride Accepted", "You have accepted the ride!");
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      child: const Text("Reject", style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 10), // Space between buttons
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.snackbar("Ride Rejected", "You have rejected the ride.");
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      child: const Text("Accept", style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
