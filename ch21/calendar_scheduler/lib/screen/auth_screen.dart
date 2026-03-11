import 'package:calendar_scheduler/component/login_text_field.dart';
import 'package:calendar_scheduler/const/colors.dart';
import 'package:calendar_scheduler/provider/schedule_provider.dart';
import 'package:calendar_scheduler/screen/home_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  /// 로그인 화면
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email = "";
  String _password = "";

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ScheduleProvider>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 로고
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/img/logo.png",
                  width: MediaQuery.of(context).size.width / 2,
                ),
              ),
              const SizedBox(height: 16.0),
              // 로그인 텍스트 필드
              LoginTextField(
                onSaved: (val) {
                  _email = val!;
                },
                validator: (val) {
                  if (val?.isEmpty ?? true) {
                    return "이메일을 입력해주세요.";
                  }
                  // 아래로 val은 null이 아니다.

                  final reg = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
                  if (!reg.hasMatch(val!)) {
                    return "이메일 형식이 올바르지 않습니다.";
                  }

                  return null;
                },
                hintText: "이메일",
              ),
              const SizedBox(height: 8.0),
              // 비밀번호 텍스트 필드
              LoginTextField(
                obscureText: true,
                onSaved: (val) {
                  _password = val!;
                },
                validator: (val) {
                  if (val?.isEmpty ?? true) {
                    return "비밀번호를 입력해주세요.";
                  }
                  // 아래로 val은 null이 아니다.

                  if (val!.length < 4 || val.length > 8) {
                    return "비밀번호는 4~8자 사이로 입력해주세요!";
                  }

                  return null;
                },
                hintText: "비밀번호",
              ),
              const SizedBox(height: 16.0),
              // 회원가입 버튼
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: secondaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onPressed: () {
                  onRegisterPress(context, provider);
                },
                child: const Text("회원가입"),
              ),
              // 로그인 버튼
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: secondaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onPressed: () {
                  onLoginPress(context, provider);
                },
                child: const Text("로그인"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool saveAndValidateForm() {
    if (!_formKey.currentState!.validate()) {
      return false;
    }

    _formKey.currentState!.save();

    return true;
  }

  void onRegisterPress(BuildContext context, ScheduleProvider provider) async {
    if (!saveAndValidateForm()) {
      return;
    }

    String? message;

    try {
      await provider.register(email: _email, password: _password);
    } on DioException catch (e) {
      message = e.response?.data["message"] ?? "알 수 없는 오류가 발생했습니다.";
    } catch (e) {
      message = "알 수 없는 오류가 발생했습니다.";
    } finally {
      if (message != null) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message)));
        }
      } else {
        if (context.mounted) {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => HomeScreen()));
        }
      }
    }
  }

  void onLoginPress(BuildContext context, ScheduleProvider provider) async {
    if (!saveAndValidateForm()) {
      return;
    }

    String? message;

    try {
      await provider.login(email: _email, password: _password);
    } on DioException catch (e) {
      message = e.response?.data["message"] ?? "알 수 없는 오류가 발생했습니다.";
    } catch (e) {
      message = "알 수 없는 오류가 발생했습니다.";
    } finally {
      if (context.mounted) {
        if (message != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message)));
        } else {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => HomeScreen()));
        }
      }
    }
  }
}
