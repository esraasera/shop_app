abstract class AppRegisterStates {}

class AppRegisterInitialState extends AppRegisterStates {}



class AppRegisterLoadingState extends AppRegisterStates {}
class AppRegisterErrorState extends AppRegisterStates {
  final String error ;
  AppRegisterErrorState(this.error);
}



class AppCreateUserSuccessState extends AppRegisterStates {
  final String uId;
  AppCreateUserSuccessState(this. uId);
}
class AppCreateUserErrorState extends AppRegisterStates {
  final String error ;
  AppCreateUserErrorState(this.error);
}




class AppChangeSuffixIconState extends AppRegisterStates {}

class AppSaveDataInCacheHelperSuccessState extends AppRegisterStates {}
class AppSaveDataInCacheHelperErrorState extends AppRegisterStates {
  final String error ;
  AppSaveDataInCacheHelperErrorState(this.error);
}


class AppRegisterWithGoogleErrorState extends AppRegisterStates {
  final String error;
  AppRegisterWithGoogleErrorState(this.error);

}