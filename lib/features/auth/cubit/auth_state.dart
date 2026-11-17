abstract class AuthState {}
  
  
class AuthInitial extends AuthState{}

class LodingAuthState extends AuthState{}

class ErrorAuthState extends AuthState{
  final String massage;

  ErrorAuthState( this.massage);

}

class SuccessAuthState extends AuthState{
  final String massage;

  SuccessAuthState( this.massage);

}


