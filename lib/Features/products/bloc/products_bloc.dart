import 'package:bloc/bloc.dart';
import 'package:ecom/Features/cart/bloc/cart_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../Core/Errors/errors.dart';
import '../model/product_model.dart';
import '../respository/product_repository.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final ProductRepository repository;
  int _currentIndex = 0;
  final int _limit = 10;

  ProductsBloc(this.repository) : super(ProductInitial()) {
    on<FetchProducts>(_onFetchProducts);
    on<LoadMoreProducts>(_onLoadMoreProducts);
    on<RefreshProducts>(_onRefreshProducts);
    on<SearchProducts>(_onProductsSearch);
  }


  Future<void> _onFetchProducts(
      FetchProducts event, Emitter<ProductsState> emit) async {
    emit(ProductLoading());
    try {
      _currentIndex = 0;
      final products =
      await repository.fetchProducts();
      emit(ProductLoaded(products: products, hasReachedMax: false));
    } catch (e) {
      if (e is ServerException ||
          e is NetworkException ||
          e is SomethingWrongException) {
        emit(ProductError(e.toString()));
      } else {
        emit(ProductError("Unexpected error: ${e.toString()}"));
      }
    }
  }


  Future<void> _onLoadMoreProducts(
      LoadMoreProducts event, Emitter<ProductsState> emit) async {
    final currentState = state;
    if (currentState is ProductLoaded && !currentState.hasReachedMax) {
      emit(ProductPaginationLoading(currentState.products));

      try {
        _currentIndex += _limit;
        final newProducts = await repository.fetchProducts(
            );

        if (newProducts.isEmpty) {
          emit(currentState.copyWith(hasReachedMax: true));
        } else {
          final updatedProducts = List<ProductModel>.from(currentState.products)
            ..addAll(newProducts);

          emit(ProductLoaded(
            products: updatedProducts,
            hasReachedMax: false,
          ));
        }
      } catch (e) {
        if (e is ServerException ||
            e is NetworkException ||
            e is SomethingWrongException) {
          emit(ProductError(e.toString()));
        } else {
          emit(ProductError("Unexpected error: ${e.toString()}"));
        }
      }
    }
  }


  Future<void> _onRefreshProducts(
      RefreshProducts event, Emitter<ProductsState> emit) async {
    emit(ProductLoading());
    try {
      _currentIndex = 0;
      final products =
      await repository.fetchProducts();
      emit(ProductLoaded(products: products, hasReachedMax: false));
    } catch (e) {
      if (e is ServerException ||
          e is NetworkException ||
          e is SomethingWrongException) {
        emit(ProductError(e.toString()));
      } else {
        emit(ProductError("Unexpected error: ${e.toString()}"));
      }
    }
  }


  Future<void> _onProductsSearch(SearchProducts event, Emitter<ProductsState> emit)async{

    emit(ProductLoading());
    try{
      final products =
      await repository.searchProducts(val: event.val

      );
      emit(SearchProductsLoadedState(products));

    }catch(e){
      if (e is ServerException ||
          e is NetworkException ||
          e is SomethingWrongException) {
        emit(ProductError(e.toString()));
      } else {
        emit(ProductError("Unexpected error: ${e.toString()}"));
      }
    }



}
}
