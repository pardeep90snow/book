import 'package:book_system/model/book_model.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesController extends GetxController {
  final RxList<Book> favorites = <Book>[].obs;

  static const _storageKey = 'favorites_books';

  bool isFavorite(Book book) => favorites.any((b) => b.id == book.id);

  void toggleFavorite(Book book) {
    if (isFavorite(book)) {
      favorites.removeWhere((b) => b.id == book.id);
    } else {
      favorites.add(book);
    }
    _saveFavorites();
  }

  @override
  void onInit() {
    super.onInit();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_storageKey);
    if (jsonStr != null && jsonStr.isNotEmpty) {
      try {
        final list = Book.listFromJsonString(jsonStr);
        favorites.assignAll(list);
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = Book.listToJsonString(favorites.toList());
    await prefs.setString(_storageKey, jsonStr);
  }
}
