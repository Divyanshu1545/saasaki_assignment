import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saasaki_assignment/providers/authentication_provider.dart'
    as MyAuthProvider;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:saasaki_assignment/utils/snack_bar.dart';

import 'dart:developer' as devTools;

import 'package:saasaki_assignment/widgets/custum_button.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  @override
  Widget build(BuildContext context) {
    final verificationID = ModalRoute.of(context)?.settings.arguments as String;
    bool isLoading =
        Provider.of<MyAuthProvider.AuthProvider>(context).isLoading;

    TextEditingController otpController = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 25,
              horizontal: 35,
            ),
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(Icons.arrow_back),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.purple.shade50,
                    ),
                    padding: const EdgeInsets.all(20),
                    height: 200,
                    width: 200,
                    child: Image.asset("assets/image3.png"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "OTP Verification",
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "We sent an OTP your way, we are trying to fill it for you",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black26),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  PinCodeTextField(
                    controller: otpController,
                    onCompleted: (value) {
                      verifyOtp(context, value, verificationID);
                    },
                    appContext: context,
                    length: 6,
                    pinTheme: PinTheme(
                      fieldHeight: 50,
                      fieldWidth: 40,
                      selectedColor: Colors.purple.shade700,
                      inactiveColor: Colors.purple.shade300,
                      activeFillColor: Colors.purple.shade100,
                      borderRadius: BorderRadius.circular(10),
                      shape: PinCodeFieldShape.box,
                      activeColor: Colors.purple.shade200,
                      selectedBorderWidth: 2,
                    ),
                    keyboardType: TextInputType.number,
                    autoDismissKeyboard: true,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.purple,
                        )
                      : SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: CustomButton(
                            text: "Verify OTP",
                            onPressed: () {
                              String userOtp = otpController.text.trim();
                              if (userOtp.length < 6) {
                                snackBar(
                                    context, "Please enter a valid OTP", 'red');
                              } else {
                                verifyOtp(context, userOtp, verificationID);
                              }
                            },
                          ),
                        ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Didn't receive any code?",
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextButton(
                    onPressed: () {
                      // Logic to resend OTP
                    },
                    child: const Text(
                      "Get a new one",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.purple,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void verifyOtp(BuildContext context, String userOtp, String verificationId) {
    final ap = Provider.of<MyAuthProvider.AuthProvider>(context, listen: false);
    try {
      ap.verifyOtp(
        context: context,
        userOtp: userOtp,
        verificationId: verificationId,
        onSuccess: () async {
          snackBar(context, "Logged In successfully", 'red');
          // bool dataExists = await ap.checkUserDataExists();
          // await HelperFunctions.saveLoggedInUserId(ap.getUserId());
          // String? uid = await HelperFunctions.getLoggedInUserId();
          // devTools.log("User ID:");
          // devTools.log(uid ?? "Not saved");
          // if (dataExists) {
          //   Navigator.of(context).pushReplacement(MaterialPageRoute(
          //     builder: (context) => const HomeScreen(),
          //   ));
          // } else {
          //   Navigator.of(context).pushReplacement(MaterialPageRoute(
          //     builder: (context) => const ProfileSettingScreen(),
          //   ));
          // }
        },
      );
    } on FirebaseAuthException catch (e) {
      snackBar(context, e.message.toString(), 'red');
    }
  }
}
