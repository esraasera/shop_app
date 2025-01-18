abstract class AppLoginStates {}

class AppLoginInitialState extends AppLoginStates {}

class  AppLoginLoadingState extends AppLoginStates {}

class  AppLoginSuccessState extends AppLoginStates {
  final String uId;
  AppLoginSuccessState(this. uId);
}



class AppCreateUserSuccessState extends AppLoginStates {
  final String uId;
  AppCreateUserSuccessState(this. uId);
}
class AppCreateUserErrorState extends AppLoginStates {
  final String error ;
  AppCreateUserErrorState(this.error);
}



class  AppLoginErrorState extends AppLoginStates {
  final String error ;
  AppLoginErrorState(this.error);
}

class  AppChangeSuffixIconState extends AppLoginStates {}


class AppLoginWithGoogleErrorState extends AppLoginStates {
  final String error;
  AppLoginWithGoogleErrorState(this.error);

}


