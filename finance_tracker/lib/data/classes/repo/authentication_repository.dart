import 'dart:async';

import 'package:finance_tracker/data/classes/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:meta/meta.dart';

class SignUpWithEmailAndPasswordFailure implements Exception {
  const SignUpWithEmailAndPasswordFailure([this.message = 'An unknown error occurred.']);

  factory SignUpWithEmailAndPasswordFailure.code(String code) {
    if (code == 'invalid-email') {
      return const SignUpWithEmailAndPasswordFailure('The email address is not valid.');
    }
    if (code == 'weak-password') {
      return const SignUpWithEmailAndPasswordFailure('The password provided is too weak.');
    }
    if (code == 'email-already-in-use') {
      return const SignUpWithEmailAndPasswordFailure('The account already exists for that email.');
    }
    return const SignUpWithEmailAndPasswordFailure();
  }

  final String message;
}

class LogInWithEmailAndPasswordFailure implements Exception {
  const LogInWithEmailAndPasswordFailure([this.message = 'An unknown error occurred.']);

  factory LogInWithEmailAndPasswordFailure.code(String code) {
    if (code == 'user-not-found') {
      return const LogInWithEmailAndPasswordFailure('No user found for that email.');
    }
    if (code == 'wrong-password') {
      return const LogInWithEmailAndPasswordFailure('Wrong password provided for that user.');
    }
    return const LogInWithEmailAndPasswordFailure();
  }
  final String message;
}

class LogOutFailure implements Exception {}

class AuthenticationRepository {
  AuthenticationRepository({firebase_auth.FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance;

  //final CacheClient _cache;
  final firebase_auth.FirebaseAuth _firebaseAuth;

  @visibleForTesting
  static const userCacheKey = '_user_cachce_key_';

  Stream<User> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      //TODO: Ismokt ka daro stream
      final user = firebaseUser == null ? User.empty : firebaseUser.toUser;
      return user;
    });
  }

  User get currentUser {
    return _firebaseAuth.currentUser?.toUser ?? User.empty;
  }

  Future<void> signUp({required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw SignUpWithEmailAndPasswordFailure.code(e.code);
    } catch (_) {
      throw const SignUpWithEmailAndPasswordFailure();
    }
  }

  Future<void> logIn({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw LogInWithEmailAndPasswordFailure.code(e.code);
    } catch (_) {
      throw const LogInWithEmailAndPasswordFailure();
    }
  }

  Future<void> logOut() async {
    try {
      await Future.wait([_firebaseAuth.signOut()]);
    } catch (_) {
      throw LogOutFailure();
    }
  }
}

extension on firebase_auth.User {
  /// Maps a [firebase_auth.User] into a [User].
  User get toUser {
    return User(id: uid, email: email, name: displayName, photo: photoURL);
  }
}
