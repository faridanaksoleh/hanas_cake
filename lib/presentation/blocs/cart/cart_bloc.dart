import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/cart_item.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<AddToCartEvent>(_onAddToCart);
    on<UpdateCartItemQuantityEvent>(_onUpdateQuantity);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
    on<ClearCartEvent>(_onClearCart);
  }

  /// Menambahkan produk ke keranjang.
  /// Jika produk sudah ada (berdasarkan product.id), quantity ditambahkan.
  /// Jika belum ada, dimasukkan sebagai item baru.
  void _onAddToCart(AddToCartEvent event, Emitter<CartState> emit) {
    final currentItems = List<CartItem>.from(state.items);
    final existingIndex = currentItems.indexWhere(
      (item) => item.product.id == event.product.id,
    );

    if (existingIndex != -1) {
      // Produk sudah ada → tambah quantity
      final existingItem = currentItems[existingIndex];
      currentItems[existingIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + event.quantity,
        notes: event.notes ?? existingItem.notes,
      );
    } else {
      // Produk baru → tambahkan ke list
      currentItems.add(CartItem(
        product: event.product,
        quantity: event.quantity,
        notes: event.notes,
      ));
    }

    emit(state.copyWith(items: currentItems));
  }

  /// Memperbarui quantity item tertentu.
  /// Jika newQuantity <= 0, item akan dihapus dari keranjang.
  void _onUpdateQuantity(
    UpdateCartItemQuantityEvent event,
    Emitter<CartState> emit,
  ) {
    final currentItems = List<CartItem>.from(state.items);

    if (event.newQuantity <= 0) {
      // Hapus item jika quantity 0 atau negatif
      currentItems.removeWhere(
        (item) => item.product.id == event.productId,
      );
    } else {
      final index = currentItems.indexWhere(
        (item) => item.product.id == event.productId,
      );
      if (index != -1) {
        currentItems[index] = currentItems[index].copyWith(
          quantity: event.newQuantity,
        );
      }
    }

    emit(state.copyWith(items: currentItems));
  }

  /// Menghapus item tertentu dari keranjang berdasarkan productId.
  void _onRemoveFromCart(RemoveFromCartEvent event, Emitter<CartState> emit) {
    final currentItems = List<CartItem>.from(state.items);
    currentItems.removeWhere(
      (item) => item.product.id == event.productId,
    );
    emit(state.copyWith(items: currentItems));
  }

  /// Mengosongkan seluruh isi keranjang.
  void _onClearCart(ClearCartEvent event, Emitter<CartState> emit) {
    emit(const CartState());
  }
}
