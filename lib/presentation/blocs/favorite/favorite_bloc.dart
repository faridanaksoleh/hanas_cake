import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/usecases/get_favorites_usecase.dart';
import '../../../domain/usecases/toggle_favorite_usecase.dart';
import 'favorite_event.dart';
import 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final GetFavoritesUseCase getFavoritesUseCase;
  final ToggleFavoriteUseCase toggleFavoriteUseCase;

  FavoriteBloc({
    required this.getFavoritesUseCase,
    required this.toggleFavoriteUseCase,
  }) : super(FavoriteInitial()) {
    on<LoadFavoritesEvent>(_onLoadFavorites);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
  }

  Future<void> _onLoadFavorites(
    LoadFavoritesEvent event,
    Emitter<FavoriteState> emit,
  ) async {
    emit(FavoriteLoading());

    final result = await getFavoritesUseCase.execute();
    result.fold(
      (failure) => emit(FavoriteError(failure.message)),
      (favorites) => emit(FavoriteLoaded(favorites)),
    );
  }

  Future<void> _onToggleFavorite(
    ToggleFavoriteEvent event,
    Emitter<FavoriteState> emit,
  ) async {
    // Simpan state sebelumnya untuk rollback jika gagal
    final List<Product> previousFavorites = state is FavoriteLoaded
        ? List.from((state as FavoriteLoaded).favorites)
        : [];

    // Optimistic Update: langsung ubah UI
    final List<Product> updatedFavorites = List.from(previousFavorites);
    final existingIndex =
        updatedFavorites.indexWhere((p) => p.id == event.product.id);

    if (existingIndex >= 0) {
      updatedFavorites.removeAt(existingIndex);
    } else {
      updatedFavorites.insert(0, event.product);
    }

    emit(FavoriteLoaded(updatedFavorites));

    // Tembak API di background
    final result = await toggleFavoriteUseCase.execute(event.product.id);
    result.fold(
      (failure) {
        // Rollback jika API gagal
        emit(FavoriteError(failure.message, favorites: previousFavorites));
        // Kembalikan ke state loaded dengan data sebelumnya
        emit(FavoriteLoaded(previousFavorites));
      },
      (_) {
        // API sukses, state sudah benar dari optimistic update
      },
    );
  }
}
