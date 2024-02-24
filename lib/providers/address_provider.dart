import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:address/model/address.dart';

class AddressListNotifier extends StateNotifier<List<Address>> {
  AddressListNotifier() : super([]);

  Future<bool> getaddresses() async {
    final String baseUrl = dotenv.get('BASE_URL');

    Uri url = Uri.parse('$baseUrl/account/address/get-all');

    final response = await http.get(url);

    if (response.statusCode != 200) {
      return false;
    }

    final listData = json.decode(response.body);

    final List<Address> addressList = (listData['result'] as Iterable)
        .map((address) => Address.fromJson(address))
        .toList();
    state = addressList;

    return false;
  }
}

final addressProvider =
    StateNotifierProvider<AddressListNotifier, List<Address>>((ref) {
  return AddressListNotifier();
});
