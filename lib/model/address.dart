class Address {
  String name;
  String address1;
  String? address2;
  int zipCode;
  String state;
  String country;

  Address({
    required this.name,
    required this.address1,
    this.address2,
    required this.zipCode,
    required this.state,
    required this.country,
  });

  Address fromJson(Map<String, dynamic> json) {
    return Address(
        name: json['name'],
        address1: json['address1'],
        zipCode: json['zipCode'],
        state: json['state'],
        country: json['country']);
  }
}
