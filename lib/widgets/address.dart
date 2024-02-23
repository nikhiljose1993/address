import 'package:address/model/address.dart';
import 'package:address/screens/address_form.dart';
import 'package:flutter/material.dart';

class AddressWidget extends StatelessWidget {
  const AddressWidget(
    this.address, {
    super.key,
  });

  final Address address;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AddressForm(address: address),
          ),
        );
      },
      child: Card(
        color: theme.colorScheme.secondaryContainer,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(address.name),
              Text(address.address1),
              if (address.address2 != '') Text(address.address2!),
              Text(
                  '${address.state}, ${address.country} - ${address.zipCode.toString()}'),
            ],
          ),
        ),
      ),
    );
  }
}
