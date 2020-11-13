import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_gorgeous_login/models/app_gaurd.dart';
import 'package:firebase_auth_gorgeous_login/ui/flutter_toast.dart';
import 'package:firebase_auth_gorgeous_login/ui/signIn.dart';

  class AuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Stream<AppGuard>get user{
    return _auth.userChanges().map((User firebaseUser){
      AppGuard   appGuard =firebaseUser==null ?  null : AppGuard(uid: firebaseUser.uid,isVerified: firebaseUser.emailVerified,email: firebaseUser.email);

      return appGuard;
    });
  }


  Future signInAnonymus()async{
    try{
      final result = await _auth.signInAnonymously();
      User user = result.user;//Firebase User
      return user;

    }catch(e){
      print(e.toString());
      return null;
    }
  }

  Future signOut()async{
    try{
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
    }
  }

  Future  signInWithGoogle(credentials)async{
   final result = await _auth.signInWithCredential(credentials);
   print("signInWithGoogle");
   print("CurrentUser=${googleSignIn.currentUser}");
   return result;

  }

Future signInWithEmailAndPassword(String email,String password)async{
    try{
      final result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      return user;
    }catch(e){
      print(e.toString());
      return null;
    }
}
  Future signUpWithEmailAndPassword(String email,String pass)async{
print("email =$email in Auth");
    try{
      final result = await _auth.createUserWithEmailAndPassword(email: email, password: pass);
      print("In auth signUp function ");
      User user = result.user;
      await user.sendEmailVerification();

      return user;
    }catch(e){
      print(e.toString());
      print("hello auth signUp");
      return null;
    }
  }
  resetPassword(String email)async{
    print("resetPassword");
    print(email);
    try{
      await _auth.sendPasswordResetEmail(email:email );
    }catch(e){
      print("error");
      FloatToast().floatToast("Invalid E-mail/Never created any account!!!");
      print(e.toString());
    }
    print("hello");
  }

}