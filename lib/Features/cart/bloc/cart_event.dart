part of 'cart_bloc.dart';

sealed class CartEvent extends Equatable {
  const CartEvent();
}

class LoadCartEvent extends CartEvent {
  @override
  List<Object?> get props => [];
}

class AddCartEvent extends CartEvent {
  CartModel? cartModel;

  AddCartEvent({this.cartModel});

  @override
  List<Object?> get props => [cartModel];
}

class RemoveCartEvent extends CartEvent {
  CartModel? cartModel;

  RemoveCartEvent({this.cartModel});

  @override
  List<Object?> get props => [cartModel];
}

class DeleteCartEvent extends CartEvent {
  CartModel? cartModel;

  DeleteCartEvent({this.cartModel});

  @override
  List<Object?> get props => [cartModel];
}
