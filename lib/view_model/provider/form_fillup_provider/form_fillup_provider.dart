import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../view/screen/profile_details_screen/aadhaar_pan_details.dart';
import '../../../view/screen/profile_details_screen/driving_licence_details.dart';
import '../../../view/screen/profile_details_screen/form_fillup_screen.dart';
import '../../../view/screen/profile_details_screen/vehicle_rc.dart';

class FormFillupProvider with ChangeNotifier {
  String _selectedDocument = "Driving License";

  File? _frontImage;
  File? _backImage;

  File? _aadharFrontImage;
  File? _aadharBackImage;
  File? _panImage;

  final TextEditingController _aadharController = TextEditingController();
  final TextEditingController _panController = TextEditingController();
  final TextEditingController _licenseController = TextEditingController();

  // Getters
  String get selectedDocument => _selectedDocument;
  File? get frontImage => _frontImage;
  File? get backImage => _backImage;
  File? get aadharFrontImage => _aadharFrontImage;
  File? get aadharBackImage => _aadharBackImage;
  File? get panImage => _panImage;

  TextEditingController get licenseController => _licenseController;
  TextEditingController get aadharController => _aadharController;
  TextEditingController get panController => _panController;

  Future<void> pickImage(bool isFront) async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (isFront) {
        _frontImage = File(pickedFile.path);
      } else {
        _backImage = File(pickedFile.path);
      }
      notifyListeners();
    }
  }

  Future<void> adhaarPickImage(bool isAadharFront, bool isAadhar) async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (isAadhar) {
        if (isAadharFront) {
          _aadharFrontImage = File(pickedFile.path);
        } else {
          _aadharBackImage = File(pickedFile.path);
        }
      } else {
        _panImage = File(pickedFile.path);
      }
      notifyListeners();
    }
  }

  // Validation Getters
  bool get isAadharNumberValid {
    final input = _aadharController.text.trim();
    final regex = RegExp(r'^\d{12}$');
    return regex.hasMatch(input);
  }

  bool get isPanNumberValid {
    final input = _panController.text.trim();
    final regex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');
    return regex.hasMatch(input);
  }

  bool get isLicenseNumberValid {
    final input = _licenseController.text.trim();
    final regex = RegExp(r'^[A-Z0-9]{15}$');
    return regex.hasMatch(input);
  }

  bool get isFormComplete =>
      (_frontImage != null && _backImage != null && isLicenseNumberValid) ||
          (_aadharFrontImage != null && _aadharBackImage != null && _panImage != null && isAadharNumberValid && isPanNumberValid);

  void selectDocument(String document, BuildContext context) {
    _selectedDocument = document;
    notifyListeners();

    switch (document) {
      case "Driving License":
        Navigator.push(context, MaterialPageRoute(builder: (context) => DrivingLicenseDetails()));
        break;
      case "Profile Info":
        Navigator.push(context, MaterialPageRoute(builder: (context) => FormFillupScreen()));
        break;
      case "Vehicle RC":
        Navigator.push(context, MaterialPageRoute(builder: (context) => VehicleRc()));
        break;
      case "Aadhaar/PAN card":
        Navigator.push(context, MaterialPageRoute(builder: (context) => AdharPanPage()));
        break;
    }
  }

  @override
  void dispose() {
    _licenseController.dispose();
    _aadharController.dispose();
    _panController.dispose();
    super.dispose();
  }
}
