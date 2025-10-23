import 'package:ecom/Core/core.dart';
import 'package:ecom/Shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecom/Features/cart/bloc/cart_bloc.dart';
import 'package:ecom/Features/cart/model/cart_model.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios,color: Colors.white,),),
        title: CustomText(
          txt: "My Cart",
          clr: Colors.white,
          fontWeight: FontWeight.w800,
          size: 18,
        ),
        elevation: 0,
        backgroundColor: AppColors.primaryColor,
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is CartErrorState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  const SizedBox(height: 16),
                  CustomText(
                    txt:
                    'Error loading cart',

                  ),
                  const SizedBox(height: 8),
                  CustomText(
                    txt:state.erMsg ?? "",

                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CartBloc>().add(LoadCartEvent());
                    },
                    child: CustomText(txt: 'Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is CartLoadedState) {
            if (state.cartItems!.isEmpty) {
              return Center(
                child: Column(
                  spacing: 15,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 100,
                      color: Colors.grey[400],
                    ),

                    CustomText(
                      txt: 'Your cart is empty',

                      size: 15,

                    ),

                    CustomText(
                     txt:  'Add items to get started',

                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.cartItems!.length,
                    itemBuilder: (context, index) {
                      final item = state.cartItems![index];
                      return CartItemCard(item: item);
                    },
                  ),
                ),
                CartSummary(cartItems: state.cartItems!),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class CartItemCard extends StatelessWidget {
  final CartModel item;

  const CartItemCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [

            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: item.image != null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  item.image!,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.image, size: 40);
                  },
                ),
              )
                  : const Icon(Icons.image, size: 40),
            ),
            const SizedBox(width: 12),

            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                   txt:  item.title ?? 'Product',
                    size: 16,
                    fontWeight: FontWeight.w600,
                    maxLn: 2,
                  ),
                  const SizedBox(height: 4),
                  CustomText(
                   txt:  '\$${item.price?.toStringAsFixed(2) ?? '0.00'}',
                    size: 16,
                    fontWeight: FontWeight.w500,
                    clr: AppColors.txtGrey,
                  ),
                  const SizedBox(height: 8),

                  // Quantity Controls
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          context.read<CartBloc>().add(
                            RemoveCartEvent(cartModel: item),
                          );
                        },
                        icon: const Icon(Icons.remove_circle_outline),
                        iconSize: 20,
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: CustomText(
                          txt:
                          '${item.quantity ?? 1}',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          context.read<CartBloc>().add(
                            AddCartEvent(cartModel: item),
                          );
                        },
                        icon: const Icon(Icons.add_circle_outline),
                        iconSize: 20,
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            IconButton(
              onPressed: () {

                _showDeleteConfirmation(context, item);
              },
              icon: const Icon(Icons.delete_outline),
              color: Colors.red[400],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, CartModel item) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: CustomText(txt: 'Remove Item'),
          content: CustomText(txt: 'Remove ${item.title ?? 'this item'} from cart?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Delete item completely
                context.read<CartBloc>().add(
                  DeleteCartEvent(cartModel: item),
                );
                Navigator.of(dialogContext).pop();


                AlertService().showSnackBar(
                  context: context,
                  msg: 'Item removed from cart',
                  color: Colors.black
                );

              },
              child:  CustomText(
                txt:
                'Remove',
               clr: AppColors.primaryColor,
              ),
            ),
          ],
        );
      },
    );
  }
}

class CartSummary extends StatelessWidget {
  final List<CartModel> cartItems;

  const CartSummary({
    super.key,
    required this.cartItems,
  });

  double get subtotal {
    return cartItems.fold(0, (sum, item) {
      return sum + ((item.price ?? 0) * (item.quantity ?? 1));
    });
  }

  double get tax => subtotal * 0.1; // 10% tax
  double get total => subtotal + tax;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 CustomText(txt: 'Subtotal'),
                CustomText(txt: '\$${subtotal.toStringAsFixed(2)}'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(txt: 'Tax'),
                CustomText(txt: '\$${tax.toStringAsFixed(2)}'),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  txt: 'Total',
                  size: 18,
                  fontWeight: FontWeight.bold,

                ),
                CustomText(
                 txt:  '\$${total.toStringAsFixed(2)}',
                  size: 18,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  _handleCheckout(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: CustomText(
                  txt: 'Checkout',
                  size: 16,
                  fontWeight: FontWeight.w600,
                  clr: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleCheckout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Checkout'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(txt: 'Items: ${cartItems.length}'),
              const SizedBox(height: 8),
              CustomText(txt: 'Total: \$${total.toStringAsFixed(2)}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                AlertService().showSnackBar(
                  context: context,
                  color: Colors.black,
                  msg: "Proceeding to checkout...",

                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
              ),
              child:  CustomText(
               txt: 'Confirm',
                clr: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }
}