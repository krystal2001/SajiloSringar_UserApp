import 'package:flutter/material.dart';

import '../login_screen.dart';
import 'widgets/signup_form_widget.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            // padding: const EdgeInsets.all(tDefaultSize),
            child: Column(children: [
              // FormHeaderWidget(
              //   image: tSignUpImage,
              //   title: tSignUpTitle,
              //   subTitle: tsignUpSubTitle,
              // ),
              const SignUpFormWidget(),
              Column(
                children: [
                  const Text('OR'),
                  // SizedBox(
                  //   width: double.infinity,
                  //   child: OutlinedButton.icon(
                  //     onPressed: () {},
                  //     icon: const Image(
                  //       image: AssetImage(tGoogleLogoImage),
                  //       width: 20.0,
                  //     ),
                  //     label: const Text(tSignInWithGoogle),
                  //   ),
                  // ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    },
                    child: Text.rich(TextSpan(children: [
                      TextSpan(
                        text: "tAlreadyHaveAnAccount",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      TextSpan(
                        text: "tLogin",
                      )
                    ])),
                  ),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
