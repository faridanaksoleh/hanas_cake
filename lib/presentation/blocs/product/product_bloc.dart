import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/category.dart';
import '../../../domain/usecases/get_categories_usecase.dart';
import '../../../domain/usecases/get_products_usecase.dart';
import '../../../domain/usecases/get_product_detail_usecase.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetProductsUseCase getProductsUseCase;
  final GetProductDetailUseCase getProductDetailUseCase;

  // Cache categories to avoid re-fetching
  List<Category> _cachedCategories = [];

  ProductBloc({
    required this.getCategoriesUseCase,
    required this.getProductsUseCase,
    required this.getProductDetailUseCase,
  }) : super(ProductInitial()) {

    on<GetCategoriesEvent>((event, emit) async {
      emit(ProductLoading());
      final result = await getCategoriesUseCase.execute();
      result.fold(
        (failure) => emit(ProductFailure(failure.message)),
        (categories) {
          _cachedCategories = categories;
          emit(CategoriesLoaded(categories));
        },
      );
    });

    on<GetProductsEvent>((event, emit) async {
      emit(ProductLoading());
      final result = await getProductsUseCase.execute(
        categoryId: event.categoryId,
        page: event.page,
      );
      result.fold(
        (failure) => emit(ProductFailure(failure.message)),
        (products) => emit(ProductsLoaded(
          products: products,
          categories: _cachedCategories,
        )),
      );
    });

    on<GetProductDetailEvent>((event, emit) async {
      emit(ProductLoading());
      final result = await getProductDetailUseCase.execute(event.productId);
      result.fold(
        (failure) => emit(ProductFailure(failure.message)),
        (product) => emit(ProductDetailLoaded(product)),
      );
    });
  }
}
