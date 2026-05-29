import 'package:equatable/equatable.dart';
import 'category.dart';

class Product extends Equatable {
  final int id;
  final int categoryId;
  final String name;
  final String? description;
  final List<String>? flavors;
  final List<String>? portions;
  final double price;
  final int stock;
  final double discount;
  final String? image;
  final String slug;
  final bool isPo;
  final String? poDeadline;
  final String? poFulfillmentDate;
  final int? poQuota;
  final String imageUrl;
  final Category? category;

  const Product({
    required this.id,
    required this.categoryId,
    required this.name,
    this.description,
    this.flavors,
    this.portions,
    required this.price,
    required this.stock,
    required this.discount,
    this.image,
    required this.slug,
    required this.isPo,
    this.poDeadline,
    this.poFulfillmentDate,
    this.poQuota,
    required this.imageUrl,
    this.category,
  });

  @override
  List<Object?> get props => [id, categoryId, name, price, slug];
}
