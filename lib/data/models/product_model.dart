import '../../domain/entities/product.dart';
import '../../domain/entities/category.dart';

class ProductModel {
  final int id;
  final int categoryId;
  final String name;
  final String? description;
  final List<String>? flavors;
  final List<String>? portions;
  final String price;
  final int stock;
  final String discount;
  final String? image;
  final String slug;
  final bool isPo;
  final String? poDeadline;
  final String? poFulfillmentDate;
  final int? poQuota;
  final String imageUrl;
  final Map<String, dynamic>? categoryJson;

  const ProductModel({
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
    this.categoryJson,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final imageStr = json['image_url']?.toString() ?? json['image']?.toString() ?? '';
    
    String finalImageUrl = imageStr;
    if (imageStr.isNotEmpty && !imageStr.startsWith('http')) {
      String path = imageStr.startsWith('/') ? imageStr.substring(1) : imageStr;
      finalImageUrl = 'https://hanascake.syauqiebill.my.id/storage/$path';
    }

    return ProductModel(
      id: json['id'] as int? ?? 0,
      categoryId: json['category_id'] as int? ?? 0,
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString(),
      flavors: json['flavors'] != null
          ? List<String>.from(json['flavors'] as List)
          : null,
      portions: json['portions'] != null
          ? List<String>.from(json['portions'] as List)
          : null,
      price: json['price']?.toString() ?? '0',
      stock: json['stock'] as int? ?? 0,
      discount: json['discount']?.toString() ?? '0',
      image: json['image']?.toString(),
      slug: json['slug']?.toString() ?? '',
      isPo: json['is_po'] == true || json['is_po'] == 1,
      poDeadline: json['po_deadline']?.toString(),
      poFulfillmentDate: json['po_fulfillment_date']?.toString(),
      poQuota: json['po_quota'] as int?,
      imageUrl: finalImageUrl,
      categoryJson: json['category'] as Map<String, dynamic>?,
    );
  }

  Product toEntity() {
    Category? categoryEntity;
    if (categoryJson != null) {
      categoryEntity = Category(
        id: categoryJson!['id'] as int,
        name: categoryJson!['name'] as String,
        slug: categoryJson!['slug'] as String,
      );
    }

    return Product(
      id: id,
      categoryId: categoryId,
      name: name,
      description: description,
      flavors: flavors,
      portions: portions,
      price: double.parse(price),
      stock: stock,
      discount: double.parse(discount),
      image: image,
      slug: slug,
      isPo: isPo,
      poDeadline: poDeadline,
      poFulfillmentDate: poFulfillmentDate,
      poQuota: poQuota,
      imageUrl: imageUrl,
      category: categoryEntity,
    );
  }
}
