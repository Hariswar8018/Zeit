import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zeitt/model/usermodel.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;

  UserModel? get getUser => _user;

  Future<void> refreshuser() async {
    UserModel? user = await GetUser();
    if (user != null) {
      _user = user;
      notifyListeners();
    } else {
      print("User data is null, unable to refresh user.");
    }
  }

  Future<UserModel?> GetUser() async {
    String? hhj = FirebaseAuth.instance.currentUser?.uid ?? "frHI4qGjqDNi0yHSEIckz8qROFA3";
    if (hhj == null) {
      print("No user is currently logged in.");
      return null;
    }
    try {
      DocumentSnapshot snap = await FirebaseFirestore.instance
          .collection('Users')
          .doc(hhj)
          .get();

      return UserModel.fromSnap(snap);
    } catch (e) {
      print("Can't find user data: $e");
      return null;
    }
  }
}
