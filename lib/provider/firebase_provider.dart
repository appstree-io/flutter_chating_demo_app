import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import '../models/usersmodel.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<ChatUser> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final UserCredential authResult =
          await _auth.signInWithCredential(credential);
      final User user = authResult.user!;
      Future<ChatUser> chatUser;
      chatUser = addSignInDetailsToDb(user);
      return chatUser;
    } on PlatformException catch (err) {
      // Checks for type PlatformException

      if (err.code == 'sign_in_canceled') {
        // Checks for sign_in_canceled exception

        log(err.code);
        rethrow;
      } else {
        rethrow; // Throws PlatformException again because it wasn't the one we wanted
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
      log(e.code);
      rethrow;
    } on PlatformException catch (e) {
      print(e.message);
      rethrow;
    }
  }

  Future<ChatUser> addSignInDetailsToDb(User user) async {
    ChatUser chatuser = ChatUser();

    if (user == null) {
    } else {
      String uid = user.uid;
      ChatUser chatUser = ChatUser(
        uid: uid,
        username: user.displayName,
        email: user.email,
        phone: user.phoneNumber,
        profilepic: user.photoURL,
      );
      await _db.collection("Users").doc(uid).set(chatUser.toJson());
      chatuser = chatUser;
    }
    return chatuser;
  }

  Future<void> signOutFromGoogle() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
