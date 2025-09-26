//
// import 'package:comic_app/features/comic/models/comic_item.dart';
// import 'package:get/get.dart';
//
// class HomeController extends GetxController {
//
//   late Rx<Future<List<ComicItem>>> comics= fetchComicHomeData().obs;
//
// }

import 'dart:convert';

import 'package:comic_app/features/comic/models/comic_item.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  final comics = <ComicItem>[].obs;

  Future<void> fetchComics() async {
    final url = "https://otruyenapi.com/v1/api/home";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final items = jsonData['data']['items'] as List;
      final newComics = items.map((e) => ComicItem.fromJson(e)).toList();

      comics.addAll(newComics);
    }
  }

  @override
  void onInit() {
    fetchComics();
    super.onInit();
  }
}
