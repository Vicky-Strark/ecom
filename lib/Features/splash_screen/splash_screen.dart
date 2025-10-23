import 'package:ecom/Core/Constants/app_assets.dart';
import 'package:ecom/Core/Constants/app_colors.dart';
import 'package:ecom/Core/Constants/app_strings.dart';
import 'package:ecom/Core/UseCase/shared_service.dart';
import 'package:ecom/Features/auth/view/auth_view.dart';
import 'package:ecom/Features/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import '../products/bloc/products_bloc.dart';
import '../products/respository/product_repository.dart';
import '../products/view/products_view.dart';

class AnimatedSplashScreen extends StatefulWidget {


  const AnimatedSplashScreen({
    super.key,
  });

  @override
  State<AnimatedSplashScreen> createState() => _AnimatedSplashScreenState();
}

class _AnimatedSplashScreenState extends State<AnimatedSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Fade animation
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    // Scale animation
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    // Start animation
    _controller.forward();

    // Check authentication and navigate
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Wait for animation and minimum splash duration
    await Future.delayed(const Duration(seconds: 3));

    // Check if user is logged in
    final isLoggedIn = await _checkUserLogin();

    if (!mounted) return;

    // Navigate to appropriate screen
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
        isLoggedIn ?


        HomeView()   : AuthView(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  Future<bool> _checkUserLogin() async {
    try {

      final token = await SharedPrefService().getAuthToken();

      return token != null && token.isNotEmpty;
    } catch (e) {
      print('Error checking login status: $e');
      return false; // Default to not logged in on error
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // App Logo/Icon
                    Container(
                      width: 120,
                      height: 120,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child:Image.asset(
                        AppAssets.logo
                      )
                    ),
                    const SizedBox(height: 30),

                    // App Name
                    Text(
                      AppString.appName,
                      style: const TextStyle(
                        fontFamily: "AvenirArabic",
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Tagline
                    const Text(
                      "Shop Smarter, Live Better",
                      style: TextStyle(
                        fontFamily: "AvenirArabic",
                        fontSize: 14,
                        color: Colors.white70,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 50),

                    // Loading indicator
                    const SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 3,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}