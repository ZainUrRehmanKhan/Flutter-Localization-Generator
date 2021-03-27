import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_localization_generator/src/utils/json_editor_utils.dart';

Future<void> addUser() async {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<QuerySnapshot> userEmail =
      users.where('email', isEqualTo: email).get();
  if ((await userEmail).docs.isEmpty) {
    return users.add({
      'email': email,
    });
  }
}
