import 'dart:convert';

import 'package:adesh/core/db_client.dart';
import 'package:adesh/data/models/my_form_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final personalControllerProvider = StateNotifierProvider.autoDispose<
    PersonalFormController, AsyncValue<List<MyFormModel>>>((ref) {
  return PersonalFormController(ref.watch(dbProvider));
});

class PersonalFormController
    extends StateNotifier<AsyncValue<List<MyFormModel>>> {
  PersonalFormController(this._dbClient) : super(const AsyncValue.loading()) {
    fetchData();
  }

  final DbClient _dbClient;

  fetchData() async {
    try {
      final String dbString = await _dbClient.getData(dbKey: 'list_data');
      final List jsonData = json.decode(dbString);
      final List<MyFormModel> listData =
          jsonData.map((e) => MyFormModel.fromJson(e)).toList();

      state = AsyncValue.data(listData);
    } catch (e) {
      state = const AsyncValue.error('No Data in DataBase');
    }
  }
}
