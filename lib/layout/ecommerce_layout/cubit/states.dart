abstract class AppStates { }

class InitialAppState extends AppStates {}

class AppChangeBottomNavIndexState extends AppStates {}


class AppGetProductsLoadingState extends AppStates { }
class AppGetProductsSuccessState extends AppStates { }
class AppGetProductsErrorState extends AppStates { }

class AppChangeTextState extends AppStates { }

class  AppGetUserSuccessState extends AppStates{ }
class  AppGetUserErrorState extends AppStates{
  final String error;
  AppGetUserErrorState(this.error);
}

class  AppUserUpdateErrorState extends AppStates{
  final String error;
  AppUserUpdateErrorState(this.error);
}


class StripePaymentSuccessState extends AppStates {}
class StripePaymentErrorState extends AppStates {}


class SocialUploadProfileImageSuccessState extends AppStates{ }
class SocialUploadProfileImageErrorState extends AppStates{ }
class AppUserUpdateLoadingState extends AppStates{ }



class SocialPickedProfileImageSuccessState extends AppStates{ }
class SocialPickedProfileImageErrorState extends AppStates{ }


class AppUserDeleteLoadingState extends AppStates{ }
class AppUserDeleteSuccessState extends AppStates{ }
class   AppUserDeleteErrorState extends AppStates{
  final String error;
  AppUserDeleteErrorState(this.error);
}



class AppUserGetLoadingState extends AppStates{ }
class AppUserGetSuccessState extends AppStates{ }
class   AppUserGetErrorState extends AppStates{
  final String error;
  AppUserGetErrorState(this.error);
}


class AppLogoutSuccessState extends AppStates{ }
class   AppLogoutErrorState extends AppStates{
  final String error;
  AppLogoutErrorState(this.error);
}


class   AppSendCartItemErrorState extends AppStates{
  final String error;
  AppSendCartItemErrorState(this.error);
}


class  AppGetCartItemSuccessState extends AppStates{ }
class   AppGetCartItemErrorState extends AppStates{
  final String error;
  AppGetCartItemErrorState(this.error);
}

class  AppResetPasswordSuccessState extends AppStates{ }
class  AppResetPasswordErrorState extends AppStates{ }
class  AppConfirmEmailSuccessState extends AppStates{ }


class  AppDeleteCartItemSuccessState extends AppStates{ }
class   AppDeleteCartItemErrorState extends AppStates{
  final String error;
  AppDeleteCartItemErrorState(this.error);
}


class  AppIncrementQuantityState extends AppStates{ }
class  AppDecrementQuantityState extends AppStates{ }


class  AppSetProductNumValueState extends AppStates{ }



class  AppCheckoutSuccessState extends AppStates{ }
class  AppCheckoutFailureState extends AppStates{ }
