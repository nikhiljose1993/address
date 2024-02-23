import 'dart:convert';
import 'package:address/model/address.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class AddressForm extends StatefulWidget {
  const AddressForm({super.key, this.address});

  final Address? address;

  @override
  State<AddressForm> createState() {
    return AddressFormState();
  }
}

class AddressFormState extends State<AddressForm> {
  final String baseUrl = dotenv.get('BASE_URL');

  final _addressForm = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _address1Controller = TextEditingController();
  final TextEditingController _address2Controller = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _pinCodeController = TextEditingController();

  bool _isEditing = false;

  String _name = '',
      _addressLine1 = '',
      _addressLine2 = '',
      _state = '',
      _country = '';

  late int _pinCode;

  @override
  void dispose() {
    _nameController.dispose();
    _address1Controller.dispose();
    _address2Controller.dispose();
    _stateController.dispose();
    _countryController.dispose();
    _pinCodeController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    if (widget.address != null) {
      _nameController.text = widget.address!.name;
      _address1Controller.text = widget.address!.address1;
      _address2Controller.text = widget.address!.address2 ?? '';
      _stateController.text = widget.address!.state;
      _countryController.text = widget.address!.country;
      _pinCodeController.text = widget.address!.zipCode.toString();
      _isEditing = true;
    }
    super.initState();
  }

  void _submit() async {
    final header = <String, String>{
      'Content-Type': 'application/json',
    };

    final isValid = _addressForm.currentState!.validate();
    late http.Response response;

    if (!isValid) {
      return;
      // err
    }

    _addressForm.currentState!.save();

    if (_isEditing) {
      final url = Uri.parse('$baseUrl/account/address/update');

      final Map<String, dynamic> address = {
        "id": widget.address?.id,
        "name": _name,
        "address1": _addressLine1,
        "address2": _addressLine2,
        "zipCode": "$_pinCode",
        "state": _state,
        "country": _country,
      };

      final jsonAddress = json.encode(address);
      response = await http.put(url, headers: header, body: jsonAddress);
    } else {
      final url = Uri.parse('$baseUrl/account/address/add');

      final Map<String, dynamic> address = {
        "name": _name,
        "address1": _addressLine1,
        "address2": _addressLine2,
        "zipCode": "$_pinCode",
        "state": _state,
        "country": _country
      };

      final jsonAddress = json.encode(address);
      response = await http.post(url, headers: header, body: jsonAddress);
    }

    if (response.statusCode == 201) {
      _addressForm.currentState!.reset();
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    const inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    );

    return Scaffold(
      backgroundColor: theme.colorScheme.secondaryContainer,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(_isEditing ? 'Edit Address' : 'Add address'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        // actions: [
        //   if (_isEditing)
        //     IconButton(
        //       onPressed: () {},
        //       icon: const Icon(Icons.delete),
        //     )
        // ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(10),
          child: Form(
            key: _addressForm,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                      labelText: 'Name',
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      border: inputBorder),
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.trim().length < 2) {
                      return "Name shouldbe more than two letters";
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    setState(() {
                      _name = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _address1Controller,
                  decoration: const InputDecoration(
                      labelText: 'Address Line 1',
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      border: inputBorder),
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.trim().length < 2) {
                      return "Enter an address";
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    setState(() {
                      _addressLine1 = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _address2Controller,
                  decoration: const InputDecoration(
                      labelText: 'Address Line 2',
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      border: inputBorder),
                  textCapitalization: TextCapitalization.words,
                  onSaved: (newValue) {
                    if (newValue != null) {
                      setState(() {
                        _addressLine2 = newValue.trim();
                      });
                    }
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _stateController,
                        decoration: const InputDecoration(
                            labelText: 'State',
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8),
                            border: inputBorder),
                        textCapitalization: TextCapitalization.words,
                        validator: (value) {
                          if (value == null || value.trim().length < 2) {
                            return "State should be more than two letters";
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          setState(() {
                            _state = newValue!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _countryController,
                        decoration: const InputDecoration(
                            labelText: 'Country',
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            border: inputBorder),
                        textCapitalization: TextCapitalization.words,
                        validator: (value) {
                          if (value == null || value.trim().length < 2) {
                            return "Country should be more than two letters";
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          setState(() {
                            _country = newValue!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 80,
                      child: TextFormField(
                        controller: _pinCodeController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Pincode',
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          border: inputBorder,
                        ),
                        validator: (value) {
                          if (value == null) {
                            return "Pincode needed";
                          }

                          var pinCode = int.tryParse(value.trim());

                          if (pinCode == null ||
                              pinCode.toString().length != 6) {
                            return "Pincode should be 6 Numbers";
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          setState(() {
                            _pinCode = int.parse(newValue!);
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: _submit,
                      icon: const Icon(Icons.save),
                      label: const Text('Save'),
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor: theme.colorScheme.primaryContainer),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
