import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../repositories/favorite_repository.dart';

class ToggleFavoriteUseCase {
  final FavoriteRepository repository;

  ToggleFavoriteUseCase(this.repository);

  Future<Either<Failure, bool>> execute(int productId) {
    return repository.toggleFavorite(productId);
  }
}
