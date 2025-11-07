import 'dart:async';
import 'dart:convert';
import 'package:book_system/model/book_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SearchState {
  final String query;
  final bool isLoading;
  final bool isPaginating;
  final List<Book> books;
  final String? errorMessage;

  const SearchState({
    this.query = '',
    this.isLoading = false,
    this.isPaginating = false,
    this.books = const [],
    this.errorMessage,
  });

  factory SearchState.initial() => const SearchState();

  factory SearchState.loading(String query) =>
      SearchState(query: query, isLoading: true);

  factory SearchState.success(
    String query,
    List<Book> books, {
    bool isPaginating = false,
  }) => SearchState(query: query, books: books, isPaginating: isPaginating);

  factory SearchState.error(String query, String message) =>
      SearchState(query: query, errorMessage: message);

  bool get hasError => errorMessage != null;
}

class BookSearchController extends GetxController {
  final _client = http.Client();
  final RxString query = ''.obs;
  final StreamController<SearchState> _stateController =
      StreamController<SearchState>.broadcast();

  Stream<SearchState> get stateStream => _stateController.stream;

  Timer? _debounce;

  List<Book> _allBooks = [];
  int _currentStartIndex = 0;
  final int _pageSize = 40;
  bool _hasMore = true;
  bool _isLoadingPage = false;

  @override
  void onInit() {
    super.onInit();
    _stateController.add(SearchState.initial());
    loadAllBooks(); // first shimmer + data load
  }

  /// 🔹 Fetch first page (reset state)
  Future<void> loadAllBooks() async {
    const queryText = "fiction";
    _currentStartIndex = 0;
    _hasMore = true;
    _allBooks.clear();
    _stateController.add(SearchState.loading(queryText));
    await _fetchPage(queryText, append: false);
  }

  /// 🔹 Pagination: fetch next page
  Future<void> loadMoreBooks() async {
    if (_isLoadingPage || !_hasMore) return;
    _isLoadingPage = true;
    await _fetchPage(
      query.value.isEmpty ? "fiction" : query.value,
      append: true,
    );
    _isLoadingPage = false;
  }

  /// 🔹 Fetch single page from API
  Future<void> _fetchPage(String q, {bool append = false}) async {
    try {
      final uri = Uri.parse(
        'https://www.googleapis.com/books/v1/volumes?q=$q&startIndex=$_currentStartIndex&maxResults=$_pageSize',
      );
      final resp = await _client.get(uri);

      if (resp.statusCode != 200) {
        _stateController.add(
          SearchState.error(q, 'Server error: ${resp.statusCode}'),
        );
        return;
      }

      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      final items = (data['items'] as List?) ?? [];
      if (items.isEmpty) {
        _hasMore = false;
        return;
      }

      final books = items
          .map((e) => Book.fromJson(e as Map<String, dynamic>))
          .toList();

      if (append) {
        _allBooks.addAll(books);
      } else {
        _allBooks = books;
      }

      _currentStartIndex += _pageSize;
      _stateController.add(
        SearchState.success(q, _allBooks, isPaginating: append),
      );
    } catch (e) {
      _stateController.add(SearchState.error(q, 'Failed to load books: $e'));
    }
  }

  /// 🔹 Local filtering for search
  void onQueryChanged(String value) {
    query.value = value;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      final q = query.value.trim().toLowerCase();
      if (q.isEmpty) {
        _stateController.add(SearchState.success('', _allBooks));
      } else {
        final filtered = _allBooks.where((book) {
          final title = book.title?.toLowerCase() ?? '';
          final authors = (book.authors ?? []).join(',').toLowerCase();
          final description = book.description?.toLowerCase() ?? '';
          return title.contains(q) ||
              authors.contains(q) ||
              description.contains(q);
        }).toList();

        _stateController.add(SearchState.success(q, filtered));
      }
    });
  }

  @override
  void onClose() {
    _debounce?.cancel();
    _client.close();
    _stateController.close();
    super.onClose();
  }
}
