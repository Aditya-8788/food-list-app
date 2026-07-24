// TODO: Implement auth remote data source.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';

import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel?> getCurrentUser();

  Future<UserModel> login({
    required String email,
    required String password,
  });

  Future<UserModel> signup({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String role,
  });

  // Future<UserModel> googleLogin();

  Future<void> saveUserRole({
    required String uid,
    required String role,
  });

  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;
  // final GoogleSignIn googleSignIn;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
    // required this.googleSignIn,
  });

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = firebaseAuth.currentUser;

    if (user == null) return null;

    final doc = await firestore.collection('users').doc(user.uid).get();

    if (!doc.exists) return null;

    return UserModel.fromFirestore(doc);
  }

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final credential = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = credential.user!.uid;

    final doc = await firestore.collection('users').doc(uid).get();

    if (!doc.exists) {
      throw Exception('User data not found');
    }

    return UserModel.fromFirestore(doc);
  }

  @override
  Future<UserModel> signup({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String role,
  }) async {
    final credential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = credential.user!.uid;

    final userModel = UserModel(
      uid: uid,
      name: name,
      email: email,
      phone: phone,
      role: role,
      profileImage: '',
      authProvider: 'email',
    );

    await firestore.collection('users').doc(uid).set(userModel.toFirestore());

    return userModel;
  }

  @override
  Future<void> saveUserRole({
    required String uid,
    required String role,
  }) async {
    await firestore.collection('users').doc(uid).update({
      'role': role,
    });
  }

  @override
  Future<void> logout() async {
   
    await firebaseAuth.signOut();
  }
}