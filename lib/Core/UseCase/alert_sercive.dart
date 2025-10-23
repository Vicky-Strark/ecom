
import 'package:ecom/Core/UseCase/shared_service.dart';
import 'package:ecom/Features/auth/view/auth_view.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../Shared/shared.dart';
import '../core.dart';





mixin class AlertService {
  showSnackBar({context, msg, isEr,color}) async {

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 2),
behavior: SnackBarBehavior.floating,

      shape: const StadiumBorder(),
      content: CustomText(
        txt: msg.toString(),
        clr: Colors.white,

      ),
      backgroundColor: color != null? color: isEr == true ? Colors.red : Colors.green,
    ));
  }

  showOwner({h, context, w, data, controller}) async {

    var selectedData ;
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              contentPadding: EdgeInsets.all(1),
              titlePadding: EdgeInsets.all(10),
              title: CustomText(txt: "Process Owner"),
              content: Container(
                height: h * 0.5,
                width: w,
                child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          setState(() {
                            controller = data[index]["name"].toString();
                          });
                          Navigator.pop(context);
                        },

                        // tileColor: AppColors.primaryColor.withOpacity(0.4),
                        leading: Icon(
                          Icons.person,
                          color: AppColors.primaryColor,
                          size: 15,
                        ),
                        minLeadingWidth: 20,

                        title: CustomText(
                            txt: data[index]["name"],
                            fontWeight: FontWeight.w600),
                        subtitle: CustomText(
                            txt: data[index]["position"],
                            fontWeight: FontWeight.w600),
                      );
                    }),
              ),
            );
          });
        });


  }

  // void showDeleteDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text("Confirm Delete"),
  //         content: Text("Are you sure you want to delete this item?"),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop(); // Close the dialog
  //             },
  //             child: Text("Cancel"),
  //           ),
  //           ElevatedButton(
  //             style: ElevatedButton.styleFrom(
  //               backgroundColor: Colors.red,
  //             ),
  //             onPressed: () {
  //               // Handle the delete action here
  //               Navigator.of(context).pop(); // Close the dialog
  //             },
  //             child: Text("Delete"),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }





   void showDeleteDialog(BuildContext context, {Function()? confirm}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(""),
          content: Container(
            height: 135,
            child: Column(
              children: [
                const Icon(Icons.error_rounded,size: 75,color: AppColors.primaryColor,),
                CustomText(txt:"Confirm",fontWeight: FontWeight.w700,size: 15,),
                const SizedBox(
                  height: 10,
                ),
                CustomText(txt: "Are You Sure Want to Remove",),




              ],
            ),
          ),

          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade700,
                    elevation: 0
                  ),
                  onPressed: (){
                    Navigator.pop(context);
                  },

                  child: CustomText(txt: "No",size: 15,clr: Colors.white,),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    elevation: 0
                  ),
                  onPressed: confirm ?? (){},
                  // onPressed: () {
                  //   // Handle the delete action here
                  //   Navigator.of(context).pop(); // Close the dialog
                  // },
                  child: CustomText(txt: "Yes",size: 15,),
                ),
              ],
            )
          ],

        );
      },
    );
  }


  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: CustomText(txt: "Confirm Logout",size: 18,fontWeight: FontWeight.bold,),
          content: CustomText(txt: "Are You Sure want to Logout",size: 15,fontWeight: FontWeight.w700,),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: CustomText(txt: "No"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor),
              onPressed: () async{
                SharedPrefService().clearAll();

                await Hive.close();
                await Hive.deleteFromDisk();
                Navigator.of(context).popUntil((route) => route.isFirst);
                Navigator.push(context, MaterialPageRoute(builder: (context)=>AuthView()));

              },
              child:  CustomText(txt: "Yes"),
            ),
          ],
        );
      },
    );
  }

}
