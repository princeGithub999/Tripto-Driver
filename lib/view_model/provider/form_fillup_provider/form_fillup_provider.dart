import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../view/screen/profile_details_screen/aadhaar_pan_details.dart';
import '../../../view/screen/profile_details_screen/driving_licence_details.dart';
import '../../../view/screen/profile_details_screen/profile_screen.dart';
import '../../../view/screen/profile_details_screen/vehicle_rc.dart';

class FormFillupProvider with ChangeNotifier {
  File? _profileImage;
  String _name = '';
  String _mobile = '';
  String _email = '';
  String _address = '';
  String _dob = '';
  String _bankName = '';
  String _accountNumber = '';
  String _ifsc = '';
  String _upi = '';

  // Getters
  File? get profileImage => _profileImage;
  String get name => _name;
  String get mobile => _mobile;
  String get email => _email;
  String get address => _address;
  String get dob => _dob;
  String get bankName => _bankName;
  String get accountNumber => _accountNumber;
  String get ifsc => _ifsc;
  String get upi => _upi;

  // Image Picker
  Future<void> pickProfileImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      _profileImage = File(pickedFile.path);
      notifyListeners();
    }
  }

  // Setters
  void updateName(String value) {
    _name = value;
    notifyListeners();
  }

  void updateMobile(String value) {
    _mobile = value;
    notifyListeners();
  }

  void updateEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void updateAddress(String value) {
    _address = value;
    notifyListeners();
  }

  void updateDob(String value) {
    _dob = value;
    notifyListeners();
  }

  void updateBankName(String value) {
    _bankName = value;
    notifyListeners();
  }

  void updateAccountNumber(String value) {
    _accountNumber = value;
    notifyListeners();
  }

  void updateIfsc(String value) {
    _ifsc = value;
    notifyListeners();
  }

  void updateUpi(String value) {
    _upi = value;
    notifyListeners();
  }

  bool get isFormComplete {
    return _profileImage != null &&
        _name.isNotEmpty &&
        _mobile.isNotEmpty &&
        _email.isNotEmpty &&
        _address.isNotEmpty &&
        _dob.isNotEmpty &&
        _bankName.isNotEmpty &&
        _accountNumber.isNotEmpty &&
        _ifsc.isNotEmpty;
  }

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

  Future<void> pickAadharImage(bool isAadharFront, bool isAadhar) async {
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

  bool get isDocumentFormComplete =>
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  ProfileUpdate()),
        );
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
