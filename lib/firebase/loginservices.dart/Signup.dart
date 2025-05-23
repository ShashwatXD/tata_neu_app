import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tata_neu/firebase/loginservices.dart/Wrapper.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  bool isLoading = false;
  bool obscureText = true;
  bool obscureConfirmText = true;
  String passwordStrength = '';
  String errorMessage = '';
  String confirmPasswordError = '';

  void togglePasswordVisibility() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  void toggleConfirmPasswordVisibility() {
    setState(() {
      obscureConfirmText = !obscureConfirmText;
    });
  }

  void checkPasswordStrength(String password) {
    if (password.length < 8) {
      setState(() {
        passwordStrength = 'Password must be at least 8 characters long.';
      });
    } else if (!RegExp(r'[A-Z]').hasMatch(password)) {
      setState(() {
        passwordStrength =
            'Password must contain at least one uppercase letter.';
      });
    } else if (!RegExp(r'[0-9]').hasMatch(password)) {
      setState(() {
        passwordStrength = 'Password must contain at least one number.';
      });
    } else if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password)) {
      setState(() {
        passwordStrength =
            'Password must contain at least one special character.';
      });
    } else {
      setState(() {
        passwordStrength = '';
      });
    }
  }

  signUp() async {
    setState(() {
      isLoading = true;
      confirmPasswordError = '';
    });

    if (!email.text.trim().contains('@') && !email.text.trim().contains('.')) {
      setState(() {
        errorMessage = 'Enter Valid Email/Username';
      });
      setState(() {
        isLoading = false;
      });
      return;
    }

    if (passwordStrength.isNotEmpty) {
      setState(() {
        errorMessage = 'Please fix the issues in the password.';
      });
      setState(() {
        isLoading = false;
      });
      return;
    }

    if (password.text != confirmPassword.text) {
      setState(() {
        confirmPasswordError = 'Both passwords do not match.';
      });
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text,
      )
          .then((value) {
        Get.snackbar("Verification Sent", "Check Your Email",
            backgroundColor: Colors.white);
        Get.off(() => Wrapper());
      });
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error Message", e.message ?? "An error occurred",
          backgroundColor: Colors.white);
    } catch (e) {
      Get.snackbar('Error Message', e.toString(),
          backgroundColor: Colors.white);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurpleAccent, Colors.purple.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cabin_rounded,
                  size: 140.0,
                  color: Colors.purple.shade100,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: email,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon:
                        Icon(Icons.email, color: Colors.purple.shade100),
                  ),
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextField(
                      controller: password,
                      obscureText: obscureText,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon:
                            Icon(Icons.lock, color: Colors.purple.shade100),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.purple.shade100,
                          ),
                          onPressed: togglePasswordVisibility,
                        ),
                      ),
                      onChanged: checkPasswordStrength,
                    ),
                    if (passwordStrength.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          passwordStrength,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: confirmPassword,
                      obscureText: obscureConfirmText,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon:
                            Icon(Icons.lock, color: Colors.purple.shade100),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureConfirmText
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.purple.shade100,
                          ),
                          onPressed: toggleConfirmPasswordVisibility,
                        ),
                      ),
                    ),
                    if (confirmPasswordError.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          confirmPasswordError,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                ),
                if (errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      errorMessage,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      colors: [Colors.orange, Colors.purple],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: isLoading ? null : signUp,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Already have an account? Login",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
