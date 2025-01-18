import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shop_app/layout/ecommerce_layout/cubit/cubit.dart';
import 'package:shop_app/models/user_model.dart';
import 'package:shop_app/modules/register/cubit/states.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';

class AppRegisterCubit extends Cubit<AppRegisterStates> {

  AppRegisterCubit() : super(AppRegisterInitialState());

  static AppRegisterCubit get(context) => BlocProvider.of(context);


  void userRegister({
    required String name,
    required String email,
    required String password,
    context,
  }){
    emit(AppRegisterLoadingState());
         FirebaseAuth.instance
        .createUserWithEmailAndPassword(
         email: email,
         password: password
         ).then((value){
         uId = value.user!.uid;
         saveDataInCacheHelper('uId', uId);
         userCreate(
           uId: value.user!.uid,
          email: email,
         name: name,
         context: context,
      );
    }).catchError((error){
      print(error.toString());
      emit(AppRegisterErrorState(error.toString()));
    });
  }

  UserModel? model ;

  void userCreate ({
    required String name,
    String? image,
    required String email,
    required String uId,
    context,

  }){
      model =UserModel(
      name: name,
      email: email,
      uId: uId,
      wallet: '0',
      image: image ?? 'https://icons.veryicon.com/png/o/miscellaneous/graph-library/person-liable-1.png',
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model!.toMap())
        .then((value){
         saveDataInCacheHelper('uId', uId);
         saveDataInCacheHelper('wallet',  "0");
          print('tttttttttttttttttttttttttttttttttttt the id saved in register '+uId);
          AppCubit.get(context).getUserData();
          AppCubit.get(context).getCartItems();
          emit(AppCreateUserSuccessState(uId));
    }).catchError((error){
      emit(AppCreateUserErrorState(error.toString()));
      print(error.toString());
    });
  }

  bool isPassword = true ;
  IconData suffixIcon =Icons.visibility_outlined ;

  void changeSuffixIcon(){
    isPassword = ! isPassword ;
    suffixIcon = isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined  ;
    emit(AppChangeSuffixIconState());
  }

  void saveDataInCacheHelper(String key,dynamic value){
    CacheHelper.saveData(key: key, value: value).then((value){
      emit(AppSaveDataInCacheHelperSuccessState());
    }).catchError((error){
      emit(AppSaveDataInCacheHelperErrorState(error.toString()));

    });

  }




  Future<void> signOutWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return;
      }

      final GoogleSignInAuthentication? googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );


      print("ID Token: ${googleAuth?.idToken}");
      print("Access Token: ${googleAuth?.accessToken}");

      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

      final User? user = userCredential.user;

      if (user != null) {
        final String? email = user.email;
        final String? uId = user.uid;
        final String? name = user.displayName;
        final String? photoUrl = user.photoURL;

        if (email != null) {
          final QuerySnapshot userSnapshot = await FirebaseFirestore.instance
              .collection('users')
              .where('email', isEqualTo: email)
              .get();

          if (userSnapshot.docs.isNotEmpty) {
            showToast(
              text: "This user already exists",
              state: Toaststate.ERROR,
            );
          } else {
            userCreate(
              email: email,
              uId: uId ?? '',
              name: name ?? '',
              image: photoUrl,
              context: context,
            );

            CacheHelper.saveData(key: 'uId', value: uId);
            CacheHelper.saveData(key: 'name', value: name);
            CacheHelper.saveData(key: 'email', value: email);
            CacheHelper.saveData(key: 'image', value: photoUrl);

            print('User registered successfully.');
          }
        }
      }
    } catch (error) {
      emit(AppRegisterWithGoogleErrorState(error.toString()));
      print('Error during Google sign-in: $error');
    }
  }







}