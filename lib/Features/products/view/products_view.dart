import 'package:ecom/Core/Constants/app_colors.dart';
import 'package:ecom/Core/Constants/app_strings.dart';
import 'package:ecom/Core/core.dart';
import 'package:ecom/Features/products/view/product_details_view.dart';
import 'package:ecom/Shared/Widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_ui/hive_ui.dart';

import '../../../Shared/shared.dart';
import '../../cart/bloc/cart_bloc.dart';
import '../../cart/model/cart_model.dart';
import '../../cart/repository/cart_repository.dart';
import '../../cart/view/cart_view.dart';
import '../bloc/products_bloc.dart';
import '../model/product_model.dart';

class ProductsView extends StatefulWidget {
  const ProductsView({super.key});

  @override
  State<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  Future<void> _onRefresh() async {
    context.read<ProductsBloc>().add(RefreshProducts());
  }

  Map<String, List<ProductModel>> _groupProductsByCategory(
      List<ProductModel> products) {
    Map<String, List<ProductModel>> categoryMap = {};

    for (var product in products) {
      String category = product.category ?? 'Others';
      if (!categoryMap.containsKey(category)) {
        categoryMap[category] = [];
      }
      categoryMap[category]!.add(product);
    }

    return categoryMap;
  }

  String _formatCategoryName(String category) {
    return category.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primaryColor,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(

            backgroundColor: Colors.white,
            radius: 25,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(AppAssets.logo),
            ),
          ),
        ),
        title: CustomText(
          txt: AppString.appName,
          size: 18,
          clr: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        actions: [

          Stack(
            children: [

              IconButton(
                onPressed: () {
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
                },
                icon: const Icon(Icons.shopping_cart, color: Colors.white),
              ),
              // Cart Item Count Badge
              Positioned(
                right: 8,
                top: 8,
                child: FutureBuilder<int>(
                  future: _getCartItemCount(),
                  builder: (context, snapshot) {
                    final count = snapshot.data ?? 0;
                    if (count == 0) return const SizedBox.shrink();

                    return Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.deepPurpleAccent,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Text(
                        count > 99 ? '99+' : count.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocBuilder<ProductsBloc, ProductsState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProductError) {
            print(state.message);
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomText(
                    txt: state.message,
                    clr: Colors.red,
                    size: 14,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ProductsBloc>().add(FetchProducts());
                    },
                    child: CustomText(
                      txt: "Retry",
                      clr: Colors.white,
                      size: 14,
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is ProductLoaded) {
            final products = state.products;

            if (products.isEmpty) {
              return Center(
                child: CustomText(
                  txt: "No products found",
                  size: 16,
                  clr: Colors.grey,
                ),
              );
            }

            final categoryMap = _groupProductsByCategory(products);
            final categories = categoryMap.keys.toList();

            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final categoryProducts = categoryMap[category]!;

                  return CategorySection(
                    categoryName: _formatCategoryName(category),
                    products: categoryProducts,
                    onCartUpdate: () {
                      // Refresh the cart count badge
                      setState(() {});
                    },
                  );
                },
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  // Get cart item count
  Future<int> _getCartItemCount() async {
    try {
      final cartRepository = CartRepository();
      final cartItems = await cartRepository.fetchCart();
      return cartItems.length;
    } catch (e) {
      return 0;
    }
  }
}



class CategorySection extends StatelessWidget {
  final String categoryName;
  final List<ProductModel> products;
  final VoidCallback? onCartUpdate;

  const CategorySection({
    super.key,
    required this.categoryName,
    required this.products,
    this.onCartUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                txt: categoryName,
                size: 18,
                fontWeight: FontWeight.bold,
              ),
              TextButton(
                onPressed: () {
                  // Navigate to see all products in this category
                },
                child: CustomText(
                  txt: 'See All',
                  clr: AppColors.primaryColor,
                  size: 14,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 240,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: SizedBox(
                  width: 160,
                  child: ProductCard(
                    product: products[index],
                    onCartUpdate: onCartUpdate,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onCartUpdate;

  const ProductCard({
    super.key,
    required this.product,
    this.onCartUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetailsView(
            productModel: product,
          )));

        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  product.image ?? '',
                  fit: BoxFit.contain,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image,
                      size: 50, color: Colors.grey),
                ),
              ),
            ),

            // Product Info
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        txt: product.title ?? "Unnamed",
                        maxLn: 2,
                        size: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(height: 4),
                      CustomText(
                        txt: "\$${product.price?.toStringAsFixed(2) ?? '0.00'}",
                        clr: Colors.green,
                        fontWeight: FontWeight.bold,
                        size: 14,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 14),
                          const SizedBox(width: 4),
                          CustomText(
                            txt: "${product.rating?.rate ?? 0.0}",
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          CustomText(
                            txt: "(${product.rating?.count ?? 0})",
                            size: 11,
                            clr: Colors.grey,
                          ),

                        ],
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () async {
                        await _addToCart(context);
                      },
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addToCart(BuildContext context) async {
    try {
      final cartItem = CartModel(
        id: product.id,
        title: product.title,
        price: product.price,
        image: product.image,
        quantity: 1,
        category: product.category,
      );


      final cartRepository = CartRepository();
      await cartRepository.addToCart(cartItem);

      if (onCartUpdate != null) {
        onCartUpdate!();
      }


      if (context.mounted) {
        AlertService().showSnackBar(

          context: context,
          color: Colors.black,
          msg: 'Item added to cart',

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