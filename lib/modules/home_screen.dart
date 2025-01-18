import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/ecommerce_layout/cubit/cubit.dart';
import 'package:shop_app/layout/ecommerce_layout/cubit/states.dart';
import 'package:shop_app/models/product_model.dart';
import 'package:shop_app/modules/details_screen.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (BuildContext context, AppStates state) { },
      builder: (BuildContext context, AppStates state) {
        return Scaffold(
            body:ConditionalBuilder(
              condition: AppCubit.get(context).products.isNotEmpty,
              builder: (context) => buildWidget(AppCubit.get(context).products, context),
              fallback: (context) => Center(child: CircularProgressIndicator()),
            )
        );

      },
    );
  }


  Widget buildWidget(List<ProductModel> products,context) {
    String name = AppCubit.get(context).userModel?.name ?? CacheHelper.getData(key: 'name');

    return SingleChildScrollView(
    physics: BouncingScrollPhysics(),
  child: Container(
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left:20.0,right: 20.0),
            child: Row(
              children: [
                Text(
                  'MaxLook',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                Spacer(),
                Container(
                  width: 25.0,
                  height: 25.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color:Colors.black,
                  ),
                  child: Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.white,
                    size: 20.0,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric( horizontal: 20.0),
            child: Text(
              'Hello $name,',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 23.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric( horizontal: 20.0,vertical: 5.0),
            child: Text(
              'Discover and Get Great Items',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.grey[600],
              ),
            ),
          ),
          CarouselSlider(
            items:AppCubit.get(context).bannerImages,
            options:CarouselOptions(
              height: 250.0,
              initialPage: 0,
              enableInfiniteScroll: true,
              aspectRatio: 16/9,
              pageSnapping: true,
              enlargeCenterPage: true,
              viewportFraction: 1.0,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(seconds: 1),
              autoPlayCurve: Curves.fastOutSlowIn,
              scrollDirection: Axis.horizontal,
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              child: GridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount:2,
                  mainAxisSpacing: 15.0,
                  crossAxisSpacing: 15.0,
                  childAspectRatio: 1/1.6,
              children:List.generate(AppCubit.get(context).products.length, (index) => buildGridProduct(products[index],context)),
                  )
              ),
          ),
        ],
      ),
    ),
  );
  }
Widget buildGridProduct(ProductModel model,context)=>InkWell(
  onTap: (){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder:(context) => DetailsScreen(model:model ,),
        ),
    );
  },
  child: Material(
    elevation: 5.0,
    color: Colors.white,
    borderRadius: BorderRadius.circular(20.0),
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
            imageUrl: '${model.image}',
            height: 140.0,
            width: 140.0,
          ),
          const SizedBox(
            height: 5.0,
          ),
          Text(
            '${model.title}',
            maxLines: 2,
            overflow:TextOverflow.ellipsis,
            style:const TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              color: Colors.black,
              height: 1.3,
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          Text(
            '\$${model.price}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  ),
);

}
