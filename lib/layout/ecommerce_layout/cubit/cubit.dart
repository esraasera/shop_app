import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart'as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shop_app/layout/ecommerce_layout/cubit/states.dart';
import 'package:shop_app/models/cart_model.dart';
import 'package:shop_app/models/product_model.dart';
import 'package:shop_app/models/user_model.dart';
import 'package:shop_app/modules/home_screen.dart';
import 'package:shop_app/modules/login/login_screen.dart';
import 'package:shop_app/modules/order_screen.dart';
import 'package:shop_app/modules/profile_screen.dart';
import 'package:shop_app/modules/register/register_screen.dart';
import 'package:shop_app/modules/wallet_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';
import 'package:shop_app/styles/colors.dart';

class AppCubit extends Cubit<AppStates> {


  AppCubit() : super(InitialAppState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  void changeNavCurrentIndex(int index){
    currentIndex = index;
    emit(AppChangeBottomNavIndexState());
  }


  List<Widget>screens=[
    HomeScreen(),
    const OrderScreen(),
    WalletScreen(),
    const ProfileScreen(),
  ];

  List<Widget> bannerImages = [
    Image.asset('assets/images/5416345.jpg'),
    Image.asset('assets/images/6572260.jpg'),
    Image.asset('assets/images/5416701.jpg'),
    Image.asset('assets/images/6572250.jpg'),
    Image.asset('assets/images/5416472.jpg'),
    Image.asset('assets/images/6572265.jpg'),
  ];


  List<ProductModel> products = [];

  void getProductsData(){
    emit(AppGetProductsLoadingState());
    DioHelper.getData
      (
      url:'https://fakestoreapi.com/products',
    ).then((value){
      List<dynamic> data = value.data;
      products = data.map((item) => ProductModel.fromJson(item)).toList();
      emit(AppGetProductsSuccessState());

    })
        .catchError((error){
      emit(AppGetProductsErrorState());
    });
  }


  int productNum = 1;

  Map<int, int> productQuantities = {};

  void incrementQuantity(int id, dynamic price) {
    productQuantities[id] = (productQuantities[id] ?? 1) + 1;
    productNum = productQuantities[id]!;
    double updatedPrice = price * productNum.toDouble();
    updateCartQuantityAndPrice(id, productQuantities[id]!, updatedPrice);
    emit(AppIncrementQuantityState());
  }

  void decrementQuantity(int id, dynamic price) {
    if (productQuantities[id] != null && productQuantities[id]! > 1) {
      productQuantities[id] = productQuantities[id]! - 1;
      productNum = productQuantities[id]!;
      double updatedPrice = price * productNum.toDouble();
      updateCartQuantityAndPrice(id, productQuantities[id]!, updatedPrice);
      emit(AppDecrementQuantityState());
    }
  }


  void resetPassword(String email,context) async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isEmpty) {
        showToast(
            text: 'No user found for that email',
            state: Toaststate.ERROR
        );
      } else {
        FirebaseAuth.instance.sendPasswordResetEmail(email: email)
            .then((value) {
          showToast(
              text: 'Password Reset Email has been sent',
              state: Toaststate.SUCCESS
          );
          emit(AppResetPasswordSuccessState());
          navigateAndFinish(context, LoginScreen());
        }).catchError((error) {
          showToast(text: 'An error occurred', state: Toaststate.ERROR);
          emit(AppResetPasswordErrorState());
        });
      }
    }).catchError((error) {
      showToast(text: 'An error occurred', state: Toaststate.ERROR);
      emit(AppResetPasswordErrorState());
    });
  }

  void confirmEmail (String email,controller){
    email = controller.text;
    emit(AppConfirmEmailSuccessState());
  }




  int getProductQuantity(int id) {
    int quantity = productQuantities[id] ?? 1;

    if (productNum != 1 && quantity == 1) {
      productNum = 1;
      emit(AppSetProductNumValueState());
    }

    return quantity;
  }

  double getCartTotal() {
    double total = 0.0;
    for (var product in cartItems) {
      total += product.price * product.quantity;
    }

    return total;
  }


  void checkout(BuildContext context) async {
      double walletBalance = double.tryParse(CacheHelper.getData(key: 'wallet')?.toString() ?? '0.0') ?? 0.0;
      double cartTotal = getCartTotal();
      if(getCartTotal() == 0.0 ){
        showToast(text: 'add some items to your cart', state: Toaststate.SUCCESS);
      }else{
      if (walletBalance >= cartTotal) {
        walletBalance -= cartTotal;

        if (uId!.isNotEmpty) {
          try {
            CacheHelper.saveData(key: 'wallet', value: walletBalance);

            await updateWallet(id: uId!, amount: walletBalance.toString());
            showToast(
              text: 'Checkout successful! Remaining balance: \$${walletBalance.toStringAsFixed(2)}',
              state: Toaststate.SUCCESS,
            );
            await deleteAllCartItems(uId!);
            cartItems=[];
            emit(AppCheckoutSuccessState());
          } catch (error) {
            showToast(text: 'Failed to update user data: $error', state: Toaststate.ERROR);
            emit(AppCheckoutFailureState());
          }
        } else {
          showToast(text: 'User ID not found. Please log in again.', state: Toaststate.ERROR);
        }
      } else {
        showToast(text: 'Add enough money to complete the checkout', state: Toaststate.ERROR);
        emit(AppCheckoutFailureState());
      }
    }
  }



  bool isShown = false;
  void changeText(){
    isShown = !isShown ;
    emit(AppChangeTextState());

  }

  UserModel? userModel;

  void getUserData() {
    String uId = CacheHelper.getData(key: 'uId');
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .get()
        .then((doc) {
      if (doc.exists) {
        String wallet = doc.data()?['wallet'] ?? '0';
        String image = doc.data()?['image'] ?? 'https://icons.veryicon.com/png/o/miscellaneous/graph-library/person-liable-1.png';
        String name = doc.data()?['name'] ?? 'Anonymous';

        userModel = UserModel(
          email: doc.data()?['email'],
          uId: uId,
          wallet: wallet,
          image: image,
          name: name,
        );

        CacheHelper.saveData(key: 'wallet', value: wallet);
        CacheHelper.saveData(key: 'image', value: image);
        CacheHelper.saveData(key: 'name', value: name);

        emit(AppGetUserSuccessState());
      }
    }).catchError((error) {
      emit(AppGetUserErrorState(error.toString()));
    });
  }


  Future<void> updateWallet({
    required String id,
    required amount,
     photoUrl,
  }) async {
    if (id.isEmpty || amount.isEmpty) {
      emit(AppUserUpdateErrorState("Invalid data for update"));
      return;
    }
    try {

      await FirebaseFirestore.instance
          .collection("users")
          .doc(id)
          .update({"wallet": amount});
       getUserData();
    } catch (error) {
      emit(AppUserUpdateErrorState(error.toString()));
    }
  }




  Future<void> updateUserImage({
    required String id,
    required photoUrl,
  }) async {
    if (id.isEmpty) {
      emit(AppUserUpdateErrorState("Invalid data for update"));
      return;
    }
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(id)
          .update({"image": photoUrl});
      getUserData();
    } catch (error) {
      emit(AppUserUpdateErrorState(error.toString()));
    }
  }


  String clientSecret ='';
  var wallet = CacheHelper.getData(key: 'wallet')??'0';

  Future<void> makePayment(int amount, String currency) async {
    getClientSecret((amount * 100).toString(), currency).then((secret) {
      return initializePaymentSheet(secret);
    }).then((value) {
      return Stripe.instance.presentPaymentSheet();
    }).then((value) {
      double currentWallet = double.tryParse(CacheHelper.getData(key: 'wallet')?.toString() ?? '0.0') ?? 0.0;
      double updatedWallet = currentWallet + amount;

      CacheHelper.saveData(key: 'wallet', value: updatedWallet.toString());

      if (uId != null) {
        return updateWallet(id: uId!, amount: updatedWallet.toString());
      } else {
        throw "User ID is missing.";
      }
    }).then((value) {
      showToast(text: 'Payment Successful', state: Toaststate.SUCCESS);
      emit(StripePaymentSuccessState());
    }).catchError((error) {
      showToast(text: 'Payment Error', state: Toaststate.ERROR);
      emit(StripePaymentErrorState());
    });
  }



  Future<String>getClientSecret(String amount , String currency)async{
    var response = await DioHelper.postData(
        url: 'https://api.stripe.com/v1/payment_intents',
        data: {
          'amount':amount ,
          'currency':currency,
        }
    );
    return response.data['client_secret'];
  }


  Future<void>initializePaymentSheet(String clientSecret)async{

    await Stripe.instance.initPaymentSheet(paymentSheetParameters: SetupPaymentSheetParameters(
      paymentIntentClientSecret: clientSecret,
      merchantDisplayName: 'salla',
    ));
  }

  File? profileImage;
  var picker = ImagePicker();

  Future<void> getProfileImage()async{
    final pickedFile = await picker.pickImage(
      source:ImageSource.gallery,
    );
    if(pickedFile != null){
      profileImage = File(pickedFile.path);
      uploadProfileImage();
      emit(SocialPickedProfileImageSuccessState());
    }else
    {
      emit(SocialPickedProfileImageErrorState());
    }
  }


  Future<void> getUserImage(String uId) async {
    emit(AppUserGetLoadingState());
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .get();

      if (userDoc.exists) {
        final String imageUrl = userDoc.get('image');
        userModel = userModel!.copyWith(image: imageUrl);
        emit(AppUserGetSuccessState());
      } else {
        emit(AppUserGetErrorState('User not found'));
      }
    } catch (error) {
      emit(AppUserGetErrorState(error.toString()));
    }
  }



  void uploadProfileImage(){
    emit(AppUserUpdateLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path)
        .pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
        value.ref.getDownloadURL().then((value){
          updateUserImage(
          photoUrl:value,
          id: uId!,
        );
        emit(SocialUploadProfileImageSuccessState());
      }).catchError((error){
        emit(SocialUploadProfileImageErrorState());
      });
    }).catchError((error){
      emit(SocialUploadProfileImageErrorState());
    });
  }


  Future deleteUser(BuildContext context) async {
    emit(AppUserDeleteLoadingState());

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        AuthCredential credential;
        if (user.providerData[0].providerId == 'google.com') {
          GoogleSignInAccount? googleUser = await GoogleSignIn().signInSilently();
          if (googleUser == null) {
            emit(AppUserDeleteErrorState("Google reauthentication failed"));
            return;
          }

          final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
          credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );
        } else {
          String password = await getPasswordFromUser(context);
          if (password.isEmpty) {
            emit(AppUserDeleteErrorState("Password is required"));
            return;
          }

          credential = EmailAuthProvider.credential(
            email: user.email!,
            password: password,
          );
        }

        await user.reauthenticateWithCredential(credential);

        final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
        final subcollections = await userDoc.collection('carts').get();
        for (final subDoc in subcollections.docs) {
          await subDoc.reference.delete();
        }

        await userDoc.delete();

        await user.delete();
        emit(AppUserDeleteSuccessState());
        navigateAndFinish(context, RegisterScreen());
      } catch (error) {
        emit(AppUserDeleteErrorState(error.toString()));
      }
    }
  }


  Future<String> getPasswordFromUser(BuildContext context) async {
    final TextEditingController passwordController = TextEditingController();
    String password = '';

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter your password to confirm deletion'),
          backgroundColor: Colors.white,
          content: TextField(
            controller: passwordController,
            obscureText: true,
            cursorColor: defaultColor,
            decoration: InputDecoration(
              labelText: 'Password',
              labelStyle: TextStyle(
                color: defaultColor,
              ),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: defaultColor, width: 2.0),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                password = passwordController.text;
                Navigator.of(context).pop();
              },
              child: Text('Submit',
              style: TextStyle(
                color: defaultColor,
              ),
              ),
            ),
          ],
        );
      },
    );

    return password;
  }


  CartModel? model;

  void sendCartItem({
    required String image,
    required String name,
    required int quantity,
    required double price,
    required  String dateTime,
    required double total,
    required String id,
    context,
  }) {
    model = CartModel(
      image: image,
      name: name,
      id: id,
      dateTime:dateTime,
      quantity: quantity,
      price: price,
      total: total,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('carts')
        .add(model!.toMap())
        .then((value) {

      Navigator.pop(context);
      showToast(text: 'add successfully', state: Toaststate.SUCCESS);
      getCartItems();
    })
        .catchError((error) {
      emit(AppSendCartItemErrorState(error.toString()));
    });
  }


  List<CartModel> cartItems = [];


  void getCartItems() {
    String uId = CacheHelper.getData(key: 'uId');
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('carts')
        .orderBy('dateTime')
        .get()
        .then((querySnapshot) {
      cartItems=[];
      for (var doc in querySnapshot.docs) {
        cartItems.add(CartModel.fromJson(doc.data()));
      }
      emit(AppGetCartItemSuccessState());
    }).catchError((error) {
      emit(AppGetCartItemErrorState(error.toString()));
    });
  }

  Future<void> deleteAllCartItems(String userId) async {
    try {
      final cartCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('carts');

      final querySnapshot = await cartCollection.get();

      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }

      emit(AppDeleteCartItemSuccessState());
    } catch (error) {
      emit(AppDeleteCartItemErrorState(error.toString()));
    }
  }


  void signOut(BuildContext context) {
    GoogleSignIn googleSignIn = GoogleSignIn();
    googleSignIn.disconnect();
    CacheHelper.removeData(key: 'uId').then((value) {
      if (value) {
        navigateAndFinish(context, LoginScreen());
        CacheHelper.removeData(key: 'uId');
        CacheHelper.removeData(key: 'wallet');
        CacheHelper.removeData(key: 'image');
        CacheHelper.removeData(key: 'name');
        emit(AppLogoutSuccessState());
      }
    }).catchError((error) {
      emit(AppLogoutErrorState(error.toString()));
    });
  }


  void updateCartQuantityAndPrice(int id, int quantity, double totalPrice) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('carts')
        .where('id', isEqualTo: id.toString())
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        var doc = querySnapshot.docs.first;
        doc.reference.update({
          'quantity': quantity,
          'total': totalPrice,
        }).then((value) {
        }).catchError((error) {
        });
      } else {
      }
    }).catchError((error) {
    });
  }
}