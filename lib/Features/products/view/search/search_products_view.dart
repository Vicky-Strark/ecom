import 'package:ecom/Features/products/bloc/products_bloc.dart';
import 'package:ecom/Features/products/respository/product_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Core/core.dart';
import '../../../../Shared/shared.dart';
import '../product_details_view.dart';

class SearchProductsView extends StatefulWidget {
  const SearchProductsView({super.key});

  @override
  State<SearchProductsView> createState() => _SearchProductsViewState();
}

class _SearchProductsViewState extends State<SearchProductsView> {
  final TextEditingController _searchController = TextEditingController();
  String _sortOrder = 'none'; // 'none', 'lowToHigh', 'highToLow'

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<dynamic> _filterAndSortProducts(List<dynamic> products, String query, String sortOrder) {
    // Filter by search query
    List<dynamic> filteredProducts = products.where((product) {
      final title = product.title?.toString().toLowerCase() ?? '';
      return title.contains(query.toLowerCase());
    }).toList();

    // Sort by price
    if (sortOrder == 'lowToHigh') {
      filteredProducts.sort((a, b) {
        final priceA = a.price ?? 0.0;
        final priceB = b.price ?? 0.0;
        return priceA.compareTo(priceB);
      });
    } else if (sortOrder == 'highToLow') {
      filteredProducts.sort((a, b) {
        final priceA = a.price ?? 0.0;
        final priceB = b.price ?? 0.0;
        return priceB.compareTo(priceA);
      });
    }

    return filteredProducts;
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          txt: "Search",
          clr: Colors.white,
          fontWeight: FontWeight.w800,
          size: 18,
        ),
        actions: [
          Padding(
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
        ],
        elevation: 0,
        backgroundColor: AppColors.primaryColor,
      ),
      body: RepositoryProvider(
        create: (context) => ProductRepository(),
        child: BlocProvider(
          create: (context) =>
          ProductsBloc(RepositoryProvider.of<ProductRepository>(context))
            ..add(SearchProducts()),
          child: Column(
            children: [
              // Fixed header section
              Container(
                width: w,
                color: AppColors.primaryColor,
                padding: EdgeInsets.all(15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 7,
                  children: [
                    // Search field
                    TextField(
                      controller: _searchController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Search products...",
                        hintStyle: TextStyle(color: Colors.white),
                        prefixIcon: Icon(Icons.search, color: Colors.white),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                          icon: Icon(Icons.clear, color: Colors.white),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                            });
                          },
                        )
                            : null,
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                    // Sort buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _sortOrder = _sortOrder == 'lowToHigh' ? 'none' : 'lowToHigh';
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: _sortOrder == 'lowToHigh'
                                  ? Colors.white.withOpacity(0.3)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              spacing: 10,
                              children: [
                                Icon(
                                  Icons.arrow_upward,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                CustomText(
                                  txt: "Low to High",
                                  clr: Colors.white,
                                  size: 13,
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _sortOrder = _sortOrder == 'highToLow' ? 'none' : 'highToLow';
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: _sortOrder == 'highToLow'
                                  ? Colors.white.withOpacity(0.3)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              spacing: 10,
                              children: [
                                Icon(
                                  Icons.arrow_downward,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                CustomText(
                                  txt: "High to Low",
                                  clr: Colors.white,
                                  size: 13,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Expandable list section
              Expanded(
                child: BlocConsumer<ProductsBloc, ProductsState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    if (state is ProductLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is SearchProductsLoadedState) {
                      final filteredProducts = _filterAndSortProducts(
                        state.oldProducts,
                        _searchController.text,
                        _sortOrder,
                      );

                      if (filteredProducts.isEmpty) {
                        return Center(
                          child: CustomText(
                            txt: _searchController.text.isEmpty
                                ? "No products available"
                                : "No products found for '${_searchController.text}'",
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
                          final rating = product.rating?.rate ?? 0.0;
                          final ratingCount = product.rating?.count ?? 0;

                          return Card(
                            margin: EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 8,
                            ),
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetailsView(
                                  productModel: product,
                                )));
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Padding(
                                padding: EdgeInsets.all(12),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Product Image
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Container(
                                        width: 100,
                                        height: 100,
                                        color: Colors.grey[200],
                                        child: Image.network(
                                          product.image ?? '',
                                          fit: BoxFit.contain,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Icon(
                                              Icons.image_not_supported,
                                              size: 40,
                                              color: Colors.grey,
                                            );
                                          },
                                          loadingBuilder: (context, child, loadingProgress) {
                                            if (loadingProgress == null) return child;
                                            return Center(
                                              child: CircularProgressIndicator(
                                                value: loadingProgress.expectedTotalBytes != null
                                                    ? loadingProgress.cumulativeBytesLoaded /
                                                    loadingProgress.expectedTotalBytes!
                                                    : null,
                                                strokeWidth: 2,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    // Product Details
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Product Title
                                          CustomText(
                                            txt: "${product.title}",
                                            fontWeight: FontWeight.w600,
                                            size: 15,
                                            maxLn: 2,
                                          ),
                                          SizedBox(height: 6),
                                          // Category
                                          if (product.category != null)
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: AppColors.primaryColor.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: CustomText(
                                                txt: "${product.category}",
                                                size: 11,
                                                clr: AppColors.primaryColor,
                                              ),
                                            ),
                                          SizedBox(height: 8),
                                          // Rating
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                                size: 18,
                                              ),
                                              SizedBox(width: 4),
                                              CustomText(
                                                txt: "${rating.toStringAsFixed(1)}",
                                                fontWeight: FontWeight.w600,
                                                size: 13,
                                              ),
                                              SizedBox(width: 4),
                                              CustomText(
                                                txt: "($ratingCount)",
                                                clr: Colors.grey[600],
                                                size: 12,
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          // Price
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              CustomText(
                                                txt: "₹${product.price?.toStringAsFixed(2) ?? '0.00'}",
                                                clr: AppColors.primaryColor,
                                                fontWeight: FontWeight.bold,
                                                size: 16,
                                              ),
                                              Icon(
                                                Icons.arrow_forward_ios,
                                                size: 14,
                                                color: Colors.grey,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else if (state is ProductError) {
                      return Center(child: CustomText(txt: state.message));
                    }
                    return Center(
                      child: CustomText(txt: "Start searching for products"),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}