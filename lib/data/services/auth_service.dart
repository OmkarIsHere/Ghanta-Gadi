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

  Future<List<dynamic>> loginUserWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);//).user!;
      String? idToken = userCredential.user!.uid;
      if (idToken!.isNotEmpty) {
        return [true, idToken];
      } else {
        return [false,'fail'];
      }
    } on FirebaseAuthException catch (e) {
      return [false, e.message ?? 'Unknown error'];
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
