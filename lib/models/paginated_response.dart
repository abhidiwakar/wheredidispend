class PaginatedResponse<T> {
  final int total;
  final T data;
  PaginatedResponse({
    required this.data,
    required this.total,
  });
}
