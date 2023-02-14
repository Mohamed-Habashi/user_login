abstract class LoginStates{}

class LoginInitialState extends LoginStates{}

class LoginShowPassSuccessState extends LoginStates{}

class LoginSignInLoadingState extends LoginStates{}

class LoginSignInSuccessState extends LoginStates{
  final String ? uId;

  LoginSignInSuccessState(this.uId);
}

class LoginSignInErrorState extends LoginStates{}

class LoginResetPasswordSuccessState extends LoginStates{}
