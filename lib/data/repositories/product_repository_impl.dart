import 'package:dartz/dartz.dart';

import '../datasources/product_remote_datasource.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../../core/errors/failures.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDatasource remoteDatasource;

  ProductRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    try {
      final models = await remoteDatasource.getCategories();
      final categories = models.map((m) => m.toEntity()).toList();
      return Right(categories);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getProducts({int? categoryId, int page = 1}) async {
    try {
      final models = await remoteDatasource.getProducts(categoryId: categoryId, page: page);
      final products = models.map((m) => m.toEntity()).toList();
      return Right(products);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Product>> getProductDetail(int id) async {
    try {
      final model = await remoteDatasource.getProductDetail(id);
      return Right(model.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
