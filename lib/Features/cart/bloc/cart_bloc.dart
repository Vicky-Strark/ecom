import 'package:bloc/bloc.dart';
import 'package:ecom/Features/cart/model/cart_model.dart';
import 'package:ecom/Features/cart/repository/cart_repository.dart';
import 'package:equatable/equatable.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository cartRepository;

  CartBloc({required this.cartRepository}) : super(CartInitial()) {
    on<LoadCartEvent>(_onCartLoad);
    on<AddCartEvent>(_onAddCart);
    on<RemoveCartEvent>(_onRemoveCart);
    on<DeleteCartEvent>(_onDeleteCart);
  }


  Future<void> _onCartLoad(
      LoadCartEvent event,
      Emitter<CartState> emit,
      ) async {
    emit(CartLoadingState());

    try {
      final cartItems = await cartRepository.fetchCart();
      emit(CartLoadedState(cartItems: cartItems));
    } catch (e) {
      emit(CartErrorState(erMsg: e.toString()));
    }
  }

  Future<void> _onAddCart(
      AddCartEvent event,
      Emitter<CartState> emit,
      ) async {
    try {
      if (event.cartModel == null) {
        emit(CartErrorState(erMsg: "Invalid cart item"));
        return;
      }

      await cartRepository.addToCart(event.cartModel!);


      final cartItems = await cartRepository.fetchCart();
      emit(CartLoadedState(cartItems: cartItems));
    } catch (e) {
      emit(CartErrorState(erMsg: e.toString()));
    }
  }


  Future<void> _onRemoveCart(
      RemoveCartEvent event,
      Emitter<CartState> emit,
      ) async {
    try {
      if (event.cartModel == null) {
        emit(CartErrorState(erMsg: "Invalid cart item"));
        return;
      }

      await cartRepository.removeFromCart(event.cartModel!);

      final cartItems = await cartRepository.fetchCart();
      emit(CartLoadedState(cartItems: cartItems));
    } catch (e) {
      emit(CartErrorState(erMsg: e.toString()));
    }
  }


  Future<void> _onDeleteCart(
      DeleteCartEvent event,
      Emitter<CartState> emit,
      ) async {
    try {
      if (event.cartModel == null) {
        emit(CartErrorState(erMsg: "Invalid cart item"));
        return;
      }

      await cartRepository.deleteFromCart(event.cartModel!);
      final cartItems = await cartRepository.fetchCart();
      emit(CartLoadedState(cartItems: cartItems));
    } catch (e) {
      emit(CartErrorState(erMsg: e.toString()));
    }
  }
}