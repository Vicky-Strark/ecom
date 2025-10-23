part of 'products_bloc.dart';

sealed class ProductsEvent extends Equatable {
  const ProductsEvent();
}



class FetchProducts extends ProductsEvent {
  @override
  // TODO: implement props
  List<Object?> get props =>[];
}


class LoadMoreProducts extends ProductsEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}


class RefreshProducts extends ProductsEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}


class SearchProducts extends ProductsEvent{
  String? val;
  SearchProducts({this.val});

  @override
  // TODO: implement props
  List<Object?> get props => [val];

}

