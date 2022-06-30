import 'dart:convert';

import 'package:adesh/core/db_client.dart';
import 'package:adesh/data/models/my_form_model.dart';
import 'package:adesh/views/address_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class MyForm extends StatefulWidget {
  const MyForm({Key? key}) : super(key: key);

  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  late TextEditingController nameController;
  late TextEditingController addressController;

  @override
  void initState() {
    nameController = TextEditingController();
    addressController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const AddressForm()));
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(hintText: 'Enter Name'),
          ),
          TextField(
            controller: addressController,
            decoration: const InputDecoration(hintText: 'Enter address'),
          ),
          Consumer(builder: (context, ref, child) {
            return ElevatedButton(
              onPressed: () async {
                final check =
                    await ref.watch(dbProvider).getData(dbKey: 'list_data');
                if (check == null) {
                  final MyFormModel myFormModel = MyFormModel(
                      name: nameController.text,
                      address: addressController.text,
                      createdAt: DateTime.now(),
                      uniqueId: const Uuid().v4());
                  List<MyFormModel> listForm = [];
                  listForm.add(myFormModel);
                  await ref.watch(dbProvider).saveData(
                      dbKey: 'list_data', dbValue: json.encode(listForm));
                } else {
                  final dbString =
                      await ref.watch(dbProvider).getData(dbKey: 'list_data');
                  final List result = json.decode(dbString);

                  List<MyFormModel> listForm =
                      result.map((e) => MyFormModel.fromJson(e)).toList();
                  final MyFormModel myFormModel = MyFormModel(
                      name: nameController.text,
                      address: addressController.text,
                      createdAt: DateTime.now(),
                      uniqueId: const Uuid().v4());
                  listForm.add(myFormModel);
                  await ref.watch(dbProvider).saveData(
                      dbKey: 'list_data', dbValue: json.encode(listForm));
                }
              },
              child: const Text('Save'),
            );
          }),
          Consumer(builder: (context, ref, child) {
            return ElevatedButton(
                onPressed: () {
                  ref.watch(dbProvider).resetDb();
                },
                child: const Text("reset"));
          })
        ],
      ),
    );
  }
}
