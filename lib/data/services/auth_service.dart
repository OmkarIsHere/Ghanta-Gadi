import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<List<dynamic>> registerUserWithEmailAndPassword({required String email, required String password}) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password))
          .user!;
      return [true, user.uid];
    } on FirebaseAuthException catch (e) {
      return [false, e.message ?? "Unknown Firebase error"];
    }catch (e) {
      return [false, e.toString()];
    }
  }

  Future<dynamic> loginUserWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);//).user!;
      String? idToken = await userCredential.user!.getIdToken();
      if (idToken!.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // Future signOut() async {
  //   try {
  //     await HelperFunction.saveUserLoginStatus(false);
  //     await HelperFunction.saveUserNameSF('');
  //     await HelperFunction.saveUserEmailSF('');
  //     firebaseAuth.signOut();
  //   } catch (e) {
  //     return null;
  //   }
  // }
}
