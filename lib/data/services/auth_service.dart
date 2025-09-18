import 'package:firebase_auth/firebase_auth.dart';
import 'package:ghanta_gadi/data/repositories/user_repository.dart';
import 'package:ghanta_gadi/data/services/firestore_service.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<dynamic> registerUserWithEmailAndPassword(
      {required String fullName, required String email, required String phone,required String city, required String ward, required String password}) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password))
          .user!;
      final Map<String, dynamic> userData = {
        "name": fullName,
        "role": "citizen",
        "email": email,
        "phone": phone,
        "city": city,
        "ward": ward,
        "createdAt": DateTime.now(),
      };
      return await UserRepository(FirestoreService()).createUser(user.uid, userData);
    } on FirebaseAuthException catch (e) {
      return e.message;
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
