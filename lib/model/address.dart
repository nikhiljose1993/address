class Address {
  String? id;
  String name;
  String address1;
  String? address2;
  int zipCode;
  String state;
  String country;

  Address({
    this.id,
    required this.name,
    required this.address1,
    this.address2,
    required this.zipCode,
    required this.state,
    required this.country,
  });

  static Address fromJson(address) {
    return Address(
        id: address['id'],
        name: address['name'],
        address1: address['address1'],
        address2: address['address2'],
        zipCode: address['zipCode'],
        state: address['state'],
        country: address['country']);
  }
}
