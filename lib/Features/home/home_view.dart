import 'package:ecom/Core/Constants/app_colors.dart';
import 'package:ecom/Features/products/view/products_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../products/bloc/products_bloc.dart';
import '../products/respository/product_repository.dart';
import '../products/view/search/search_products_view.dart';
import '../profile/view/profile_view.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  ValueNotifier<int> selectIndex = ValueNotifier(0);

  final List _pages = [
    RepositoryProvider(
      create: (context) => ProductRepository(),
      child: BlocProvider(
        create: (context) =>
            ProductsBloc(RepositoryProvider.of<ProductRepository>(context))
              ..add(FetchProducts()),
        child: ProductsView(),
      ),
    ),
    SearchProductsView(),



    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.sizeOf(context).height;
    var w = MediaQuery.sizeOf(context).width;
    return ValueListenableBuilder(
      valueListenable: selectIndex,
      builder: (context, value, child) {
        return Scaffold(
          body: Container(
            height: h * 0.9,
            alignment: Alignment.center,
            child: _pages.elementAt(selectIndex.value),
          ),
          bottomNavigationBar: SizedBox(
            width: w,
            child: GNav(
              backgroundColor: AppColors.primaryColor,
              tabBorderRadius: 15,
              haptic: true,
              curve: Curves.easeOutExpo,
              duration: Duration(milliseconds: 900),
              tabBackgroundColor: Colors.white,
              onTabChange: (val) {
                selectIndex.value = val;
              },

              activeColor: AppColors.primaryColor,
              iconSize: 24,
              tabMargin: EdgeInsetsGeometry.all(8),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              // navigation bar padding
              tabs: [
                GButton(icon: Icons.home, text: 'Home'),

                GButton(icon: Icons.search, text: 'Search'),
                GButton(icon: Icons.account_circle, text: 'Profile'),
              ],
            ),
          ),
        );
      },
    );
  }
}
