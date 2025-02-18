class ProfileModel {
  final String name;
  final String mobile;
  final String email;
  final String address;
  final String dob;
  final String bankName;
  final String accountNumber;
  final String ifsc;
  final String upi;
  final String? profileImage;

  ProfileModel({
    required this.name,
    required this.mobile,
    required this.email,
    required this.address,
    required this.dob,
    required this.bankName,
    required this.accountNumber,
    required this.ifsc,
    required this.upi,
    this.profileImage,
  });

  ProfileModel copyWith({
    String? name,
    String? mobile,
    String? email,
    String? address,
    String? dob,
    String? bankName,
    String? accountNumber,
    String? ifsc,
    String? upi,
    String? profileImage,
  }) {
    return ProfileModel(
      name: name ?? this.name,
      mobile: mobile ?? this.mobile,
      email: email ?? this.email,
      address: address ?? this.address,
      dob: dob ?? this.dob,
      bankName: bankName ?? this.bankName,
      accountNumber: accountNumber ?? this.accountNumber,
      ifsc: ifsc ?? this.ifsc,
      upi: upi ?? this.upi,
      profileImage: profileImage ?? this.profileImage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'mobile': mobile,
      'email': email,
      'address': address,
      'dob': dob,
      'bankName': bankName,
      'accountNumber': accountNumber,
      'ifsc': ifsc,
      'upi': upi,
      'profileImage': profileImage,
    };
  }
}
