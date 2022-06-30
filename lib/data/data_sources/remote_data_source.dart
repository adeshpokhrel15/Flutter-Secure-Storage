import 'package:adesh/core/api_client.dart';
import 'package:adesh/data/models/post_model.dart';
import 'package:adesh/helpers/constants/string.dart';

class RemoteDataSource {
  Future<List<PostModel>> getPosts() async {
    final List result = await ApiClient().getData(endpoint: postUrl);
    return result.map((e) => PostModel.fromMap(e)).toList();
  }
}
