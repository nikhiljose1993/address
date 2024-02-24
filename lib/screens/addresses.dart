import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:address/providers/address_provider.dart';
import 'package:address/widgets/address.dart';
import 'package:address/screens/address_form.dart';

class AddressScreen extends ConsumerStatefulWidget {
  const AddressScreen({super.key});

  @override
  ConsumerState<AddressScreen> createState() {
    return _AddressScreenState();
  }
}

class _AddressScreenState extends ConsumerState<AddressScreen> {
  bool _isLoading = true;

  Future<void> _getAddress() async {
    _isLoading = await ref.read(addressProvider.notifier).getaddresses();
  }

  @override
  void initState() {
    super.initState();
    _getAddress();
  }

  @override
  Widget build(BuildContext context) {
    final addressList = ref.watch(addressProvider);
    final theme = Theme.of(context);

    Widget content = const Center(child: Text('No address available'));

    if (_isLoading) {
      content = const Center(child: CircularProgressIndicator());
    }

    if (addressList.isNotEmpty) {
      content = Container(
        padding: const EdgeInsets.only(top: 6),
        child: ListView.builder(
          itemCount: addressList.length,
          itemBuilder: (ctx, index) => AddressWidget(
            addressList[index],
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
            _getAddress();
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
