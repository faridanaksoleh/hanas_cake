import 'package:equatable/equatable.dart';
import '../../../domain/entities/category.dart';
import '../../../domain/entities/product.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class CategoriesLoaded extends ProductState {
  final List<Category> categories;

  const CategoriesLoaded(this.categories);

  @override
  List<Object?> get props => [categories];
}

class ProductsLoaded extends ProductState {
  final List<Product> products;
  final List<Category> categories;

  const ProductsLoaded({required this.products, this.categories = const []});

  @override
  List<Object?> get props => [products, categories];
}

class ProductDetailLoaded extends ProductState {
  final Product product;

  const ProductDetailLoaded(this.product);

  @override
  List<Object?> get props => [product];
}

class ProductFailure extends ProductState {
  final String message;

  const ProductFailure(this.message);

  @override
  List<Object?> get props => [message];
}
