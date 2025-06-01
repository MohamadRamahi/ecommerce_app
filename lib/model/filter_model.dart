class FilterModel {
  final String sortBy;
  final double minPrice;
  final double maxPrice;
  final String size;

  FilterModel({
    required this.sortBy,
    required this.minPrice,
    required this.maxPrice,
    required this.size,
  });
}
