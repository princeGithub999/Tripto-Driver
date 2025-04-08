import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tripto_driver/utils/helpers/helper_functions.dart';
import '../../../view/screen/profile_details_screen/aadhaar_pan_details.dart';
import '../../../view/screen/profile_details_screen/driving_licence_details.dart';
import '../../../view/screen/profile_details_screen/profile_screen.dart';
import '../../../view/screen/profile_details_screen/vehicle_rc.dart';

class FromProvider extends ChangeNotifier{

  String? selectedCar;
  File? carImage;
  List<String> carList = ['Auto', 'E-Rickshaw', 'Bike'];

  void selectCar(String car) {
    selectedCar = car;
    notifyListeners();
  }



  Future<void> pickSingleRcImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      carImage = File(pickedFile.path);
      notifyListeners();
    }
    }


  TextEditingController dlNumberContro = TextEditingController();
  TextEditingController driverName = TextEditingController();
  TextEditingController driverPhone = TextEditingController();
  TextEditingController driverEmail = TextEditingController();
  TextEditingController driverAddress = TextEditingController();
  TextEditingController driverDateOfBirth = TextEditingController();
  TextEditingController driverBankName = TextEditingController();
  TextEditingController driverAccountNumber = TextEditingController();
  TextEditingController driverIFSCCode = TextEditingController();
  TextEditingController driverUPIID = TextEditingController();
  TextEditingController vehiclesNumber = TextEditingController();



  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey2 = GlobalKey<FormState>();

  String selectedDocument = "Driving License";
  File? frontDrivingLicenceImage;
  File? backDrivingLicenceImage;
  File? frontRcImage;
  File? backRcImage;
  File? frontAadharCardImage;
  File? backAadharCardImage;
  File? penCardImage;
  File? driverImage;


  String? errorMessage;


  void setErrorMessage(String? message) {
    errorMessage = message;
    notifyListeners();
  }

  Future<void> pickDrivingLicenceImage(bool isFront)async{

    var drivingLicence = await ImagePicker().pickImage(source: ImageSource.gallery);

    if(drivingLicence != null){
      if(isFront){
        frontDrivingLicenceImage = File(drivingLicence.path);
      }else{
        backDrivingLicenceImage = File(drivingLicence.path);
      }
    }else{
      Fluttertoast.showToast(msg: 'image uri null');
    }

    notifyListeners();
  }
  Future<bool> checkLicenceFeald() async {
    final licenceRegex = RegExp(r'^[A-Z0-9]{15}$');

    if (frontDrivingLicenceImage == null && backDrivingLicenceImage == null) {
      AppHelperFunctions.showSnackBar('Please upload both front and back images of your Driving License.');
      notifyListeners();
      return false;
    } else if (frontDrivingLicenceImage == null) {
      AppHelperFunctions.showSnackBar('Please upload the front side of your Driving License.');
      notifyListeners();
      return false;
    } else if (backDrivingLicenceImage == null) {
      AppHelperFunctions.showSnackBar('Please upload the back side of your Driving License.');
      notifyListeners();
      return false;
    } else if (dlNumberContro.text.isEmpty) {
      AppHelperFunctions.showSnackBar('Please enter your Driving License number.');
      notifyListeners();
      return false;
    } else if (!licenceRegex.hasMatch(dlNumberContro.text)) {
      // AppHelperFunctions.showSnackBar('Invalid Driving License number. It must be 15 characters (A-Z, 0-9 only).');
      notifyListeners();
      return false;
    } else {
      Navigator.pop(Get.context!);
      notifyListeners();
      return true;
    }
  }


  Future<void> pickRcImage(bool isFront)async{

    var drivingLicence = await ImagePicker().pickImage(source: ImageSource.gallery);

    if(drivingLicence != null){
      if(isFront){
        frontRcImage = File(drivingLicence.path);
      }else{
        backRcImage = File(drivingLicence.path);
      }
    }else{
      Fluttertoast.showToast(msg: 'image uri null');
    }

    notifyListeners();
  }



  Future<bool> checkRcFeald() async {

    if (frontRcImage == null && backRcImage == null) {
      AppHelperFunctions.showSnackBar('Please upload both front and back images of RC.');
      notifyListeners();
      return false;
    } else if (frontRcImage == null) {
      AppHelperFunctions.showSnackBar('Please upload the front side of your RC.');
      notifyListeners();
      return false;
    } else if (backRcImage == null) {
      AppHelperFunctions.showSnackBar('Please upload the back side of your RC.');
      notifyListeners();
      return false;
    } else {

      Navigator.pop(Get.context!);
      notifyListeners();
      return true;
    }
  }



  Future<void> pickAadharCardImage(bool isFront, isAadhar)async{

    var aadharCardImage = await ImagePicker().pickImage(source: ImageSource.gallery);


    if(aadharCardImage != null){
      if(isAadhar){
        if(isFront){
          frontAadharCardImage = File(aadharCardImage.path);
        }else{
          backAadharCardImage = File(aadharCardImage.path);
        }
      }else{
        penCardImage = File(aadharCardImage.path);
      }
    }else{
      Fluttertoast.showToast(msg: 'image uri null');
    }

    notifyListeners();

  }



  Future<bool> checkAadharCardImage() async {
    if (frontAadharCardImage == null && backAadharCardImage == null && penCardImage == null) {
      AppHelperFunctions.showSnackBar('Please upload Front, Back of Aadhar and PAN Card.');
      notifyListeners();
      return false;
    } else if (frontAadharCardImage == null) {
      AppHelperFunctions.showSnackBar('Please upload the Front side of your Aadhar Card.');
      notifyListeners();
      return false;
    } else if (backAadharCardImage == null) {
      AppHelperFunctions.showSnackBar('Please upload the Back side of your Aadhar Card.');
      notifyListeners();
      return false;
    } else if (penCardImage == null) {
      AppHelperFunctions.showSnackBar('Please upload your PAN Card.');
      notifyListeners();
      return false;
    } else {
      Navigator.pop(Get.context!);
      return true;
    }
  }



  Future<void> pickDriverImage()async{

    var image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if(image != null){
      driverImage = File(image.path);

    }else{
      Fluttertoast.showToast(msg: 'image uri null');
    }

    notifyListeners();
  }



  void selectDocument(String document, BuildContext context) {
    selectedDocument = document;
    notifyListeners();

    switch (document) {
      case "Driving License":
        AppHelperFunctions.navigateToScreen(context, DrivingLicenseDetails());
        break;

      case "Profile Info":
        AppHelperFunctions.navigateToScreen(context, ProfileUpdate());
        break;

      case "Vehicle RC":
        AppHelperFunctions.navigateToScreen(context, VehicleRc());
        break;

      case "Aadhaar/PAN card":
        AppHelperFunctions.navigateToScreen(context, AdharPanPage());
        break;
    }
  }


  Future<void> clearFeald()async{
    driverName.clear();
    driverPhone.clear();
    driverEmail.clear();
    driverAddress.clear();
    driverUPIID.clear();
    driverAccountNumber.clear();
    driverBankName.clear();
    driverIFSCCode.clear();
    dlNumberContro.clear();
    driverDateOfBirth.clear();

    frontDrivingLicenceImage = null;
    backDrivingLicenceImage = null;
    frontRcImage = null;
    backRcImage = null;
    frontAadharCardImage = null;
    backAadharCardImage = null;
    penCardImage =null;
    driverImage = null;

  }

  bool get isDocumentFormComplete =>
      (frontAadharCardImage != null &&
          backAadharCardImage != null &&
          frontRcImage != null &&
          backRcImage != null&&
          frontDrivingLicenceImage != null &&
          backDrivingLicenceImage != null &&
          dlNumberContro.text.isNotEmpty &&
          driverName.text.isNotEmpty &&
          driverPhone.text.isNotEmpty &&
          driverEmail.text.isNotEmpty &&
          driverAddress.text.isNotEmpty &&
          driverDateOfBirth.text.isNotEmpty &&
          driverBankName.text.isNotEmpty &&
          driverAccountNumber.text.isNotEmpty &&
          driverIFSCCode.text.isNotEmpty &&
          driverUPIID.text.isNotEmpty
          );

}
