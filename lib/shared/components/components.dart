import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shop_app/layout/ecommerce_layout/cubit/cubit.dart';
import 'package:shop_app/styles/colors.dart';

Widget defaultTextFormField({
  required TextEditingController controller,
  bool isPassword = false,
  required TextInputType type,
  Function? onFieldSubmitted,
  String? Function(String?)? validate,
  required String text,
  required IconData prefix ,
  IconData? suffix ,
  Function? suffixPress,
  context,

}) =>Theme(
    data: Theme.of(context).copyWith(
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: defaultColor,
        selectionHandleColor: defaultColor,
      ),
    ),
  child: TextFormField(
    controller:controller,
    obscureText: isPassword,
    style: const TextStyle(
      fontFamily: 'Poppins',
      fontSize: 13.0,
    ),
    keyboardType:type,
    cursorColor:HexColor('0f4c57') ,
    onFieldSubmitted:(s){
      onFieldSubmitted!(s);
    } ,
    validator:validate,
    decoration: InputDecoration(
      errorStyle: const TextStyle(
        height: 0.3,
      ),
      focusedBorder:OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(color: HexColor('1c9ab0'))
      ),
      filled: true,
      fillColor:Colors.white ,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
        borderSide: const BorderSide(color:Colors.black),
      ),
      hintText: text,
      hintStyle: TextStyle(
        color: HexColor('0f4c57'),
      ),
      prefixIcon: Icon(
        prefix,
        color: HexColor('0f4c57'),
      ),
      suffixIcon: suffix != null ? IconButton(
        icon: Icon(
          suffix,
          color: HexColor('0f4c57'),
        ),
        onPressed: () {
          suffixPress!();
        },
      ):null,
    ),
  ),
);

void navigationTo(context,widget)=> Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context)=> widget,
  ),
);

void navigateAndFinish(context,widget){

  AppCubit.get(context).changeNavCurrentIndex(0);

  Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(
    builder: (context)=> widget,
  ),
      (Route<dynamic>route) => false,
);
}

void showToast({
  required String text,
  required Toaststate state,
}) =>  Fluttertoast.showToast(
  msg: text,
  toastLength: Toast.LENGTH_LONG,
  gravity: ToastGravity.BOTTOM,
  timeInSecForIosWeb: 5,
  backgroundColor: changeToastColor(state),
  textColor: Colors.white,
  fontSize: 16.0,
);

enum Toaststate {SUCCESS,ERROR,WARNING}


Color? changeToastColor(Toaststate state){

  Color color;
  switch(state){
    case Toaststate.SUCCESS:
      color = defaultColor;
      break;
    case Toaststate.ERROR:
      color = Colors.red;
      break;
    case Toaststate.WARNING:
      color = Colors.amber;
      break;
  }
  return color;
}

