import 'package:equatable/equatable.dart';
import '../../../domain/entities/cart_item.dart';

class CartState extends Equatable {
  final List<CartItem> items;

  const CartState({this.items = const []});

  /// Grand total harga seluruh item di keranjang
  double get grandTotal =>
      items.fold(0.0, (sum, item) => sum + item.totalPrice);

  /// Total kuantitas seluruh item di keranjang
  int get totalItems =>
      items.fold(0, (sum, item) => sum + item.quantity);

  /// Cek apakah keranjang kosong
  bool get isEmpty => items.isEmpty;

  /// Mendapatkan CartItem berdasarkan productId (null jika tidak ada)
  CartItem? getItemByProductId(int productId) {
    try {
      return items.firstWhere((item) => item.product.id == productId);
    } catch (_) {
      return null;
    }
  }

  /// Membuat salinan state dengan list items yang baru
  CartState copyWith({List<CartItem>? items}) {
    return CartState(items: items ?? this.items);
  }

  @override
  List<Object?> get props => [items];
}
