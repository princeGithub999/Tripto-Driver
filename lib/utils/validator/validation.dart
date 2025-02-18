class Validation {



  static String? validateLicence(String? value){

    if(value == null || value.isEmpty){
      return 'Licence is Required';
    }
    final licenceRegex = RegExp(r'^[A-Z0-9]{15}$');

    if(!licenceRegex.hasMatch(value)){
      return 'License number must be 15 characters (A-Z, 0-9 only)';
    }
    return null;
  }



  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is Required';
    }

    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegExp.hasMatch(value)) {
      return 'Invalid email address.';
    }

    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    final phoneRegExp = RegExp(r'^\d{10}$');

    if (!phoneRegExp.hasMatch(value)) {
      return 'Invalid phone number format (10 digit required)';
    }

    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }

    if (!RegExp(r"^[a-zA-Z ,.'-]+$").hasMatch(value)) {
      return 'Please enter a correct name';
    }

    return null;
  }


  static String? validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Address is required';
    }

    if (!RegExp(r"^[a-zA-Z ,.'-]+$").hasMatch(value)) {
      return 'Please enter a correct address';
    }

    return null;
  }

  static String? validateDateOfBirth(String? value) {
    if (value == null || value.isEmpty) {
      return 'Date of Birth is required';
    }
    // Regular expression for DD/MM/YYYY or YYYY-MM-DD format
    final RegExp dobRegex = RegExp(r"^(?:\d{2}/\d{2}/\d{4}|\d{4}-\d{2}-\d{2})$");
    if (!dobRegex.hasMatch(value)) {
      return 'Enter a valid Date of Birth (DD/MM/YYYY or YYYY-MM-DD)';
    }
    try {
      // Convert string to DateTime
      DateTime dob = DateTime.parse(value.contains('/')
          ? value.split('/').reversed.join('-')
          : value);

      DateTime today = DateTime.now();
      int age = today.year - dob.year;

      // Age check (e.g., 18+ required)
      if (dob.isAfter(today)) {
        return 'Date of Birth cannot be in the future';
      } else if (age < 18) {
        return 'You must be at least 18 years old';
      }
    } catch (e) {
      return 'Invalid Date Format';
    }

    return null;
  }

  static String? validateBankName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Bank name is required';
    }
    // Regular expression to allow only letters, spaces, dots, and hyphens
    final RegExp bankNameRegex = RegExp(r"^[a-zA-Z\s.'-]{3,50}$");

    if (!bankNameRegex.hasMatch(value)) {
      return 'Enter a valid bank name (Only letters, spaces, ., and - allowed)';
    }
    return null; // ✅ Valid bank name
  }


  static String? validateAccountNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Account number is required';
    }
    // Regular expression to allow only digits (9 to 18 characters long)
    final RegExp accountNumberRegex = RegExp(r"^\d{9,18}$");
    if (!accountNumberRegex.hasMatch(value)) {
      return 'Enter a valid account number (9 to 18 digits)';
    }
    return null; // ✅ Valid account number
  }


  static String? validateIFSC(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'IFSC code is required';
    }
    // IFSC Code Format: 4 Letters + 0 + 6 Alphanumeric (Total 11 characters)
    final RegExp ifscRegex = RegExp(r"^[A-Z]{4}0[A-Z0-9]{6}$");
    if (!ifscRegex.hasMatch(value)) {
      return 'Enter a valid IFSC code (e.g., SBIN0123456)';
    }
    return null; // ✅ Valid IFSC code
  }

  static String? validateUPI(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'UPI ID is required';
    }
    // UPI ID Format: username@bankname (username: alphanumeric + . _ ; bankname: alphabets only)
    final RegExp upiRegex = RegExp(r"^[a-zA-Z0-9._]+@[a-zA-Z]+$");
    if (!upiRegex.hasMatch(value)) {
      return 'Enter a valid UPI ID (e.g., someone@upi)';
    }
    return null; // ✅ Valid UPI ID
  }


}