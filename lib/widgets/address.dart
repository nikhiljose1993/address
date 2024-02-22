import 'package:address/model/address.dart';
import 'package:flutter/material.dart';

class AddressWidget extends StatelessWidget {
  const AddressWidget(this.address, {super.key});

  final Address address;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: theme.colorScheme.primaryContainer,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Column(children: [
        Text(address.name),
        Text(address.address1),
        if (address.address2 != null) Text(address.address2!),
        Text(
            '${address.state}, ${address.country} - ${address.zipCode.toString()}'),
      ]),
    );
  }
}
