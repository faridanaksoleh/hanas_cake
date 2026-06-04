import 'package:dartz/dartz.dart';

import '../datasources/favorite_remote_datasource.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/favorite_repository.dart';
import '../../core/errors/failures.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  final FavoriteRemoteDatasource remoteDatasource;

  FavoriteRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, List<Product>>> getFavorites() async {
    try {
      final models = await remoteDatasource.getFavorites();
      final products = models.map((m) => m.toEntity()).toList();
      return Right(products);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> toggleFavorite(int productId) async {
    try {
      final isFavorited = await remoteDatasource.toggleFavorite(productId);
      return Right(isFavorited);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
