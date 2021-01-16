import 'package:firebase_auth/firebase_auth.dart';
import 'package:dailydigest/Users.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

//   create user obj based on firebase user
  Users _userFromFirebaseUser(User user) {
    return user != null ? Users(uid: user.uid) : null;
  }
//
  // auth change user stream
//  Stream<Users> get user {
//    return _auth.onAuthStateChanged
//    //.map((FirebaseUser user) => _userFromFirebaseUser(user));
//        .map(_userFromFirebaseUser);
//  }
//
  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // register with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

//   sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

}