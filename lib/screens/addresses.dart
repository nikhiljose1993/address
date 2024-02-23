import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:address/model/address.dart';
import 'package:address/widgets/address.dart';
import 'package:address/screens/address_form.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() {
    return AddressScreenState();
  }
}

class AddressScreenState extends State<AddressScreen> {
  final String baseUrl = dotenv.get('BASE_URL');

  List<Address> _addressList = [];
  bool _isLoading = true;

  void _getaddresses() async {
    Uri url = Uri.parse('$baseUrl/account/address/get-all');

    final response = await http.get(url);

    if (response.statusCode != 200) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final listData = json.decode(response.body);

    final List<Address> addressList = (listData['result'] as Iterable)
        .map((address) => Address.fromJson(address))
        .toList();

    setState(() {
      _isLoading = false;
      _addressList = addressList;
    });
  }

  @override
  void initState() {
    super.initState();
    _getaddresses();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget content = const Center(child: Text('No address available'));

    if (_isLoading) {
      content = const Center(child: CircularProgressIndicator());
    }

    if (_addressList.isNotEmpty) {
      content = Container(
        padding: const EdgeInsets.only(top: 6),
        child: ListView.builder(
          itemCount: _addressList.length,
          itemBuilder: (ctx, index) => AddressWidget(
            _addressList[index],
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Addresses'),
        foregroundColor: theme.colorScheme.onPrimary,
        backgroundColor: theme.colorScheme.primary,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.colorScheme.primary,
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
            builder: (context) => const AddressForm(),
          ))
              .then((value) {
            _getaddresses();
          });
        },
        child: const Icon(
          Icons.add,
          size: 36,
        ),
      ),
      body: content,
    );
  }
}
