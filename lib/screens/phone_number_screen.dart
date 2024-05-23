import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:saasaki_assignment/providers/authentication_provider.dart';
import 'package:saasaki_assignment/utils/snack_bar.dart';
import 'package:saasaki_assignment/widgets/custum_button.dart';
import 'dart:developer' as devTools;

class PhoneNumberScreen extends StatefulWidget {
  const PhoneNumberScreen({super.key});

  @override
  State<PhoneNumberScreen> createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends State<PhoneNumberScreen> {
  final TextEditingController phoneController = TextEditingController();
  Country country = Country(
    phoneCode: "91",
    countryCode: "IN",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "India",
    example: "India",
    displayName: "India",
    displayNameNoCountryCode: "IN",
    e164Key: "",
  );

  @override
  Widget build(BuildContext context) {
    bool isLoading = Provider.of<AuthProvider>(context).isLoading;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 45),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.purple.shade50,
                    ),
                    padding: const EdgeInsets.all(20),
                    height: 200,
                    width: 200,
                    child: Image.asset("assets/image2.png"),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Let's Get Started",
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Enter your phone number. We'll send you an OTP",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black26,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: phoneController,
                    maxLength: 10,
                    decoration: InputDecoration(
                      prefixIcon: Container(
                        width: 80,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.all(8),
                        child: InkWell(
                          onTap: () {
                            showCountryPicker(
                              context: context,
                              countryListTheme: CountryListThemeData(
                                bottomSheetHeight: 500,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              onSelect: (value) {
                                setState(() {
                                  country = value;
                                });
                              },
                            );
                          },
                          child: Text(
                            "${country.flagEmoji} + ${country.phoneCode}",
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      hintText: "Enter phone number",
                      hintStyle: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade500,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black12),
                      ),
                    ),
                    cursorColor: Colors.purple,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    autofillHints: const [
                      AutofillHints.telephoneNumber,
                    ],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  isLoading
                    ? const CircularProgressIndicator(color: Colors.purple)
                    : SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: CustomButton(
                          text: "Get OTP",
                          onPressed: () {
                            if (phoneController.text.trim().length < 10) {
                              snackBar(context, "Please enter a valid number", 'red');
                            } else {
                              sendPhoneNumber();
                            }
                          },
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

  void sendPhoneNumber() {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    String phoneNumber = phoneController.text.trim();
    ap.verifyPhoneNumber(context, "+${country.phoneCode}$phoneNumber");
    devTools.log("+${country.countryCode}$phoneNumber");
  }
}
