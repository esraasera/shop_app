import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shop_app/layout/ecommerce_layout/cubit/cubit.dart';
import 'package:shop_app/layout/ecommerce_layout/cubit/states.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'package:shop_app/styles/colors.dart';

class WalletScreen extends StatelessWidget {

  var amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  BlocProvider(
      create: (BuildContext context) => AppCubit(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (BuildContext context, AppStates state) {  },
        builder: (BuildContext context, AppStates state) {
          double walletBalance = double.tryParse(CacheHelper.getData(key: 'wallet')?.toString() ?? '0.0') ?? 0.0;
          return Scaffold(
            body: Container(
              margin: EdgeInsets.only(top: 50.0),
              child: Column(
                children: [
                  Material(
                    elevation: 2.0,
                    child: Container(
                      padding: EdgeInsets.only(bottom: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Text(
                          'Wallet',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5.0,horizontal: 5.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: HexColor('dbecef'),
                    ),
                    child: Row(
                      children: [
                        Image.asset('assets/images/rb_7159.png',
                          height: 80.0,
                          width: 80.0,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                         Expanded(
                           child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Your Wallet',
                                 style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15.0,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                '\$${walletBalance.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                        ),
                         ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  GestureDetector(
                    onTap: (){
                      openEdit(context);
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 25.0),
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(vertical: 12.0,),
                      decoration: BoxDecoration(
                        color: defaultColor,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Center(
                        child: Text(
                          'Add Money',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
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

   Future openEdit(context)async {
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
                       Row(
                         children: [
                           InkWell(
                               onTap: () {
                                 Navigator.pop(context);
                               },
                               child: Icon(
                                 Icons.cancel,
                               )),
                           SizedBox(width: 60.0,),
                           Center(
                             child: Text(
                               'Add Money',
                               style: TextStyle(
                                 color: defaultColor,
                                 fontWeight: FontWeight.bold,
                                 fontSize: 13.0,
                               ),
                             ),
                           ),
                         ],
                       ),
                       SizedBox(
                         height: 20.0,
                       ),
                       Text('Amount',
                         style: TextStyle(
                           color: Colors.black54,
                         ),
                       ),
                       SizedBox(
                         height: 10.0,
                       ),
                       Center(
                         child: Container(
                           padding: EdgeInsets.symmetric(horizontal: 10.0),
                           decoration: BoxDecoration(
                             border: Border.all(color: Colors.black54),
                             borderRadius: BorderRadius.circular(10.0),
                           ),
                           child: TextFormField(
                             controller: amountController,
                             cursorColor: defaultColor,
                             keyboardType: TextInputType.phone,
                             style: TextStyle(
                               color: Colors.black54,
                             ),
                             decoration: InputDecoration(
                                 border: InputBorder.none,
                                 hintText: 'Enter Amount'
                             ),
                           ),
                         ),
                       ),
                       SizedBox(height: 20.0,),
                       Center(
                         child: InkWell(
                           onTap: () {
                             int amount = int.parse(amountController.text);
                             cubit.makePayment(
                                 amount , "USD").then((value) {
                                Navigator.pop(context);
                                amountController.clear();
                             });
                           },
                           child: Container(
                             width: 100,
                             padding: EdgeInsets.all(5.0),
                             decoration: BoxDecoration(
                               color: defaultColor,
                               borderRadius: BorderRadius.circular(10),
                             ),
                             child: Center(
                               child: Text(
                                 'Pay',
                                 style: TextStyle(
                                   color: Colors.white,
                                 ),
                               ),
                             ),
                           ),
                         ),
                       )
                     ],
                   ),
                 ),
               ),
             )
     );
   }
}
