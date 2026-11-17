import 'package:e_commerce_app/core/routing/app_routes.dart';
import 'package:e_commerce_app/core/styling/app_assets.dart';
import 'package:e_commerce_app/core/styling/app_styles.dart';
import 'package:e_commerce_app/core/utils/service_locator.dart';
import 'package:e_commerce_app/core/utils/storage_helper.dart';
import 'package:e_commerce_app/core/widgets/primay_button_widget.dart';
import 'package:e_commerce_app/core/widgets/spacing_widgets.dart';
import 'package:e_commerce_app/features/account/widgets/account_item_widget.dart';

import 'package:material_ui/material_ui.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: Container(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: const Divider(),
          ),
          const HeightSpace(20),
          AccountItemWidget(
            iconPath: AppAssets.box,
            title: "My Orders",
            onTap: () {},
          ),
          const Divider(
            thickness: 8,
            color: Color(0xffE6E6E6),
          ),
          AccountItemWidget(
            iconPath: AppAssets.details,
            title: "My Details",
            onTap: () {},
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: const Divider(),
          ),
          AccountItemWidget(
            iconPath: AppAssets.address,
            title: "Address Book",
            onTap: () {
              context.pushNamed(AppRoutes.addressScreen);
            },
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: const Divider(),
          ),
          AccountItemWidget(
            iconPath: AppAssets.question,
            title: "FAQ",
            onTap: () {},
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: const Divider(),
          ),
          AccountItemWidget(
            iconPath: AppAssets.help,
            title: "Help Center",
            onTap: () {},
          ),
          const HeightSpace(16),
          Divider(
            thickness: 8,
            color: Color(0xffE6E6E6),
          ),
          const Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: InkWell(
              onTap: () {
                showLogotDialog(context);
              },
              child: Row(
                children: [
                  Icon(
                    Icons.logout,
                    color: Colors.redAccent,
                    size: 25.sp,
                  ),
                  const WidthSpace(8),
                  Text(
                    "Logout",
                    style: AppStyles.black15BoldStyle
                        .copyWith(color: Colors.redAccent),
                  ),
                ],
              ),
            ),
          ),
          const HeightSpace(20),
        ],
      ),
    );
  }
  // ignore: strict_top_level_inference
  void showLogotDialog(BuildContext context){
    showDialog(context: context
    , builder: (context) {
      return Dialog(
        backgroundColor: Colors.white,
        
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        child: SizedBox(
          width: 370,
          height: 350,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                    HeightSpace(20.h),
          
             Image.asset(AppAssets.vector,
             width:59.w,
             height: 59.h,
             ),
          HeightSpace(12.h),
          Text("Logout?",style: AppStyles.black18BoldStyle.copyWith(fontSize: 20.sp),),
                        HeightSpace(8.h),
                                      Text("Are you sure you want to logout?",style: AppStyles.grey12MediumStyle.copyWith(fontSize: 16.sp),),
                                       HeightSpace(24.h),
          
                 PrimayButtonWidget(
                  width: 280.w,
                  height:54 ,
                  onPress: (){
      
                    context.pushReplacementNamed(AppRoutes.loginScreen);
                    // context.read<AuthCubit>().logOutUsers;
                       // عشان احذف التوكن 
          sl<StorageHelper>().removeToken();
      
                  },
                  buttonColor: Colors.red,
                  buttonText: "Yes, Logout",
                  textColor: Colors.white,
                  fontSize: 16.sp,
                 ),
                         HeightSpace(12.h),
                           PrimayButtonWidget(
                            width: 280.w,
                            height:54 ,
                            onPress: (){
                              context.pop();
                            },
                            buttonColor: Colors.white,
                            buttonText: "No, Cancel",
                            textColor: Colors.black,
                            fontSize: 16.sp,
                           ),
          
          ],),
        )
        );
    },);
  }
}
