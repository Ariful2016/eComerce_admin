import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static User? get currentUser => _auth.currentUser;

  static Future<User?> loginAdmin(String email, String pass ) async{
    final result = await _auth.signInWithEmailAndPassword(email: email, password: pass);
    return result.user;
  }

  static Future<void> logoutAdmin(){
    return _auth.signOut();
  }
}