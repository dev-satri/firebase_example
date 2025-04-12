import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class FirebaseServices {
  Future<Either<String, User?>> register(
      {required String email, required String password});

  Future<Either<String, User?>> login(
      {required String email, required String password});
}

class FirebaseServicesImpl implements FirebaseServices {
  @override
  Future<Either<String, User?>> register(
      {required String email, required String password}) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return Right(credential.user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return Left('Your password is too weak');
      } else if (e.code == 'email-already-in-use') {
        return Left('The account already exsist for that email');
      } else {
        return Left('Authetication Error: ${e.message}');
      }
    } catch (e) {
      return Left('$e');
    }
  }

  @override
  Future<Either<String, User?>> login(
      {required String email, required String password}) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return Right(credential.user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return Left('User not found');
      } else if (e.code == 'wrong-password') {
        return Left('Wrong Email or Password');
      } else {
        return Left('Authetication Error: ${e.message}');
      }
    } catch (e) {
      return Left('$e');
    }
  }
}
