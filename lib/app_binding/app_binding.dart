import 'package:book_system/controller/book_search_controller.dart';
import 'package:book_system/controller/favourite_controller.dart';
import 'package:get/get.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<FavoritesController>(FavoritesController(), permanent: true);
    Get.put<BookSearchController>(BookSearchController(), permanent: true);
  }
}
