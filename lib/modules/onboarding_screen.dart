import 'package:flutter/material.dart';
import 'package:shop_app/modules/register/register_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'package:shop_app/styles/colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BoardingModel{
  late final String image;
  late final String title;
  late final String description;

  BoardingModel({
    required this.image,
    required this.title,
    required this.description,

  });

}

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {

  List <BoardingModel> boarding = [
    BoardingModel(
      image: 'assets/images/4530199.jpg',
      title: 'Select From Our\n      Best Items ',
      description: 'Pick your items from our store \n          more than 30 items',
    ),
    BoardingModel(
      image: 'assets/images/6134225.jpg',
      title: 'Easy and Online Payment',
      description: 'You can pay cash on delivery and \n        card payment is available',
    ),
    BoardingModel(
      image: 'assets/images/5180205.jpg',
      title: 'Quick Delivery at \n   Your Doorstep',
      description: 'Deliver your items at your \n                Doorstep',
    ),

  ];

  bool isLast = false ;

  void submit(){
    CacheHelper.saveData(
      key: 'onBoarding',
      value: true,
    ).then((value) {
      if(value){
        navigateAndFinish(
          context,
          RegisterScreen(),
        );
      }
    });
  }

  var boardController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
        TextButton(
            onPressed:(){
              submit();
            },
            child:Text(
                'skip',
              style: TextStyle(
                color: defaultColor,
              ),
            ),
          ),
        ],
      ),
      body:Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: PageView.builder(
                onPageChanged:(int index){
                  if(index == boarding.length-1){
                    setState(() {
                      isLast = true ;
                    });
                  }else{
                    setState(() {
                      isLast = false ;
                    });
                  }
                } ,
                physics: const BouncingScrollPhysics(),
                controller: boardController,
                itemBuilder: (context,index) => buildOnBoardingItem(boarding[index]),
                itemCount: 3,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            SmoothPageIndicator(
                controller: boardController,
                effect: ExpandingDotsEffect(
                activeDotColor: defaultColor,
                dotColor: Colors.grey,
                dotHeight: 5,
                expansionFactor: 4,
                dotWidth: 10,
                spacing: 5.0,
              ),
              count: boarding.length,
            ),
            const SizedBox(
              height: 5.0,
            ),
            Container(
              height: 50.0,
              margin: const EdgeInsets.only(
                  top: 30.0,
                  right: 20.0,
                  left: 20.0,
                  bottom: 20.0,
              ),
              decoration: BoxDecoration(
                  color: defaultColor,
                  borderRadius: BorderRadius.circular(20.0)
              ),
              width: double.infinity,
              child: Center(
                child: InkWell(
                  onTap: (){
                    if(isLast){
                      submit();
                    }else{
                      boardController.nextPage(
                        duration: const Duration(
                          milliseconds: 750,
                        ),
                        curve: Curves.fastLinearToSlowEaseIn,
                      );
                    }
                  },
                  child: Text(
                    isLast ? 'Start':'Next',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }

  Widget buildOnBoardingItem(BoardingModel model) => Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Expanded(
        child: Image.asset
          (
          model.image,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
      ),
      const SizedBox(
        height: 20.0,
      ),
      Text(
        model.title,
        style: const TextStyle(
          fontSize: 23.0,
          fontFamily: 'Poppins',

        ),
      ),
      const SizedBox(
        height: 15.0,
      ),
      Text(
        model.description,
        style: TextStyle(
          fontSize: 14.0,
          fontFamily: 'Poppins',
          color: Colors.grey[600],
        ),
      ),
      const SizedBox(
        height: 30.0,
      ),
    ],
  );
}