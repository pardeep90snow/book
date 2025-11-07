import 'package:book_system/controller/favourite_controller.dart';
import 'package:book_system/model/book_model.dart';
import 'package:book_system/screen/book_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookListItem extends StatelessWidget {
  final Book book;

  BookListItem({super.key, required this.book});

  final FavoritesController favoritesController =
      Get.find<FavoritesController>();

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;

    return Card(
      color: Colors.white,
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: _buildThumbnail(isWide),
        title: Text(book.title, maxLines: 2, overflow: TextOverflow.ellipsis),
        subtitle: Text(
          book.authors.isEmpty ? 'Unknown author' : book.authors.join(', '),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Obx(() {
          final isFav = favoritesController.isFavorite(book);
          return IconButton(
            icon: Icon(
              isFav ? Icons.star : Icons.star_border,
              color: isFav ? Colors.amber : Colors.grey,
            ),
            onPressed: () => favoritesController.toggleFavorite(book),
          );
        }),
        onTap: () {
          Get.to(() => BookDetailScreen(book: book));
        },
      ),
    );
  }

  Widget _buildThumbnail(bool isWide) {
    if (book.thumbnail != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.network(
          book.thumbnail!,
          width: isWide ? 70 : 50,
          height: isWide ? 100 : 70,
          fit: BoxFit.cover,
        ),
      );
    }
    return Container(
      width: isWide ? 70 : 50,
      height: isWide ? 100 : 70,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Icon(Icons.book, color: Colors.grey),
    );
  }
}
