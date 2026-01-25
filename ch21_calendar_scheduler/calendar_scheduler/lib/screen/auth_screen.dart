import 'package:calendar_scheduler/component/login_text_field.dart';
import 'package:calendar_scheduler/const/colors.dart';
import 'package:calendar_scheduler/provider/schedule_provider.dart';
import 'package:calendar_scheduler/screen/home_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // Form을 제어할 때 사용하는 전역키이다.
  GlobalKey<FormState> formKey = GlobalKey();
  // 이메일
  String? email;
  // 비밀번호
  String? password;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ScheduleProvider>();

    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    "assets/img/logo.png",
                    width: MediaQuery.of(context).size.width * 0.5,
                  ),
                ),
                const SizedBox(height: 16.0),
                // 로그인 할 때 이메일을 입력한다.
                LoginTextField(
                  onSaved: (val) {
                    email = val;
                  },
                  validator: (val) {
                    // 아무것도 입력하지 않으면 오류 메시지를 반환한다.
                    if (val?.isEmpty ?? true) {
                      return "이메일을 입력해주세요.";
                    }

                    // 가랏 정규식!
                    RegExp reg = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
                    if (!reg.hasMatch(val!)) {
                      return "이메일 형식에 맞지 않습니다.";
                    }

                    // 입력값에 문제가 없다면 null을 반환한다.
                    return null;
                  },
                  hintText: "이메일",
                ),
                const SizedBox(
                  height: 8.0,
                ),
                // 비밀번호 필드
                LoginTextField(
                  onSaved: (val) {
                    password = val;
                  },
                  validator: (val) {
                    // 아무것도 입력하지 않으면 오류 메시지를 반환한다.
                    if (val?.isEmpty ?? true) {
                      return "비밀번호를 입력해주세요.";
                    }

                    // 입력된 비밀번호가 4자리에서 8자리 사이인지 확인한다.
                    if (val!.length < 4 || val.length > 8) {
                      return "비밀번호는 4자리에서 8자리 사이여야 합니다.";
                    }

                    // 입력값에 문제가 없다면 null을 반환한다.
                    return null;
                  },
                  obscureText: true,
                  hintText: "비밀번호",
                ),
                const SizedBox(height: 16.0),
                // 회원가입 버튼
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: SECONDARY_COLOR,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.circular(5.0))),
                    onPressed: () {
                      onRegisterPress(provider);
                    },
                    child: const Text("회원가입")),
                // 로그인 버튼
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: SECONDARY_COLOR,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                    onPressed: () {
                      onLoginPress(provider);
                    },
                    child: const Text("로그인"))
              ],
            ),
          )),
    );
  }

  bool saveAndValidateForm() {
    // form을 검증하는 함수를 실행한다.
    if (!formKey.currentState!.validate()) {
      return false;
    }

    // form을 저장하는 함수를 실행한다.
    formKey.currentState!.save();

    return true;
  }

  void onRegisterPress(ScheduleProvider provider) async {
    // form을 검증한다.
    if (!saveAndValidateForm()) {
      return;
    }

    // 에러를 저장할 변수
    String? message;

    try {
      // 회원가입 절차에 들어간다.
      await provider.register(email: email!, password: password!);
    } on DioException catch (e) {
      message = e.response?.data["message"] ?? "알 수 없는 오류가 발생했습니다.";
    } catch (e) {
      message = "알 수 없는 오류가 발생했습니다.";
    } finally {
      // 에러 메시지가 null 이 아닌 경우에 스낵바 표시한다.
      if (message != null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message)));
        }
      } else {
        // 오류가 없다면 홈 화면을 팝업한다.
        if (context.mounted) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const HomeScreen()));
        }
      }
    }
  }

  void onLoginPress(ScheduleProvider provider) async {
    // form을 검증한다.
    if (!saveAndValidateForm()) {
      return;
    }

    // 에러를 저장할 변수
    String? message;

    try {
      // 로그인 절차에 들어간다.
      await provider.login(email: email!, password: password!);
    } on DioException catch (e) {
      // 오류가 있다면 message에 저장한다.
      // 오류 메시지가 없다면 기본값을 저장한다.
      message = e.response?.data["message"] ?? "알 수 없는 오류가 발생했습니다.";
    } catch (e) {
      message = "알 수 없는 오류가 발생했습니다.";
    } finally {
      // 에러 메시지가 null 이 아닌 경우에 스낵바 표시한다.
      if (message != null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message)));
        }
      } else {
        if (context.mounted) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const HomeScreen()));
        }
      }
    }
  }
}
