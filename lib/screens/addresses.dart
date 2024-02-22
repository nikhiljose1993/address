import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:address/model/address.dart';
import 'package:address/widgets/address.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() {
    return AddressScreenState();
  }
}

class AddressScreenState extends State<AddressScreen> {
  List<Address> _addressList = [];

  bool _loader = true;

  void _getaddresses() async {
    Uri url = Uri.parse('http://10.0.2.2:3000/account/address/get-all');

    final response = await http.get(url);

    final List<Map<String, dynamic>> listData =
        json.decode(response.body).cast<Map<String, dynamic>>();

    print(listData);

    final List<Address> addressList = listData
        .map((Map address) => Address(
            name: address['name'],
            address1: address['address_1'],
            address2: address['address_2'],
            zipCode: address['zip_code'],
            state: address['state'],
            country: address['country']))
        .toList();

    setState(() {
      _loader = false;
      _addressList = addressList;
    });

    print(_addressList);
  }

  @override
  void initState() {
    super.initState();
    _getaddresses();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Addresses'),
        foregroundColor: theme.colorScheme.onPrimary,
        backgroundColor: theme.colorScheme.primary,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(
          Icons.add,
          size: 36,
        ),
      ),
      body: FutureBuilder(future : , builder: builder),
      // body: Column(
      //   children: [
      //     if (_loader) const CircularProgressIndicator(),
      //     if (_addressList.isEmpty)
      //       const Center(
      //         child: Text('No address added'),
      //       ),
      //     Expanded(
      //       child: ListView.builder(
      //         itemCount: _addressList.length,
      //         itemBuilder: (ctx, index) => AddressWidget(
      //           _addressList[index],
      //         ),
      //       ),
      //     )
      //   ],
      // ),
    );
  }
}
