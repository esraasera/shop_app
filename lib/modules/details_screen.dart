import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shop_app/layout/ecommerce_layout/cubit/cubit.dart';
import 'package:shop_app/layout/ecommerce_layout/cubit/states.dart';
import 'package:shop_app/models/cart_model.dart';
import 'package:shop_app/models/product_model.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/styles/colors.dart';

class DetailsScreen extends StatelessWidget {
  ProductModel model;
  DetailsScreen({
    required this.model,
  });
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {},
      builder: (BuildContext context, AppStates state) {
        return Scaffold(
          body:ConditionalBuilder(
            condition: model != null,
            builder: (BuildContext context) =>buildProductDetails(model ,AppCubit.get(context).model,context) ,
            fallback: (BuildContext context) => Center(child: CircularProgressIndicator()),
          ) ,
        );
      },
    );
  }
}

Widget buildProductDetails(ProductModel model,CartModel? cartModel,context) {
  final cubit = AppCubit.get(context);
  return SingleChildScrollView(
    physics: BouncingScrollPhysics(),
    child: Container(
      margin: EdgeInsets.only(
          top: 45.0,
          left: 20.0,
          right: 20.0
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios_new_outlined),
          ),
          SizedBox(
              height: 10.0
          ),
          CachedNetworkImage(
            imageUrl: '${model.image}',
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 2.5,
          ),
          SizedBox(
              height: 15.0
          ),
          Row(
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.red[300],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      'New',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  RatingBar.builder(
                    itemBuilder: (context,index)=>Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate:(rating){},
                    itemCount: 5,
                    allowHalfRating: true,
                    itemSize: 25.0,
                    initialRating: model.rating.rate.toDouble(),
                    ignoreGestures: true,
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    '(${model.rating.count})',
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              Spacer(),
              InkWell(
                onTap: (){
                  cubit.decrementQuantity(model.id, model.price);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.black,
                  ),
                  child: Icon(
                    Icons.remove_sharp,
                    color: Colors.white,),
                ),
              ),
              SizedBox(
                width: 20.0,
              ),
              Text(
                AppCubit.get(context).getProductQuantity(model.id).toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(
                width: 20.0,
              ),
              InkWell(
                onTap: () {
                  cubit.incrementQuantity(model.id, model.price.toDouble());
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.black,
                  ),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30.0,
          ),
          Text(
            '${model.description}',
            maxLines: AppCubit.get(context).isShown ? null : 3,
            overflow: TextOverflow.fade,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 13.0,
              fontFamily: 'Poppins',
            ),
          ),
          Center(
            child: TextButton(
              onPressed: () {
                AppCubit.get(context).changeText();
              },
              child: Text(
                AppCubit.get(context).isShown ? 'Show less' : 'Show more'  ,
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 14.0,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Row(
            children: [
              Text(
                'Delivery Time',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18.0,
                ),
              ),
              SizedBox(width: 40,),
              Row(
                children: [
                  Icon(
                    Icons.alarm,
                    color: Colors.grey,
                  ),
                  SizedBox(
                      width: 5.0
                  ),
                  Text(
                    '24h',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 70.0,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Price',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15.0,
                      ),
                    ),
                    Text(
                      '\$${(model.price * AppCubit.get(context).productNum).toStringAsFixed(2)}',
                      maxLines: 1,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18.0,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Spacer(),


                InkWell(
                  onTap: (){
                    openEdit(model,context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    width: MediaQuery.of(context).size.width /2,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.black
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Add To Cart',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily:'Poppins',
                          ),
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        Container(
                          padding: EdgeInsets.all(3),
                          child:Icon(
                            Icons.shopping_cart_outlined,
                            color: Colors.white,
                            size: 20.0,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.grey,
                          ),
                        ),
                      ],
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




Future openEdit(ProductModel model,context)async {
  final cubit = AppCubit.get(context);
  await showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
              backgroundColor: Colors.white,
              content: SingleChildScrollView(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.cancel,
                          )),
                      SizedBox(height: 20.0,),
                      Text(
                        'Add this item to your cart ?',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              cubit.sendCartItem(
                                image: '${model.image}',
                                name: model.title,
                                price: model.price.toDouble(),
                                dateTime: DateTime.now().toString(),
                                quantity: cubit.getProductQuantity(model.id),
                                total: (model.price.toDouble() * AppCubit.get(context).productNum.toDouble()),
                                id:uId!,
                                context: context,
                              );
                            },
                            child: Container(
                              width: 100,
                              padding: EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                color: defaultColor,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: Text(
                                  'add',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 100,
                              padding: EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: Text(
                                  'cancel',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
          )
  );
}