import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tripto_driver/utils/app_sizes/sizes.dart';
import 'package:tripto_driver/utils/constants/colors.dart';
import 'package:tripto_driver/view_model/provider/from_provider/from_provider.dart';

class VehicleRc extends StatelessWidget {
  const VehicleRc({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FromProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicle RC'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.help_outline, color: Colors.white), onPressed: () {})
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUploadSection('Front side of your RC',"*", true, provider),
            const SizedBox(height: 16),
            _buildUploadSection('Back side of your RC',"*", false, provider),
            const SizedBox(height: 16),
            _buildSubmitButton(provider, context),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadSection(String title,String important ,bool isFront, FromProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: 5,),
            Text(important,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.red),)
          ],
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => provider.pickRcImage(isFront),
          child: Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.blue900, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: (isFront ? provider.frontRcImage : provider.backRcImage) == null
                ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cloud_upload, color: Colors.grey, size: 40),
                  Text('Upload Photo', style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
                : ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                isFront ? provider.frontRcImage! : provider.backRcImage!,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(FromProvider provider, BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          var check = await provider.checkRcFeald();
          if(check){
            Fluttertoast.showToast(msg: 'hello');
          }
        },
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
        ),
        child:  const Text('Submit', style: TextStyle(color: Colors.white, fontSize:  AppSizes.buttomTextSize),
            ),
        );
    }
}
