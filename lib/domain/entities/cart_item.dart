import 'package:equatable/equatable.dart';
import 'product.dart';

class CartItem extends Equatable {
  final Product product;
  final int quantity;
  final String? notes;

  const CartItem({
    required this.product,
    required this.quantity,
    this.notes,
  });

  /// Total harga = harga satuan * jumlah
  double get totalPrice => product.price * quantity;

  /// Membuat salinan CartItem dengan nilai yang diperbarui
  CartItem copyWith({
    Product? product,
    int? quantity,
    String? notes,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [product.id, quantity, notes];
}
