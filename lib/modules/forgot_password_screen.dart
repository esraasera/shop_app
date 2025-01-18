import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/ecommerce_layout/cubit/cubit.dart';
import 'package:shop_app/layout/ecommerce_layout/cubit/states.dart';
import 'package:shop_app/modules/register/register_screen.dart';
import 'package:shop_app/shared/components/components.dart';

class ForgotPasswordScreen extends StatelessWidget {

  var mailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String email = '';
  bool isEmbty = false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return BlocConsumer<AppCubit,AppStates>(
      listener: (BuildContext context,state) {  },
      builder: (BuildContext context, state) {
        var cubit = AppCubit .get(context);
        return  Scaffold(
          body: Container(
            color: Colors.black,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 70.0,
                    ),
                    const Text(
                      'Password Recovery',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    const Text(
                      'Enter your mail',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 50.0,
                    ),
                    Form(
                      key: formKey,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color:isEmbty ? Colors.red: Colors.grey,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            textSelectionTheme: TextSelectionThemeData(
                              selectionColor: Colors.amber,
                              selectionHandleColor: Colors.amber,
                            ),
                          ),
                          child: TextFormField(
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 15.0,
                            ),
                            validator: (String? value){
                              if(value!.isEmpty){
                                isEmbty = true;
                                showToast(text: 'enter your email', state: Toaststate.ERROR);
                              }
                              return null;
                            },
                            controller: mailController,
                            keyboardType:TextInputType.emailAddress,
                            cursorColor: Colors.amber,
                            decoration: InputDecoration(
                              hintText: 'Email',
                              hintStyle: TextStyle(
                                color: Colors.grey[400],
                              ),
                              prefixIcon: Icon(
                                Icons.person,
                                color: Colors.grey[400],
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25.0,
                    ),
                    Container(
                      width: double.infinity,
                      height: 50.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        color: Colors.white,
                      ),
                      child: MaterialButton(
                        onPressed: (){
                          if(formKey.currentState!.validate()){
                            email = mailController.text;
                            cubit.confirmEmail(email, mailController);
                            cubit.resetPassword(email,context);
                          }
                        },
                        child: const Text(
                          'Send Email',
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have an account ? ',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 15.0,
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            navigateAndFinish(context, RegisterScreen());
                          },
                          child: const Text(
                            'Create',
                            style: TextStyle(
                              color: Colors.amber,
                              fontSize: 17.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
