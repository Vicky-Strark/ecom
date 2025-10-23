part of 'products_bloc.dart';




/// Base class for all product states
sealed class ProductsState extends Equatable {
  @override
  List<Object?> get props => [];
}


class ProductInitial extends ProductsState {}


class ProductLoading extends ProductsState {}


class ProductLoaded extends ProductsState {
  final List<ProductModel> products;
  final bool hasReachedMax;
  final bool fromCache;

  ProductLoaded({
    required this.products,
    this.hasReachedMax = false,
    this.fromCache = false,
  });

  ProductLoaded copyWith({
    List<ProductModel>? products,
    bool? hasReachedMax,
    bool? fromCache,
  }) {
    return ProductLoaded(
      products: products ?? this.products,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      fromCache: fromCache ?? this.fromCache,
    );
  }

  @override
  List<Object?> get props => [products, hasReachedMax, fromCache];
}


class ProductError extends ProductsState {
  final String message;

  ProductError(this.message);

  @override
  List<Object?> get props => [message];
}


class ProductPaginationLoading extends ProductsState {
  final List<ProductModel> oldProducts;

  ProductPaginationLoading(this.oldProducts);

  @override
  List<Object?> get props => [oldProducts];
}




class SearchProductsLoadedState extends ProductsState {
  final List<ProductModel> oldProducts;

  SearchProductsLoadedState(this.oldProducts);

  @override
  List<Object?> get props => [oldProducts];
}