import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/ecommerce_layout/cubit/cubit.dart';
import 'package:shop_app/layout/ecommerce_layout/cubit/states.dart';
import 'package:shop_app/models/cart_model.dart';
import 'package:shop_app/styles/colors.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {},
      builder: (BuildContext context, AppStates state) {
        var cubit =AppCubit.get(context);
        return Scaffold(
          body: Container(
            margin: const EdgeInsets.only(top: 50.0),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Material(
        elevation: 2.0,
        child: Container(
        padding: const EdgeInsets.only(bottom: 10.0),
        decoration: const BoxDecoration(
        color: Colors.white,
        ),
        child: const Center(
        child: Text(
        'Your Cart',
        style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 25.0,
        fontFamily: 'Poppins',
        ),
        ),
        ),
        ),
        ),
      const SizedBox(
        height: 20.0,
       ),
          Expanded(
            child: ConditionalBuilder(
              condition: AppCubit.get(context).cartItems.isNotEmpty,
              builder: (BuildContext context) {
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) => CartItems(AppCubit.get(context).cartItems[index], context),
                  itemCount: AppCubit.get(context).cartItems.length,
                );
              },
              fallback: (BuildContext context) => Center(child: CircularProgressIndicator(color: defaultColor,)),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.only(right: 10.0,left: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Price',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    fontSize: 20.0,
                  ),
                ),
                Text(
                  '\$${cubit.cartItems.isEmpty ? 0.0 :cubit.getCartTotal().toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    fontSize: 20.0,
                  ),
                ),


              ],
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Container(
            margin: EdgeInsets.only(left: 20.0,right: 20.0,bottom: 20.0),
            padding: EdgeInsets.symmetric(vertical: 10.0),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Center(
              child: InkWell(
                onTap: (){
                  AppCubit.get(context).checkout(context);
                },
                child: Text(
                  'CheckOut',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          ]
        )
        )
        );
      },
    );
  }

  Widget CartItems(CartModel model,context) => Container(
                margin: EdgeInsets.only(right: 20.0,left: 20.0,bottom: 20.0),
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Container(
                          height: 70.0,
                          width: 30.0,
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Center(
                            child: Text(model.quantity.toString()),
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        CachedNetworkImage(
                          imageUrl: model.image!,
                          height: 70.0,
                          width: 70.0,
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                model.name!,
                                maxLines:1,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                  fontSize: 15.0,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                '\$${model.total}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                  fontSize: 15.0,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
  )
  );

}
