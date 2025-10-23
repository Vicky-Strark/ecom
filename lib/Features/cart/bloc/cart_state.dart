part of 'cart_bloc.dart';

sealed class CartState extends Equatable {
  const CartState();
}

final class CartInitial extends CartState {
  @override
  List<Object> get props => [];
}

class CartLoadingState extends CartState {
  @override
  List<Object?> get props => [];
}

class CartLoadedState extends CartState {
  List<CartModel>? cartItems;

  CartLoadedState({this.cartItems});

  @override
  // TODO: implement props
  List<Object?> get props => [cartItems];
}

class CartErrorState extends CartState {
  String? erMsg;

  CartErrorState({this.erMsg});

  @override
  List<Object?> get props => [erMsg];
}

