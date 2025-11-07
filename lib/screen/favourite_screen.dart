import 'package:book_system/controller/favourite_controller.dart';
import 'package:book_system/screen/book_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavoritesScreen extends StatelessWidget {
  FavoritesScreen({super.key});

  final FavoritesController favoritesController =
      Get.find<FavoritesController>();

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;
    final horizontalPadding = isWide ? 32.0 : 16.0;

    return Padding(
      padding: EdgeInsets.fromLTRB(horizontalPadding, 16, horizontalPadding, 0),
      child: Obx(() {
        final favs = favoritesController.favorites;

        if (favs.isEmpty) {
          return const Center(
            child: Text("You haven't added any favorites yet."),
          );
        }

        return ListView.builder(
          itemCount: favs.length,
          itemBuilder: (context, index) => BookListItem(book: favs[index]),
        );
      }),
    );
  }
}
