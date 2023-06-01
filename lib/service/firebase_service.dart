import 'dart:async';
import 'dart:developer';

import 'package:chat_app/Utils/data_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
      // EasyLoading.showInfo(
      //   "Logging In",
      //   dismissOnTap: true,
      //   duration: const Duration(seconds: 1),
      // );
      ChatUser chatUser;
      final checkUser = await checkSignInDetailsToDb(user);
      chatUser = checkUser;
      if (checkUser.uid == null) {
        chatUser = await addSignInDetailsToDb(user);
      }

      return chatUser;
    } on PlatformException catch (err) {
      if (err.code == 'sign_in_canceled') {
        log(err.code);
        rethrow;
      } else {
        rethrow;
      }
    } on FirebaseAuthException catch (e) {
      log(e.code);
      rethrow;
    }
  }

  Future<ChatUser> addSignInDetailsToDb(User? user) async {
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

  Future<ChatUser> checkSignInDetailsToDb(User? user) async {
    ChatUser chatuser = ChatUser();

    if (user == null) {
    } else {
      String uid = user.uid;
      final userDetails = await _db.collection("Users").doc(uid).get();
      if (userDetails.exists) {
        final userData = userDetails.data();
        ChatUser chatUser = ChatUser(
          uid: userData!['uid'],
          username: userData['username'],
          email: userData['email'],
          phone: userData['phone'],
          profilepic: userData['profilepic'],
        );
        chatuser = chatUser;
      }
    }
    return chatuser;
  }

  Future<void> signOutFromGoogle() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  Future<void> updateUserToken(String token, String uid) async {
    await _db
        .collection(userCollectionName)
        .doc(uid)
        .set({"deviceToken": token}, options);
  }

  SetOptions options = SetOptions(
    merge: true,
  );

  static Future<ChatUser?> getUserModelbyId(String uid) async {
    ChatUser? chatUser;

    DocumentSnapshot docsnapshot =
        await FirebaseFirestore.instance.collection("Users").doc(uid).get();

    if (docsnapshot.data() != null) {
      chatUser = ChatUser.fromJson(docsnapshot.data() as Map<String, dynamic>);
    }
    return chatUser;
  }
}
