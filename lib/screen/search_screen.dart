import 'package:book_system/controller/book_search_controller.dart';
import 'package:book_system/screen/book_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});

  final BookSearchController searchController =
      Get.find<BookSearchController>();
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;
    final horizontalPadding = isWide ? 32.0 : 16.0;

    return Padding(
      padding: EdgeInsets.fromLTRB(horizontalPadding, 16, horizontalPadding, 0),
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          TextField(
            controller: _textController,
            onChanged: searchController.onQueryChanged,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: 'Search for a book (e.g. "Dune", "Flutter")',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 2),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification.metrics.pixels >=
                    notification.metrics.maxScrollExtent - 200) {
                  searchController.loadMoreBooks();
                }
                return false;
              },
              child: StreamBuilder<SearchState>(
                stream: searchController.stateStream,
                initialData: SearchState.initial(),
                builder: (context, snapshot) {
                  final state = snapshot.data ?? SearchState.initial();

                  if (state.isLoading && state.books.isEmpty) {
                    return _buildShimmerList();
                  }

                  if (state.hasError) {
                    return Center(
                      child: Text(
                        state.errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  if (state.books.isEmpty) {
                    return const Center(child: Text('No books available.'));
                  }

                  final books = state.books;

                  return RefreshIndicator(
                    onRefresh: searchController.loadAllBooks,
                    child: ListView.builder(
                      itemCount: books.length + (state.isPaginating ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == books.length) {
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          );
                        }
                        return BookListItem(book: books[index]);
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ✨ White shimmer cards with elevation
  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade200,
          highlightColor: Colors.grey.shade100,
          child: Card(
            color: Colors.white,
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              leading: Container(
                width: 55,
                height: 75,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              title: Container(
                height: 16,
                margin: const EdgeInsets.only(bottom: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              subtitle: Container(
                height: 14,
                width: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
