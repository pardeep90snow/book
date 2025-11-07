import 'package:book_system/model/book_model.dart';
import 'package:flutter/material.dart';

class BookDetailScreen extends StatelessWidget {
  final Book book;

  const BookDetailScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(book.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isWide ? 32 : 16,
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (book.thumbnail != null)
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    book.thumbnail!,
                    height: isWide ? 280 : 220,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            const SizedBox(height: 16),
            Text(book.title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              (book.authors.isEmpty
                  ? 'Unknown author'
                  : book.authors.join(', ')),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            if (book.publisher != null || book.publishedDate != null)
              Text(
                [
                  if (book.publisher != null) 'Publisher: ${book.publisher}',
                  if (book.publishedDate != null)
                    'Published: ${book.publishedDate}',
                ].join(' • '),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            const SizedBox(height: 16),
            Text(
              book.description ?? 'No description available for this book.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
