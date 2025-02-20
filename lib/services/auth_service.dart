import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  // ✅ Email & Password Sign-Up
  Future<UserCredential?> signUpWithEmail(String email, String password) async {
    try {
      return await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print("Sign-Up Error: $e");
      return null;
    }
  }

  // ✅ Email & Password Sign-In
  Future<UserCredential?> signInWithEmail(String email, String password) async {
    try {
      return await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print("Sign-In Error: $e");
      return null;
    }
  }

  // ✅ Google Sign-In
  Future<User?> signInWithGoogle() async {
    try {
      print("Google Sign-In initiated...");

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        print("Google Sign-In canceled by user.");
        return null;
      }

      print("Google user: ${googleUser.email}");

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      print("Access Token: ${googleAuth.accessToken}");

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      if (googleAuth.idToken == null) {
        print("Google Sign-In failed: Missing ID Token.");
        return null;
      }

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      print("Google Sign-In successful: ${userCredential.user?.displayName}");

      return userCredential.user;
    } catch (e) {
      print("Google Sign-In Error: $e");
      return null;
    }
  }

  // ✅ Apple Sign-In (iOS Only)
  Future<User?> signInWithApple() async {
    try {
      print("Apple Sign-In initiated...");

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName
        ],
      );

      print("Apple Credential ID Token: ${appleCredential.identityToken}");

      final credential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      print("Apple Sign-In successful: ${userCredential.user?.displayName}");

      return userCredential.user;
    } catch (e) {
      print("Apple Sign-In Error: $e");
      return null;
    }
  }

  // ✅ Sign Out
  Future<void> signOut() async {
    await auth.signOut();
    await googleSignIn.signOut();
  }

  // ✅ Get Current User
  User? get currentUser => auth.currentUser;
}
