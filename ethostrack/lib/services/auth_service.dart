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
      print('🔥 === INICIANDO SIGNUP ===');
      print('📧 Email: $email');
      print('👤 Username: $username');
      print('🔑 Password length: ${password.length}');

      print('🔍 Verificando si username está disponible...');
      bool isUsernameAvailable = await _isUsernameAvailable(username);
      print('✅ Username disponible: $isUsernameAvailable');
      if (!isUsernameAvailable) {
        print('❌ Username ya existe');
        throw Exception('Username already exists');
      }

      print('🔐 Creando usuario en Firebase Auth...');
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: email, 
            password: password
          );
      print('✅ Usuario creado en Auth con UID: ${userCredential.user?.uid}');

      print('📝 Creando UserModel...');
      UserModel newUser = UserModel(
        uid: userCredential.user!.uid,
        email: email,
        username: username,
        createdAt: DateTime.now(),
      );
      print('✅ UserModel creado correctamente');

      print('💾 Guardando en Firestore colección "users"...');
      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(newUser.toMap());
      print('✅ ¡Usuario guardado exitosamente en Firestore!');
      print('🎉 === SIGNUP COMPLETADO ===');
      return newUser;
    } catch (e) {
      print('❌ === ERROR EN SIGNUP ===');
      print('❌ ERROR COMPLETO: $e');
      print('❌ TIPO DE ERROR: ${e.runtimeType}');
      print('Error to signUp: $e');
      if (e is FirebaseAuthException) {
      print('❌ CÓDIGO FIREBASE: ${e.code}');
      print('❌ MENSAJE FIREBASE: ${e.message}');
    }
      print('❌ === FIN ERROR ===');
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
