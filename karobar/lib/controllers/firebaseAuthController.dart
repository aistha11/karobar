import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:karobar/config/userState.dart';
import 'package:karobar/models/dbUser.dart';
import 'package:karobar/services/firebaseService.dart';

class FirebaseAuthController extends GetxController {
  FirebaseAuth _auth = FirebaseAuth.instance;

  GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);

  Rx<User?>? _firebaseUser;

  Rx<Status> _status = Rx<Status>(Status.UNINITIALIZED);

  Status get status => _status.value;

  User? get user => _auth.currentUser;

  @override
  void onInit() {
    _firebaseUser?.bindStream(_auth.authStateChanges());

    print(" Auth Change :   ${_auth.currentUser}");

    if (_auth.currentUser == null) {
      print("User is not logged in");
      _status.value = Status.UNAUTHENTICATED;
      update();
    } else {
      print("User is logged in");
      _status.value = Status.AUTHENTICATED;
      update();
    }
    super.onInit();
  }

  // function to createuser, login and sign out user
  Future<void> signUp(String name, String email, String password) async {
    try {
      _status.value = Status.AUTHENTICATING;
      update();
      String username = email.split('@')[0];
      print(
          "Sign Up with:{username:$username,name:$name,email:$email,password:$password}");
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then(
        (UserCredential uCreds) async {
          if(uCreds.additionalUserInfo!.isNewUser){
            DbUser dbuser = DbUser(
            id: uCreds.user!.uid,
            name: name,
            profilePhoto: "",
            email: uCreds.user!.email.toString(),
            username: username,
          );
          await FirebaseService.createDbUserById(dbuser);
          }
          await signIn(email, password);
        },
      );
    } on FirebaseAuthException catch (e) {
      showSnackMessage(e.code);
      _status.value = Status.UNAUTHENTICATED;
      update();
    } catch (e) {
      Get.snackbar("Error!!!", "${e.toString()}");
      _status.value = Status.UNAUTHENTICATED;
      update();
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      _status.value = Status.AUTHENTICATING;
      update();
      print("Sign In with:{email:$email,password:$password}");
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then(
        (UserCredential uCreds) {
          print(uCreds);
          _status.value = Status.AUTHENTICATED;
          update();
        },
      );
    } on FirebaseAuthException catch (e) {
      showSnackMessage(e.code);
      _status.value = Status.UNAUTHENTICATED;
      update();
    } catch (e) {
      Get.snackbar("Error!!!", "${e.toString()}");
      _status.value = Status.UNAUTHENTICATED;
      update();
    }
  }

  void sendPasswordResetEmail(String email) async {
    if (email == "") {
      Get.snackbar("Email is empty",
          "Please enter the email address you've used to register with us and we'll send you a reset link!");
      return;
    }
    try {
      await _auth.sendPasswordResetEmail(email: email).then((value) {
        Get.offAllNamed("/");
        Get.snackbar("Password Reset email link is been sent", "Success");
      }).catchError((onError) {
        Get.snackbar("Error In Email Reset", onError.message);
      });
    } on FirebaseAuthException catch (e) {
      showSnackMessage(e.code);
    } catch (e) {
      Get.snackbar("Error!!!", "${e.toString()}");
    }
  }

  // void deleteuseraccount(String email, String pass) async {
  //   User user = _auth.currentUser;

  //   AuthCredential credential =
  //       EmailAuthProvider.credential(email: email, password: pass);

  //   await user.reauthenticateWithCredential(credential).then((value) {
  //     value.user.delete().then((res) {
  //       Get.offNamed("/");
  //       Get.snackbar("User Account Deleted ", "Success");
  //     });
  //   }).catchError((onError) => Get.snackbar("Credential Error", "Failed"));
  // }

  // Future<void> loginGoogle() async {
  //   if (GetPlatform.isWeb) {
  //     return signInWithGoogleWeb();
  //   } else {
  //     return signInWithGoogle();
  //   }
  // }

  // For Android
  Future<void> signInWithGoogle() async {
    try {
      // Changing the status to authenticating
      _status.value = Status.AUTHENTICATING;
      update();
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      await FirebaseAuth.instance.signInWithCredential(credential).then(
        (uCreds)async{
          if(uCreds.additionalUserInfo!.isNewUser){
            DbUser dbuser = DbUser(
            id: uCreds.user!.uid,
            name: uCreds.user!.displayName ?? "No Name",
            profilePhoto: uCreds.user!.photoURL ?? "",
            email: uCreds.user!.email.toString(),
            username: uCreds.user!.email!.split('@')[0],
          );
          await FirebaseService.createDbUserById(dbuser);
          }
          
          _status.value = Status.AUTHENTICATED;
        },
      );
    } on FirebaseAuthException catch (e) {
      showSnackMessage(e.code);
      _status.value = Status.UNAUTHENTICATED;
      update();
    } on PlatformException catch (e) {
      showSnackMessage(e.code);
      _status.value = Status.UNAUTHENTICATED;
      update();
    } catch (e) {
      print(e.toString());
      _status.value = Status.UNAUTHENTICATED;
      update();
    }
  }

  // For Web
  // Future<void> signInWithGoogleWeb() async {
  //   // Create a new provider
  //   GoogleAuthProvider googleProvider = GoogleAuthProvider();

  //   googleProvider
  //       .addScope('https://www.googleapis.com/auth/contacts.readonly');
  //   googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

  //   // Once signed in, return the UserCredential
  //   await FirebaseAuth.instance.signInWithPopup(googleProvider).then((uCreds) {
  //     print(uCreds);
  //   });

  //   // Or use signInWithRedirect
  //   // return await FirebaseAuth.instance.signInWithRedirect(googleProvider);
  // }

  // Future<void> verifyPhoneNumber(String phoneNumber, Function setData) async {
  //   PhoneVerificationCompleted verificationCompleted =
  //       (PhoneAuthCredential phoneAuthCredential) async {
  //     Get.snackbar("Congratulation!!", "Verification Completed");
  //   };
  //   PhoneVerificationFailed verificationFailed =
  //       (FirebaseAuthException exception) {
  //     Get.snackbar("Something went wrong!!", exception.toString());
  //   };
  //   PhoneCodeSent codeSent = (String verificationID, int? forceResnedingtoken) {
  //     Get.snackbar("Watch out", "Verification Code sent on the phone number");
  //     setData(verificationID);
  //   };

  //   PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
  //       (String verificationID) {
  //     print('Auto retrieval verificationID: $verificationID');
  //     setData(verificationID);
  //   };
  //   try {
  //     print("Phone number is : $phoneNumber");
  //     await _auth.verifyPhoneNumber(
  //         timeout: Duration(seconds: 5),
  //         phoneNumber: phoneNumber,
  //         verificationCompleted: verificationCompleted,
  //         verificationFailed: verificationFailed,
  //         codeSent: codeSent,
  //         codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  //   } catch (e) {
  //     Get.snackbar("Sorry", e.toString());
  //   }
  // }

  // Future<void> signInwithPhoneNumber(
  //   String verificationId,
  //   String smsCode,
  // ) async {
  //   try {
  //     // Changing the status to authenticating
  //     _status.value = Status.AUTHENTICATING;

  //     AuthCredential credential = PhoneAuthProvider.credential(
  //         verificationId: verificationId, smsCode: smsCode);

  //     await _auth.signInWithCredential(credential).then((uCreds) {
  //       print(uCreds);
  //       _status.value = Status.AUTHENTICATED;
  //       Get.back();
  //     });
  //   } catch (e) {
  //     Get.snackbar("Sorry", e.toString());

  //     _status.value = Status.UNAUTHENTICATED;
  //   }
  // }

  Future<void> signOut() async {
    try {
      _auth.signOut();
      googleSignIn.signOut();
      _status.value = Status.UNAUTHENTICATED;
      update();
      return Future.delayed(Duration.zero);
    } catch (e) {
      print(e.toString());
      _status.value = Status.AUTHENTICATED;
      update();
    }
  }

  void showSnackMessage(String code) {
    switch (code) {
      case "account-exists-with-different-credential":
        Get.snackbar(
            "Sorry!!!", "Already exists an account with the email address");
        break;
      case "invalid-credential":
        Get.snackbar("Sorry!!!", "Your credential is malformed or has expired");
        break;
      case "operation-not-allowed":
        Get.snackbar("Sorry its not you!!!", "Google sign In is not enabled");
        break;
      case "email-already-in-use":
        Get.snackbar("Sorry!!!", "The email provided is already exists");
        break;
      case "invalid-email":
        Get.snackbar("Sorry!!!", "Your email is invalid");
        break;
      case "weak-password":
        Get.snackbar("Sorry!!!", "Your password is too weak");
        break;
      case "user-disabled":
        Get.snackbar("Sorry!!!", "Your account has been disabled");
        break;
      case "user-not-found":
        Get.snackbar("Sorry!!!", "Your account cannot be found");
        break;
      case "wrong-password":
        Get.snackbar("Sorry!!!", "Your provided password is invalid");
        break;
      case "invalid-verification-code":
        Get.snackbar("Sorry!!!", "Your verification code is invalid");
        break;
      case "invalid-verification-id":
        Get.snackbar("Sorry!!!", "Your verification id is invalid");
        break;
      default:
        Get.snackbar("Sorry!!!", "Something went wrong. Try again");
    }
  }
}