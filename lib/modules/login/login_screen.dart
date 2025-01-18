import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shop_app/layout/ecommerce_layout/layout_screen.dart';
import 'package:shop_app/modules/forgot_password_screen.dart';
import 'package:shop_app/modules/login/cubit/cubit.dart';
import 'package:shop_app/modules/login/cubit/states.dart';
import 'package:shop_app/modules/register/register_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/styles/colors.dart';
class LoginScreen extends StatelessWidget {

  var passwordController = TextEditingController();

  var emailController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

      return BlocProvider(
        create: (BuildContext context)=> AppLoginCubit(),
        child: BlocConsumer<AppLoginCubit,AppLoginStates>(
          listener: (BuildContext context, AppLoginStates state) {
            if(state is AppLoginSuccessState){
              navigateAndFinish(
                context,
                LayoutScreen(),
              );
            }
            if(state is AppLoginErrorState){
              showToast(
                text: state.error,
                state: Toaststate.ERROR,
              );
            }
            if(state is AppCreateUserSuccessState){
              navigateAndFinish(
                context,
                LayoutScreen(),
              );
            }
          },
          builder: (BuildContext context, AppLoginStates state) {
            var cubit = AppLoginCubit.get(context);
            return Scaffold(
              backgroundColor: Colors.grey[200],
              body: SingleChildScrollView(
                child: Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height /2.5,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(HexColor('1c9ab0').value ),
                              Color(HexColor('0f4c57').value ),
                            ]
                        ),
                      ),
                    ),
                    Container(
                      margin:EdgeInsets.only(top:MediaQuery.of(context).size.height /3),
                      height:MediaQuery.of(context).size.height /2 ,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(40.0),
                          topRight: Radius.circular(40.0),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        top: 100.0,
                        right: 20.0,
                        left: 20.0,
                      ),
                      child: Column(
                        children: [
                          Material(
                            elevation: 5.0,
                            borderRadius: BorderRadius.circular(20.0),
                            child: Container(
                              height:MediaQuery.of(context).size.height /1.5,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: SingleChildScrollView(
                                physics: const NeverScrollableScrollPhysics(),
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Form(
                                    key: formKey,
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                        const Text(
                                          'Login',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 25.0,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20.0,
                                        ),
                                        defaultTextFormField(
                                          controller: emailController,
                                          type: TextInputType.emailAddress,
                                          text: 'Email Address',
                                          prefix: Icons.email,
                                          context: context,
                                          onFieldSubmitted:(value){
                                            print(value);
                                          },
                                          validate: (String? value){
                                            if(value!.isEmpty){
                                              return 'email must not be embty';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(
                                          height: 20.0,
                                        ),

                                        defaultTextFormField(
                                          controller: passwordController,
                                          type: TextInputType.text,
                                          isPassword:  cubit.isPassword,
                                          suffix:cubit.suffixIcon,
                                          text: 'Password',
                                          prefix: Icons.lock,
                                          context: context,
                                          suffixPress:(){
                                            cubit.changeSuffixIcon();
                                          },
                                          onFieldSubmitted:(value){
                                            if(formKey.currentState!.validate()){
                                              cubit.userLogin(
                                                  email: emailController.text,
                                                  password: passwordController.text,
                                                  context: context,
                                              );
                                            }
                                            },
                                          validate: (String? value){
                                            if(value!.isEmpty){
                                              return 'please enter password';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(
                                          height: 15.0,
                                        ),
                                        GestureDetector(
                                          onTap: (){
                                            navigateAndFinish(context, ForgotPasswordScreen());
                                          },
                                          child: Container(
                                            alignment: Alignment.topRight,
                                            child: const Text('Forgot Password?',
                                              style: TextStyle(
                                                  fontSize: 15.0,
                                                  fontFamily: 'Poppins'
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 70.0,
                                        ),
                                        ConditionalBuilder(
                                          condition: state is! AppLoginLoadingState,
                                          builder: (context) => InkWell(
                                            onTap: (){
                                              if(formKey.currentState!.validate()){
                                                cubit.userLogin(
                                                    email: emailController.text,
                                                    password: passwordController.text,
                                                  context: context,
                                                );
                                              }
                                            },
                                            child:Material(
                                              elevation: 5.0,
                                              borderRadius: BorderRadius.circular(20.0),
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(vertical: 12.0),
                                                width: 200.0,
                                                height: 45.0,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(20.0),
                                                  gradient: LinearGradient(
                                                      begin: Alignment.topLeft,
                                                      end: Alignment.bottomRight,
                                                      colors: [
                                                        Color(HexColor('1c9ab0').value ),
                                                        Color(HexColor('0f4c57').value ),
                                                      ]
                                                  ),
                                                ),
                                                child: const Center(
                                                  child: Text(
                                                    'LOGIN',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18.0,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          fallback: (context) =>
                                              Center(child: CircularProgressIndicator(color: defaultColor,)),
                                        ),
                                        const SizedBox(
                                          height: 20.0,
                                        ),
                                         InkWell(
                                           onTap: (){
                                             cubit.signInWithGoogle(context);
                                           },
                                           child: Material(
                                             elevation: 5.0,
                                             borderRadius: BorderRadius.circular(20.0),
                                             child: Container(
                                               padding: const EdgeInsets.symmetric(vertical: 12.0),
                                               width: 200.0,
                                              height: 45.0,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20.0),
                                                gradient: LinearGradient(
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                    colors: [
                                                      Color(HexColor('1c9ab0').value ),
                                                      Color(HexColor('0f4c57').value ),
                                                    ]
                                                ),
                                              ),
                                              child: Center(
                                                child: Image.asset(
                                                    'assets/images/7123953_logo_google_g_icon.png',
                                                ),
                                              ),
                                            ),
                                        ),
                                         ),
                                        const SizedBox(
                                          height: 80.0,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 60.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Don\'t have an account?',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              InkWell(
                                onTap: (){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context)=> RegisterScreen()));
                                },
                                child: Text(
                                  ' Sign up',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                    color: HexColor('0f4c57'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },

        ),
      );
  }
}
