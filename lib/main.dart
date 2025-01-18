import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:shop_app/layout/ecommerce_layout/cubit/cubit.dart';
import 'package:shop_app/modules/onboarding_screen.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/network/bloc_observer.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';
import 'package:shop_app/stripe_payment/stripe_keys.dart';
import 'package:shop_app/styles/themes.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
  DioHelper.int();
  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  Stripe.publishableKey = ApiKeys.publishableKey;
  Platform.isAndroid
      ?await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "Add Your Key",
        appId: "1:562406483193:android:ef7b0bddb9125a6988ee28",
        messagingSenderId: "562406483193",
        projectId: "israa-3",
        storageBucket:"israa-3.firebasestorage.app"
      ))
      :await Firebase.initializeApp();
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark,
    ));
    return MultiBlocProvider(
      providers: [
        BlocProvider(create:  (BuildContext context) => AppCubit()..getProductsData()..getUserImage(uId!))
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        home:const OnBoardingScreen(),
      ),
    );
  }




}
