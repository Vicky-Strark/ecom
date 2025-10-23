import 'package:ecom/Features/profile/bloc/profile_bloc.dart';
import 'package:ecom/Features/profile/repository/profile_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Core/core.dart';
import '../../../../Shared/shared.dart';

class ProfileView extends StatelessWidget {


  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          txt: "Profile",
          clr: Colors.white,
          fontWeight: FontWeight.w800,
          size: 18,
        ),
        backgroundColor: AppColors.primaryColor,

      ),
      body: RepositoryProvider(
        create: (context) => ProfileRepository(),
        child: BlocProvider(
          create: (context) => ProfileBloc(
            RepositoryProvider.of<ProfileRepository>(context),
          )..add(LoadProfileEvent(userId: 2)),
          child: BlocConsumer<ProfileBloc, ProfileState>(
            listener: (context, state) {
              if (state is ProfileErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.erMsg ?? 'An error occurred'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is ProfileLoadingState) {
                return Center(child: CircularProgressIndicator());
              } else if (state is ProfileLoadedState) {
                final profile = state.profileModel;

                if (profile == null) {
                  return Center(child: CustomText(txt: "No profile data"));
                }

                return SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    spacing: 12,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Row(
                            spacing: 10,
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: AppColors.primaryColor,
                                child: Icon(
                                  Icons.person,
                                  size: 50,
                                  color: Colors.white,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                spacing: 5,
                                children: [
                                  CustomText(
                                    txt: "${profile.name?.firstname ?? ''} ${profile.name?.lastname ?? ''}",
                                    fontWeight: FontWeight.bold,
                                    size: 22,
                                  ),
                                  CustomText(
                                    txt: "@${profile.username ?? ''}",
                                    clr: Colors.grey[600],
                                    size: 14,
                                  ),
                                ],
                              ),

                            ],
                          ),
                        ),
                      ),


                      _buildSectionTitle("Contact Information"),

                      _buildInfoCard(
                        icon: Icons.email,
                        title: "Email",
                        value: profile.email ?? 'N/A',
                      ),

                      _buildInfoCard(
                        icon: Icons.phone,
                        title: "Phone",
                        value: profile.phone ?? 'N/A',
                      ),


                      if (profile.address != null) ...[
                        _buildSectionTitle("Address"),

                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: AppColors.primaryColor,
                                      size: 20,
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          CustomText(
                                            txt: "${profile.address!.street ?? ''}, ${profile.address!.number ?? ''}",
                                            fontWeight: FontWeight.w600,
                                            size: 15,
                                          ),
                                          SizedBox(height: 5),
                                          CustomText(
                                            txt: "${profile.address!.city ?? ''}, ${profile.address!.zipcode ?? ''}",
                                            clr: Colors.grey[600],
                                            size: 13,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],

                     Divider(
                       thickness: 1,
                     ),
                      InkWell(
                        onTap: (){
                          AlertService().showLogoutDialog(context);
                        },
                        child: Row(
                          spacing: 10,
                          children: [
                            Icon(Icons.login,color: AppColors.txtGrey,),
                            CustomText(txt: "Logout",size: 15,)
                          ],
                        ),
                      ),

                    ],
                  ),
                );
              } else if (state is ProfileErrorState) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 60, color: Colors.red),
                      SizedBox(height: 20),
                      CustomText(
                        txt: state.erMsg ?? "An error occurred",
                        size: 16,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          context.read<ProfileBloc>().add(
                            LoadProfileEvent(userId: 2),
                          );
                        },
                        child: Text("Retry"),
                      ),
                    ],
                  ),
                );
              }

              return Center(child: CustomText(txt: "No data available"));
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return CustomText(
      txt: title,
      fontWeight: FontWeight.bold,
      size: 18,
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: AppColors.primaryColor,
                size: 24,
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    txt: title,
                    clr: Colors.grey[600],
                    size: 12,
                  ),
                  SizedBox(height: 4),
                  CustomText(
                    txt: value,
                    fontWeight: FontWeight.w600,
                    size: 15,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}