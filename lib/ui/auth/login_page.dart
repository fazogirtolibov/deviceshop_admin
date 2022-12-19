import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';

import '../../utils/color.dart';
import '../../utils/my_utils.dart';
import '../../utils/style.dart';
import '../../view_models/auth_view_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.onClickSignUp}) : super(key: key);

  final VoidCallback onClickSignUp;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPas = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 100),
            Text(
              "Login",
              style: GoogleFonts.raleway(
                  fontWeight: FontWeight.w700, fontSize: 30),
            ),
            const SizedBox(height: 100),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: emailController,
                textInputAction: TextInputAction.next,
                style: MyTextStyle.sfProRegular.copyWith(
                  color: MyColors.black,
                  fontSize: 17,
                ),
                decoration: getInputDecoration(label: "Email"),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: passwordController,
                obscureText: !isPas,
                textInputAction: TextInputAction.done,
                style: MyTextStyle.sfProRegular.copyWith(
                  color: MyColors.black,
                  fontSize: 17,
                ),
                decoration: getInputDecorationByPassword(
                    label: 'Password',
                    onTap: () {
                      setState(() {
                        setState(() {
                          isPas = !isPas;
                        });
                      });
                    },
                    isPas: isPas),
              ),
            ),
            const SizedBox(height: 100),
            ElevatedButton(
              onPressed: signIn,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff2A2A2A),
              ),
              child: const Text("Sign In"),
            ),
            const SizedBox(height: 20),
            RichText(
              text: TextSpan(
                style: MyTextStyle.sfProRegular
                    .copyWith(color: const Color(0xff2A2A2A), fontSize: 18),
                text: "Don't have an account?  ",
                children: [
                  TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = widget.onClickSignUp,
                    text: "Sign Up",
                    style: MyTextStyle.sfProBold.copyWith(
                      color: const Color(0xff2A2A2A),
                      fontSize: 18,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //" Hello World  "

  Future<void> signIn() async {
    Provider.of<AuthViewModel>(context, listen: false).signIn(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
