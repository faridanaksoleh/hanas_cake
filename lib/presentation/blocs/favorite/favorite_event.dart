import 'package:equatable/equatable.dart';
import '../../../domain/entities/product.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object> get props => [];
}

/// Memuat daftar favorit dari server
class LoadFavoritesEvent extends FavoriteEvent {}

/// Toggle favorit produk (optimistic update + API call)
class ToggleFavoriteEvent extends FavoriteEvent {
  final Product product;
  const ToggleFavoriteEvent(this.product);

  @override
  List<Object> get props => [product];
}
