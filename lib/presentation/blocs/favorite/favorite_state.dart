import 'package:equatable/equatable.dart';
import '../../../domain/entities/product.dart';

abstract class FavoriteState extends Equatable {
  const FavoriteState();

  @override
  List<Object> get props => [];
}

class FavoriteInitial extends FavoriteState {}

class FavoriteLoading extends FavoriteState {}

class FavoriteLoaded extends FavoriteState {
  final List<Product> favorites;

  const FavoriteLoaded(this.favorites);

  @override
  List<Object> get props => [favorites];
}

class FavoriteError extends FavoriteState {
  final String message;
  final List<Product> favorites;

  const FavoriteError(this.message, {this.favorites = const []});

  @override
  List<Object> get props => [message, favorites];
}
