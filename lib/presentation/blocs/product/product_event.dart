import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class GetCategoriesEvent extends ProductEvent {}

class GetProductsEvent extends ProductEvent {
  final int? categoryId;
  final int page;

  const GetProductsEvent({this.categoryId, this.page = 1});

  @override
  List<Object?> get props => [categoryId, page];
}

class GetProductDetailEvent extends ProductEvent {
  final int productId;

  const GetProductDetailEvent(this.productId);

  @override
  List<Object?> get props => [productId];
}
