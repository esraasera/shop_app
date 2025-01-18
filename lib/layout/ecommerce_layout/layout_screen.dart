import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/ecommerce_layout/cubit/cubit.dart';
import 'package:shop_app/layout/ecommerce_layout/cubit/states.dart';

class LayoutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (BuildContext context, AppStates state) {  },
      builder: (BuildContext context, AppStates state) {
        var cubit = AppCubit.get(context);
        return SafeArea(
          child: Scaffold(
            body:cubit.screens[cubit.currentIndex],

            bottomNavigationBar: CurvedNavigationBar(
              onTap: (int index){
                 cubit.changeNavCurrentIndex(index);
              },
              index: cubit.currentIndex,
              height: 70.0,
              backgroundColor: Colors.white,
              color: Colors.black,
              animationDuration: Duration(milliseconds: 500),
              items: [
                Icon(
                  Icons.home_outlined,
                  color: Colors.white,
                ),
                Icon(
                  Icons.shopping_bag_outlined,
                  color: Colors.white,
                ),
                Icon(
                  Icons.wallet_outlined,
                  color: Colors.white,
                ),
                Icon(
                  Icons.person_outline,
                  color: Colors.white,
                ),
              ],

            ),
          ),
        );

      },
    );
  }
}
