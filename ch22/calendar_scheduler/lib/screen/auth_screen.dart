import 'package:calendar_scheduler/const/colors.dart';
import 'package:calendar_scheduler/screen/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthScreen extends StatelessWidget {
  @Preview(name: "AuthScreen")
  const AuthScreen({super.key});

  /// 처음 표시하는 로그인 화면
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 로고
            Center(
              child: FractionallySizedBox(
                widthFactor: 0.7,
                child: Image.asset("assets/img/logo.png"),
              ),
            ),
            SizedBox(height: 16.0),
            // 로그인 버튼
            ElevatedButton(
              onPressed: () => onGoogleLoginPress(context),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: secondaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              child: Text("구글로 로그인"),
            ),
          ],
        ),
      ),
    );
  }

  void onGoogleLoginPress(BuildContext context) async {
    GoogleSignIn googleSignIn = GoogleSignIn.instance;

    await googleSignIn.initialize();

    try {
      final googleUser = await googleSignIn.authenticate(scopeHint: ["email"]);
      final authorization = await googleSignIn.authorizationClient
          .authorizationForScopes(["email"]);
      final googleAuth = googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: authorization?.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      if (context.mounted) {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => HomeScreen()));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("로그인 실패")));
      }
    }
  }
}
