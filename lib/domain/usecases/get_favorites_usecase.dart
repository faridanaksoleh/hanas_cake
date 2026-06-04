import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/product.dart';
import '../repositories/favorite_repository.dart';

class GetFavoritesUseCase {
  final FavoriteRepository repository;

  GetFavoritesUseCase(this.repository);

  Future<Either<Failure, List<Product>>> execute() {
    return repository.getFavorites();
  }
}
