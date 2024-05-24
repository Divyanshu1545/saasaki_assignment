import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:saasaki_assignment/screens/otp_screen.dart';
import 'package:saasaki_assignment/utils/snack_bar.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _verificationId = '';
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> verifyPhoneNumber(
      BuildContext context, String phoneNumber) async {
    setLoading(true);

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        setLoading(false);
      },
      verificationFailed: (FirebaseAuthException e) {
        setLoading(false);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('The provided phone number is not valid.'),
          backgroundColor: Colors.red,
        ));
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        setLoading(false);
        Navigator.pushNamed(context, 'otp_screen', arguments: verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
        setLoading(false);
      },
    );
  }

  void verifyOtp({
    required BuildContext context,
    required String userOtp,
    required String verificationId,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();

    PhoneAuthCredential creds = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: userOtp);
    try {
      User? user = (await _auth.signInWithCredential(creds)).user;

      onSuccess();
    } on FirebaseAuthException catch (e) {
      snackBar(context, e.message.toString(), 'red');
    }

    _isLoading = false;
    notifyListeners();
  }

  void logout(context) {
    _auth.signOut();
    Navigator.pushNamedAndRemoveUntil(
        context, 'phone_number_screen', (route) => false);
  }
}
