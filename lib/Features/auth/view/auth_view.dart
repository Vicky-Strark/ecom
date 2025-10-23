import 'package:ecom/Core/Constants/app_colors.dart';
import 'package:ecom/Core/core.dart';
import 'package:ecom/Features/auth/bloc/auth_bloc.dart';
import 'package:ecom/Features/auth/repository/auth_repository.dart';
import 'package:ecom/Features/home/home_view.dart';
import 'package:ecom/Shared/Widget/custom_button.dart';
import 'package:ecom/Shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthView extends StatelessWidget {
  AuthView({super.key});

  TextEditingController userNameController = TextEditingController(text: "mor_2314");
  TextEditingController passwordController = TextEditingController(text: "83r5^_");

  ValueNotifier<bool> isShow = ValueNotifier(false);

  GlobalKey<FormState> _fromKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.sizeOf(context).height;
    var w = MediaQuery.sizeOf(context).width;
    return Scaffold(
      body: Container(
        height: h,
        width: w,
        color: AppColors.primaryColor,
        alignment: Alignment.center,
        padding: EdgeInsets.all(20),
        child: Card(
          child: Form(
            key: _fromKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 15,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: h * 0.02),
                  Container(
                    width: w*0.25,
                      height: h*0.1,
                      child: Image.asset(AppAssets.logo)),
                  Container(

                    alignment: Alignment.center,
                    // padding: EdgeInsets.all(8),
                    width: w * 0.8,
                    child: CustomText(
                      txt: "Welcome To ${AppString.appName}",
                      textAlign: TextAlign.left,
                      size: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  CustomTextFormField(
                    w: 10,
                    controller: userNameController,

                    // radius: 20,
                    hintTxt: "User Name",
                    manitTxt: "User Name",

                    fillClr: AppColors.secondaryColor,
                    preffix: Icon(
                      Icons.account_circle,
                      size: 20,
                      color: AppColors.primaryColor,
                    ),
                  ),

                  ValueListenableBuilder(
                    valueListenable: isShow,
                    builder: (context, val, child) {
                      return CustomTextFormField(
                        w: 10,
                        hintTxt: "PassWord",
                        manitTxt: "PassWord",
                        controller: passwordController,
                        obscure: isShow.value,
                        fillClr: AppColors.secondaryColor,
                        preffix: Icon(
                          Icons.lock_open_rounded,
                          size: 20,
                          color: AppColors.primaryColor,
                        ),
                        suffix: InkWell(
                          onTap: () {
                            isShow.value = !isShow.value;
                          },
                          child: isShow.value
                              ? Icon(
                                  Icons.remove_red_eye,
                                  color: AppColors.txtGrey,
                                  size: 18,
                                )
                              : Icon(
                                  Icons.remove_red_eye,
                                  color: AppColors.primaryColor,
                                  size: 18,
                                ),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: h * 0.02),

                  RepositoryProvider(
                    create: (context) => AuthRepository(),
                    child: BlocProvider(
                      create: (context) => AuthBloc(
                        authRepository: RepositoryProvider.of<AuthRepository>(
                          context,
                        ),
                      ),
                      child: BlocConsumer<AuthBloc, AuthState>(
                        listener: (context, state) {

                          if(state is AuthErrorState){
                            AlertService().showSnackBar(
                              context: context,
                              color: Colors.black,
                              msg: state.erMsg
                            );
                          }
                          else if (state is AuthSuccessState){
                            AlertService().showSnackBar(
                                context: context,
                                color: Colors.green,
                                msg: AppString.loginSuccess
                            );

                            Navigator.popUntil(
                                context, (route) => route.isFirst);
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeView()));
                          }


                        },
                        builder: (context, state) {
                          if(state is AuthLoadingState){
                            return Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primaryColor,
                              ),
                            );
                          }
                          return CustomButton(
                            txt: "Login",
                            w: w * 0.7,
                            shadowWant: false,
                            tap: (){
                              if(_fromKey.currentState!.validate()){
                                context.read<AuthBloc>().add(
                                    ClickAuthEvent(userNameController.text, passwordController.text)
                                );
                              }

                            },
                          );
                        },
                      ),
                    ),
                  ),

                  SizedBox(height: h * 0.05),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
