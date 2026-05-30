import 'package:equatable/equatable.dart';
import '../../../domain/entities/product.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

/// Menambahkan produk ke keranjang.
/// Jika produk sudah ada, quantity akan ditambahkan.
class AddToCartEvent extends CartEvent {
  final Product product;
  final int quantity;
  final String? notes;

  const AddToCartEvent(
    this.product, {
    this.quantity = 1,
    this.notes,
  });

  @override
  List<Object?> get props => [product.id, quantity, notes];
}

/// Memperbarui quantity item tertentu berdasarkan productId.
/// Jika newQuantity <= 0, item akan dihapus dari keranjang.
class UpdateCartItemQuantityEvent extends CartEvent {
  final int productId;
  final int newQuantity;

  const UpdateCartItemQuantityEvent(this.productId, this.newQuantity);

  @override
  List<Object?> get props => [productId, newQuantity];
}

/// Menghapus item tertentu dari keranjang berdasarkan productId.
class RemoveFromCartEvent extends CartEvent {
  final int productId;

  const RemoveFromCartEvent(this.productId);

  @override
  List<Object?> get props => [productId];
}

/// Mengosongkan seluruh isi keranjang.
class ClearCartEvent extends CartEvent {}
