import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:address/model/address.dart';
import 'package:address/providers/address_provider.dart';
import 'package:address/screens/address_form.dart';

class AddressWidget extends ConsumerWidget {
  const AddressWidget(
    this.address, {
    super.key,
  });

  final Address address;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(
          builder: (context) => AddressForm(
            address: address,
          ),
        ))
            .then((value) {
          ref.read(addressProvider.notifier).getaddresses();
        });
      },
      child: Card(
        color: theme.colorScheme.secondaryContainer,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(address.name),
                  InkWell(
                    onTap: () async {
                      final String baseUrl = dotenv.get('BASE_URL');

                      final url = Uri.parse(
                          '$baseUrl/account/address/delete/${address.id}');

                      final response = await http.delete(url);

                      if (response.statusCode == 200) {
                        ref.read(addressProvider.notifier).getaddresses();
                      }
                    },
                    child: Icon(
                      Icons.delete_outline,
                      color: theme.colorScheme.error,
                      size: 20,
                    ),
                  ),
                ],
              ),
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
