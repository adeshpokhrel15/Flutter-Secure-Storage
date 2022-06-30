import 'dart:convert';
import 'dart:developer';

import 'package:adesh/core/db_client.dart';
import 'package:adesh/data/models/adress_form.dart';
import 'package:adesh/data/models/my_form_model.dart';
import 'package:adesh/helpers/constants/string.dart';
import 'package:adesh/logic/personal_form_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddressForm extends StatefulWidget {
  const AddressForm({Key? key}) : super(key: key);

  @override
  State<AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  late TextEditingController countryController;
  late TextEditingController districtController;
  MyFormModel formModel = MyFormModel(
      name: 'Choose a person',
      address: '',
      createdAt: DateTime.now(),
      uniqueId: '');

  String uuid = '';

  @override
  void initState() {
    countryController = TextEditingController();
    districtController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    countryController.dispose();
    districtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Consumer(builder: (context, ref, child) {
            return IconButton(
                onPressed: () {
                  ref.refresh(personalControllerProvider);
                },
                icon: const Icon(Icons.refresh));
          }),
        ],
      ),
      body: Column(
        children: [
          TextField(
            controller: countryController,
            decoration: const InputDecoration(hintText: 'Enter country'),
          ),
          TextField(
            controller: districtController,
            decoration: const InputDecoration(hintText: 'Enter district'),
          ),
          Consumer(builder: (context, ref, child) {
            return ref.watch(personalControllerProvider).when(
                  data: (data) {
                    return DropdownButtonFormField<MyFormModel>(
                      items: [
                        ...data.map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(e.name),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          uuid = value!.uniqueId;
                        });
                      },
                    );

                    // return Column(
                    //   children: [
                    //     Text(data.length.toString()),
                    //     ...data.map(
                    //       (e) => Text(e.uniqueId),
                    //     ),
                    //   ],
                    // );
                  },
                  error: (err, s) => Text(err.toString()),
                  loading: () => const LinearProgressIndicator(),
                );
          }),
          Consumer(builder: (context, ref, child) {
            return ElevatedButton(
              onPressed: () async {
                final check =
                    await ref.watch(dbProvider).getData(dbKey: addressList);
                if (check == null) {
                  final AddressFormModel myFormModel = AddressFormModel(
                    country: countryController.text,
                    district: districtController.text,
                    uniqueId: uuid,
                  );
                  List<AddressFormModel> listForm = [];
                  listForm.add(myFormModel);
                  await ref.watch(dbProvider).saveData(
                      dbKey: addressList, dbValue: json.encode(listForm));
                } else {
                  final dbString =
                      await ref.watch(dbProvider).getData(dbKey: addressList);
                  final List result = json.decode(dbString);

                  List<AddressFormModel> listForm =
                      result.map((e) => AddressFormModel.fromJson(e)).toList();
                  final AddressFormModel myFormModel = AddressFormModel(
                      country: countryController.text,
                      district: districtController.text,
                      uniqueId: uuid);
                  listForm.add(myFormModel);
                  await ref.watch(dbProvider).saveData(
                      dbKey: addressList, dbValue: json.encode(listForm));
                }
              },
              child: const Text('Save'),
            );
          }),
          Consumer(builder: (context, ref, child) {
            return ElevatedButton(
                onPressed: () {
                  // ref.watch(dbProvider).resetDb();
                  log(uuid);
                },
                child: const Text("reset"));
          })
        ],
      ),
    );
  }
}
