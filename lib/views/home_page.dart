import 'dart:convert';

import 'package:adesh/core/api_client.dart';
import 'package:adesh/core/db_client.dart';
import 'package:adesh/data/data_sources/remote_data_source.dart';
import 'package:adesh/data/models/adress_form.dart';
import 'package:adesh/data/models/final_form.dart';
import 'package:adesh/data/models/my_form_model.dart';
import 'package:adesh/data/models/post_model.dart';
import 'package:adesh/helpers/constants/string.dart';
import 'package:adesh/logic/personal_form_controller.dart';
import 'package:adesh/views/my_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                ref.refresh(personalControllerProvider);
              },
              icon: const Icon(Icons.refresh)),
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const MyForm(),
                ));
              },
              icon: const Icon(Icons.abc))
        ],
      ),
      body: ref.watch(personalControllerProvider).when(
            data: (data) {
              return ListView(
                children: [
                  ...data.map(
                    (e) => ListTile(
                      onTap: () async {},
                      title: Text(e.name),
                      subtitle: Text(e.uniqueId),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final myString = await ref
                          .watch(dbProvider)
                          .getData(dbKey: 'list_data');
                      final List jsonData = json.decode(myString);
                      final List<MyFormModel> listData =
                          jsonData.map((d) => MyFormModel.fromJson(d)).toList();

                      final addressString = await ref
                          .watch(dbProvider)
                          .getData(dbKey: addressList);
                      final List jsonDataaddress = json.decode(addressString);
                      final List<AddressFormModel> listDataaddress =
                          jsonDataaddress
                              .map((d) => AddressFormModel.fromJson(d))
                              .toList();

                      List<FinalFormModel> finalList = [];

                      for (int i = 0; i < listData.length; i++) {
                        final MyFormModel myFormModel = listData
                            .where((element) =>
                                element.uniqueId == listData[i].uniqueId)
                            .toList()
                            .first;
                        final AddressFormModel addressFormModel =
                            listDataaddress
                                .where((element) =>
                                    element.uniqueId == listData[i].uniqueId)
                                .toList()
                                .first;
                        final FinalFormModel finalFormModel = FinalFormModel(
                            name: myFormModel.name,
                            address: myFormModel.address,
                            country: addressFormModel.country,
                            district: addressFormModel.district);
                        finalList.add(finalFormModel);
                      }

                      for (int j = 0; j < finalList.length; j++) {
                        await ref
                            .watch(apiClientProvider)
                            .postData(formData: finalList[j].toMap());
                      }
                    },
                    child: const Text("Push To Server"),
                  ),
                  FutureBuilder<List<PostModel>>(
                    future: RemoteDataSource().getPosts(),
                    builder: (context, snap) {
                      if (snap.hasData) {
                        return Column(
                          children: [
                            ...snap.data!.map((e) => ListTile(
                                  title: Text(e.title),
                                  subtitle: Text(e.body),
                                ))
                          ],
                        );
                      } else {
                        return const Center(
                          child: Text("No data"),
                        );
                      }
                    },
                  )
                ],
              );
            },
            error: (err, s) => Text(err.toString()),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
    );
  }
}
