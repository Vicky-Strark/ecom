import 'package:ecom/Core/Constants/app_colors.dart';
import 'package:ecom/Features/products/model/product_model.dart';
import 'package:ecom/Shared/Widget/custom_button.dart';
import 'package:ecom/Shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Core/core.dart';
import '../../cart/bloc/cart_bloc.dart';
import '../../cart/model/cart_model.dart';
import '../../cart/repository/cart_repository.dart';
import '../../cart/view/cart_view.dart';

class ProductDetailsView extends StatelessWidget {
  ProductDetailsView({super.key, this.productModel});

  ProductModel? productModel;

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.sizeOf(context).height;
    var w = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: CustomText(
          txt: "${productModel!.title}",
          size: 15,
          clr: Colors.white,
          maxLn: 1,
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            spacing: 12,
            children: [
              Container(
                height: h * 0.18,
                width: w,
                padding: EdgeInsets.all(10),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Image.network(
                    productModel!.image ?? '',
                    fit: BoxFit.contain,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.broken_image,
                      size: 50,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              Divider(thickness: 1),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  spacing: 12,
                  children: [
                    CustomText(
                      txt: "${productModel!.title}",
                      size: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          txt:
                              "\$${productModel!.price?.toStringAsFixed(2) ?? '0.00'}",
                          clr: Colors.green,
                          fontWeight: FontWeight.bold,
                          size: 16,
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 22),
                            const SizedBox(width: 4),
                            CustomText(
                              txt: "${productModel!.rating?.rate ?? 0.0}",
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            CustomText(
                              txt: "(${productModel!.rating?.count ?? 0})",
                              size: 13,
                              clr: Colors.grey,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Divider(thickness: 1),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  spacing: 10,

                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomText(
                      txt: "Description",
                      fontWeight: FontWeight.bold,
                      size: 18,
                    ),
                    CustomText(
                      txt: "${productModel!.description}",
                      fontWeight: FontWeight.w600,
                      clr: AppColors.txtGrey,
                      size: 15,
                      maxLn: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        width: w,
        height: h*0.1,
        alignment: Alignment.center,
        child: CustomButton(
          shadowWant: false,
          w: w*0.8,
          h: h*0.06,
          tap: (){
            _addToCart(context);
          },
          txt: "Add to Cart",
        ),
      ),
    );
  }


  Future<void> _addToCart(BuildContext context) async {
    try {
      final cartItem = CartModel.fromJson(productModel!.toJson())..quantity =1;


      final cartRepository = CartRepository();
      await cartRepository.addToCart(cartItem);




      if (context.mounted) {
        AlertService().showSnackBar(

          context: context,
          color: Colors.black,
          msg: 'Item added to cart',

        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RepositoryProvider(
              create: (context) => CartRepository(),
              child: BlocProvider(
                create: (context) => CartBloc(
                  cartRepository: context.read<CartRepository>(),
                )..add(LoadCartEvent()),
                child: const CartScreen(),
              ),
            ),
          ),
        );
      }
    } catch (e) {

      if (context.mounted) {
        AlertService().showSnackBar(
          context: context,
          color: Colors.black,
          msg: 'Failed to add to cart: $e',

        );

      }
    }
  }
}
