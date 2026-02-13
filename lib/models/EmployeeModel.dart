class EmployeeModel {
  final String empCode;
  final String name;
  final String mobile;
  final String dob;
  final String address;
  final String remark;
  final String? avatar;

  EmployeeModel({
    required this.empCode,
    required this.name,
    required this.mobile,
    required this.dob,
    required this.address,
    required this.remark,
    this.avatar,
  });

  Map<String, dynamic> toMap() {
    return {
      'empCode': empCode,
      'name': name,
      'mobile': mobile,
      'dob': dob,
      'address': address,
      'remark': remark,
      'avatar': avatar,
    };
  }

  factory EmployeeModel.fromMap(Map<String, dynamic> map) {
    return EmployeeModel(
      empCode: map['empCode'],
      name: map['name'],
      mobile: map['mobile'],
      dob: map['dob'],
      address: map['address'],
      remark: map['remark'],
      avatar: map['avatar'],
    );
  }
}
