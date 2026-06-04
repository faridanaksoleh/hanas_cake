import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/product.dart';

abstract class FavoriteRepository {
  Future<Either<Failure, List<Product>>> getFavorites();
  Future<Either<Failure, bool>> toggleFavorite(int productId);
}
