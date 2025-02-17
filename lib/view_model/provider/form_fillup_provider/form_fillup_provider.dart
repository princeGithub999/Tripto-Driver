import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../view/screen/profile_details_screen/aadhaar_pan_details.dart';
import '../../../view/screen/profile_details_screen/driving_licence_details.dart';
import '../../../view/screen/profile_details_screen/profile_screen.dart';
import '../../../view/screen/profile_details_screen/vehicle_rc.dart';

class FormFillupProvider with ChangeNotifier {

  // profile //

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


  Future<void> pickProfileImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      _profileImage = File(pickedFile.path);
      notifyListeners();
    }
  }



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
    return _profileImage != null && _name.isNotEmpty && _mobile.isNotEmpty && _email.isNotEmpty;
  }

  Future<void> submitProfile() async {
    if (!isFormComplete) {
      print("Please fill all required fields");
      return;
    }

    try {
      String? imageUrl;
      if (_profileImage != null) {
        Reference storageRef = FirebaseStorage.instance.ref().child('profile_images/${_mobile}.jpg');
        UploadTask uploadTask = storageRef.putFile(_profileImage!);
        TaskSnapshot taskSnapshot = await uploadTask;
        imageUrl = await taskSnapshot.ref.getDownloadURL();
      }

      await FirebaseFirestore.instance.collection('drivers').doc(_mobile).set({
        'name': _name, 'mobile': _mobile, 'email': _email, 'address': _address, 'dob': _dob,
        'bankName': _bankName, 'accountNumber': _accountNumber, 'ifsc': _ifsc, 'upi': _upi,
        'profileImage': imageUrl ?? '', 'updatedAt': FieldValue.serverTimestamp(),
      });

      print("Profile successfully updated!");
    } catch (e) {
      print("Error updating profile: $e");
    }
  }

  //profile work end //

  String _selectedDocument = "Driving License";
  File? _frontImage;
  File? _backImage;
  String? _frontImageUrl;
  String? _backImageUrl;
  File? _aadharFrontImage, _aadharBackImage, _panImage;
  String? _aadharFrontImageUrl, _aadharBackImageUrl, _panImageUrl;

  final TextEditingController _aadharController = TextEditingController();
  final TextEditingController _panController = TextEditingController();
  final TextEditingController _licenseController = TextEditingController();


  String get selectedDocument => _selectedDocument;

  File? get frontImage => _frontImage;
  File? get backImage => _backImage;

  File? get aadharFrontImage => _aadharFrontImage;
  File? get aadharBackImage => _aadharBackImage;
  File? get panImage => _panImage;

  String? get aadharFrontImageUrl => _aadharFrontImageUrl;
  String? get aadharBackImageUrl => _aadharBackImageUrl;
  String? get panImageUrl => _panImageUrl;

  String? get frontImageUrl => _frontImageUrl;
  String? get backImageUrl => _backImageUrl;

  TextEditingController get licenseController => _licenseController;
  TextEditingController get aadharController => _aadharController;
  TextEditingController get panController => _panController;

  // Future<void> pickImage(bool isFront) async {
  //   final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     if (isFront) {
  //       _frontImage = File(pickedFile.path);
  //     } else {
  //       _backImage = File(pickedFile.path);
  //     }
  //     notifyListeners();
  //   }
  // }

  // adhar pan //
  Future<String?> uploadFileToFirebase(File image, String fileName) async {
    try {
      Reference storageRef = FirebaseStorage.instance.ref().child('documents/$fileName');
      UploadTask uploadTask = storageRef.putFile(image);
      TaskSnapshot taskSnapshot = await uploadTask;
      return await taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      print("Error uploading file: $e");
      return null;
    }
  }

  Future<void> pickAndUploadImage(bool isAadharFront, bool isAadhar) async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      String fileName = isAadhar
          ? (isAadharFront ? "aadhar_front.jpg" : "aadhar_back.jpg")
          : "pan_card.jpg";

      String? downloadUrl = await uploadFileToFirebase(imageFile, fileName);

      if (downloadUrl != null) {
        if (isAadhar) {
          if (isAadharFront) {
            _aadharFrontImage = imageFile;
            _aadharFrontImageUrl = downloadUrl;
          } else {
            _aadharBackImage = imageFile;
            _aadharBackImageUrl = downloadUrl;
          }
        } else {
          _panImage = imageFile;
          _panImageUrl = downloadUrl;
        }
        notifyListeners();
      }
    }
  }

  // rc //

  Future<void> pickRcImage(bool isFront) async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      if (isFront) {
        _frontImage = imageFile;
        _frontImageUrl = await uploadImageRcToFirebase(imageFile, 'front_rc');
      } else {
        _backImage = imageFile;
        _backImageUrl = await uploadImageRcToFirebase(imageFile, 'back_rc');
      }
      notifyListeners();
    }
  }

  Future<String?> uploadImageRcToFirebase(File image, String imageType) async {
    try {
      String filePath = 'vehicle_rc/$imageType.jpg';
      Reference storageRef = FirebaseStorage.instance.ref().child(filePath);
      await storageRef.putFile(image);
      return await storageRef.getDownloadURL();
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  Future<void> saveDriverRcDetails(String driverId) async {
    try {
      await FirebaseFirestore.instance.collection('drivers').doc(driverId).set({
        'rcFrontImage': _frontImageUrl,
        'rcBackImage': _backImageUrl,
        'uploadedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print("Error saving RC details: $e");
    }
  }


  // end rc //

  Future<void> pickImage(bool isFront) async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      if (isFront) {
        _frontImage = imageFile;
        await uploadImageRcToFirebase(imageFile, 'front_dl');
      } else {
        _backImage = imageFile;
        await uploadImageRcToFirebase(imageFile, 'back_dl');
      }
      notifyListeners();
    }
  }

  Future<void> uploadImageToFirebase(File image, String imageType) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child('drivers/license/$imageType.jpg');
      await storageRef.putFile(image);
      String downloadUrl = await storageRef.getDownloadURL();

      if (imageType == 'front_dl') {
        _frontImageUrl = downloadUrl;
      } else {
        _backImageUrl = downloadUrl;
      }
      notifyListeners();
    } catch (e) {
      print("Error uploading image: $e");
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
