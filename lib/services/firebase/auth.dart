import "package:firebase_auth/firebase_auth.dart";

class Auth {
  //  Returns an instance using the default [FirebaseApp].
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Returns the current [User] if they are currently signed-in, or null if not.
  User? get currentUser => _firebaseAuth.currentUser;

  //  Notifies about changes to the user's sign-in state (such as sign-in or sign-out).
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  //  Attempts to sign in a user with the given email address and password.
  Future<void> signInWithEmailAndPassword(
    {
      required String email,
      required String password
    }
  ) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password
    );
  }

  //  Tries to create a new user account with the given email address and password.
  Future<UserCredential> createUserWithEmailAndPassword(
    {
      required String email,
      required String password
    }
  ) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password
    );
  }

  //  Signs out the current user.
  Future<void> signOut() async {
    _firebaseAuth.signOut();
  }
}