import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<UserModel?> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      

      bool isUsernameAvailable = await _isUsernameAvailable(username);
      if (!isUsernameAvailable) {
        throw Exception('Username already exists');
      }

      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: email, 
            password: password
          );

      UserModel newUser = UserModel(
        uid: userCredential.user!.uid,
        email: email,
        username: username,
        createdAt: DateTime.now(),
      );

      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(newUser.toMap());
      return newUser;
    } catch (e) {
      if (e is FirebaseAuthException) {
    }
      return null;
    }
  }

  static Future<UserModel?> logIn({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (userDoc.exists) {
        return UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error in logIn: $e');
      return null;
    }
  }

  static Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Error in logOut: $e');
    }
  }

  static Future<UserModel?> getCurrentUser() async {
    try {
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        DocumentSnapshot userDoc = await _firestore
            .collection('users')
            .doc(currentUser.uid)
            .get();

        if (userDoc.exists) {
          return UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
        }
      }

      return null;
    } catch (e) {
      print('Error in getCurrentUser: $e');
      return null;
    }
  }

  static Future<bool> _isUsernameAvailable(String username) async {
    try {
      QuerySnapshot query = await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .get();

      return query.docs.isEmpty;
    } catch (e) {
      print('Error to validate username: $e');
      return false;
    }
  }

  static bool isLoggedIn() {
    if (_auth.currentUser != null) {
      return true;
    } else {
      return false;
    }
  }

  static String? getCurrentUserUid() {
    if (_auth.currentUser != null) {
      return _auth.currentUser!.uid;
    } else {
      return null;
    }
  }
}
