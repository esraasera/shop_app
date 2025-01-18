import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shop_app/layout/ecommerce_layout/cubit/cubit.dart';
import 'package:shop_app/models/user_model.dart';
import 'package:shop_app/modules/login/cubit/states.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';

class AppLoginCubit extends Cubit<AppLoginStates> {

  AppLoginCubit() : super(AppLoginInitialState());

  static AppLoginCubit get(context) => BlocProvider.of(context);

  UserModel? model ;

  void userCreate({
    required String? name,
    String? image,
    required String email,
    required String uId,
    required BuildContext context,
  }) async {
    try {
      final userDocRef = FirebaseFirestore.instance.collection('users').doc(uId);

      final userSnapshot = await userDocRef.get();

      if (!userSnapshot.exists) {
        model = UserModel(
          email: email,
          uId: uId,
          wallet: '0',
          image: image ?? 'https://icons.veryicon.com/png/o/miscellaneous/graph-library/person-liable-1.png',
          name: name ?? ' ',
        );

        await userDocRef.set(model!.toMap());

        CacheHelper.saveData(key: 'wallet', value: "0");
      } else {
      }

      AppCubit.get(context).getUserData();
      AppCubit.get(context).getCartItems();
      emit(AppCreateUserSuccessState(uId));
    } catch (error) {
      emit(AppCreateUserErrorState(error.toString()));
    }
  }




  void userLogin({
    required String email,
    required String password,
    required BuildContext context,
  }) {
    emit(AppLoginLoadingState());
         FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
         final String uId = value.user!.uid;

        CacheHelper.saveData(key: 'uId', value: uId);

        FirebaseFirestore.instance.collection('users').doc(uId).get().then((doc) {
        if (doc.exists) {
          String wallet = doc.data()?['wallet'] ?? '0';
          CacheHelper.saveData(key: 'wallet', value: wallet);

          AppCubit.get(context).userModel = UserModel.fromJson(doc.data() as Map<String, dynamic>);
        }
      }).catchError((error) {
      });
      AppCubit.get(context).getUserData();
      AppCubit.get(context).getCartItems();
      emit(AppLoginSuccessState(uId));
    }).catchError((error) {
      emit(AppLoginErrorState(error.toString()));
    });
  }




  bool isPassword = true ;
  IconData suffixIcon =Icons.visibility_outlined ;

  void changeSuffixIcon(){
    isPassword = ! isPassword ;
    suffixIcon = isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined  ;
    emit(AppChangeSuffixIconState());
  }



  Future signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return;
      }

      final GoogleSignInAuthentication? googleAuth = await googleUser.authentication;

      final AuthCredential googleCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );


      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(googleCredential);

      final User? user = userCredential.user;

      if (user != null) {
        final String? email = user.email;
        final String? name = user.displayName;
        final String? photoUrl = user.photoURL;
        final String uId = user.uid;

        CacheHelper.saveData(key: 'uId', value: uId);
        CacheHelper.saveData(key: 'name', value: name);
        CacheHelper.saveData(key: 'email', value: email);
        CacheHelper.saveData(key: 'image', value: photoUrl);


        if (uId.isNotEmpty) {
          FirebaseFirestore.instance.collection('users').doc(uId).get().then((doc) {
            if (doc.exists) {
              final wallet = doc.data()?['wallet'] ?? '0';
              CacheHelper.saveData(key: 'wallet', value: wallet);
              userCreate(
                email: email ?? '',
                uId: uId,
                name: name ?? '',
                image: photoUrl,
                context: context,
              );
            } else {
              showToast(
                  text: "User not found", state: Toaststate.ERROR);
            }
          }).catchError((error) {
            showToast(
                text: "Error checking user existence.",
                state: Toaststate.ERROR);
          });
        } else {
          return;
        }
      }
    } catch (error) {
      emit(AppLoginWithGoogleErrorState(error.toString()));
    }
  }







}