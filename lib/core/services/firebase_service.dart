// TODO: Wrap Firebase operations here.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  FirebaseService._();

  static final FirebaseAuth auth =
      FirebaseAuth.instance;

  static final FirebaseFirestore firestore =
      FirebaseFirestore.instance;

  static final FirebaseStorage storage =
      FirebaseStorage.instance;
}