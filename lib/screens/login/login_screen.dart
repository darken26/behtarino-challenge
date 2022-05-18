import 'package:behtarino/core/utils/snack_bar.dart';
import 'package:behtarino/screens/verify/verify_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/login/login_bloc.dart';
import '../../core/utils/convert_numbers.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _controller = TextEditingController();

  submit() {
    if (_controller.text.length < 11 || _controller.text.length > 11) {
      CustomSnackBar()
          .show(message: 'طول شماره موبایل صحیح نیست', context: context);
    } else {

      FocusManager.instance.primaryFocus?.unfocus();
      if(int.tryParse(_controller.text) != null) {
        BlocProvider.of<LoginBloc>(context).add(
          SubmitLogin(userName: _controller.text),
        );
      } else {
        CustomSnackBar()
            .show(message: 'فرمت شماره موبایل صحیح نیست!', context: context);
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: const Color(0xfffbfbfb),
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'لطفا شماره‌ی تلفن همراه خود را وارد کنید.',
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontFamily: 'Iran-sans',
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 45),
              TextField(
                controller: _controller,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                keyboardType: TextInputType.number,
                maxLength: 11,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                style: const TextStyle(
                  height: 1,
                  fontFamily: 'iran-sans',
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  hintText: '۰۹۳۶۵۴۶۴۷۸۶ :مثال',
                  counterText: "",
                  filled: true,
                  fillColor: const Color(0xffB9EBFB).withOpacity(0.2),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                    borderSide: BorderSide(
                      color: Color(0xff4CC9F0),
                      width: 1,
                    ),
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                    borderSide: BorderSide(
                      color: Color(0xff4CC9F0),
                      width: 1,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              MaterialButton(
                onPressed: submit,
                padding: const EdgeInsets.fromLTRB(1, 0, 1, 8),
                child: Ink(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xff4bbef0), Color(0xff4366ee)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Center(
                      child: BlocConsumer<LoginBloc, LoginState>(
                        listener: (context, state) {
                          if (state is LoginDone) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => VerifyScreen(
                                  loginKey: state.login.key,
                                  userName: _controller.text,
                                ),
                              ),
                            );
                          }
                          if (state is LoginError) {
                            CustomSnackBar()
                                .show(message: state.message, context: context);
                          }
                        },
                        builder: (context, state) {
                          if (state is LoginLoading) {
                            return const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 1,
                            );
                          }

                          return const Text(
                            'ارسال',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Iran-sans',
                              fontSize: 16,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
