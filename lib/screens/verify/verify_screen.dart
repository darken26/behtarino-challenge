import 'package:behtarino/core/utils/convert_numbers.dart';
import 'package:behtarino/core/utils/snack_bar.dart';
import 'package:behtarino/models/auth_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';

import '../../blocs/verify/verify_bloc.dart';
import '../../core/sqflite/auth_db.dart';

class VerifyScreen extends StatefulWidget {
  final String loginKey;
  final String userName;

  const VerifyScreen({Key? key, required this.userName, required this.loginKey})
      : super(key: key);

  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final TextEditingController _controller = TextEditingController();

  submit() {
    if (_controller.text.length < 4 || _controller.text.length > 4) {
      CustomSnackBar()
          .show(message: 'طول کد تایید باید ۴ رقم باشد', context: context);
    } else {
      final String otp = Converter().convertToEnglishNumber(_controller.text);

      if (int.tryParse(otp) != null) {
        BlocProvider.of<VerifyBloc>(context).add(
          SubmitOtp(
            otp: int.tryParse(otp)!,
            key: widget.loginKey,
            userName: widget.userName,
          ),
        );
      } else {
        CustomSnackBar()
            .show(message: 'فرمت کد تایید صحیح نیست!', context: context);
      }
    }
  }

  final defaultPinTheme = PinTheme(
    width: 40,
    height: 57,
    textStyle: const TextStyle(
      fontSize: 20,
      color: Colors.black,
      fontFamily: 'Iran-sans',
    ),
    decoration: BoxDecoration(
      color: const Color(0xffB9EBFB).withOpacity(0.2),
      border: Border.all(color: const Color(0xff4CC9F0)),
      borderRadius: BorderRadius.circular(24),
    ),
  );

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
              RichText(
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(
                    fontFamily: 'Iran-sans',
                    fontSize: 15,
                    color: Colors.black,
                  ),
                  children: [
                    const TextSpan(
                      text: 'کد چهار رقمی ارسال شده به شماره‌ی\n',
                    ),
                    TextSpan(
                      text:
                          Converter().convertToPersianNumbers(widget.userName),
                      style: const TextStyle(
                        color: Color(0xff4361ee),
                      ),
                    ),
                    const TextSpan(text: ' را وارد کنید.'),
                  ],
                ),
              ),
              const SizedBox(height: 45),
              Pinput(
                controller: _controller,
                defaultPinTheme: defaultPinTheme,
                keyboardType: TextInputType.number,
                length: 4,
                autofocus: true,
                separator: const SizedBox(width: 24),
                onChanged: (String data) {
                  _controller.setText(
                    Converter().convertToPersianNumbers(data),
                  );
                },
                preFilledWidget: const Text(
                  '۰',
                  style: TextStyle(
                    color: Colors.black12,
                    fontSize: 20,
                    fontFamily: 'Iran-sans',
                  ),
                ),
                onCompleted: (pin) => submit,
              ),
              const SizedBox(height: 20),
              BlocConsumer<VerifyBloc, VerifyState>(
                listener: (context, state) {
                  if (state is VerifyDone) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/calendar',
                      ModalRoute.withName('/calendar'),
                    );
                  }
                  if (state is VerifyError) {
                    CustomSnackBar().show(
                      message: state.message,
                      context: context,
                    );
                  }
                },
                builder: (context, state) {
                  return MaterialButton(
                    onPressed: state is VerifyDone ? null : submit,
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
                          child: state is VerifyLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 1,
                                )
                              : const Text(
                                  'ارسال',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Iran-sans',
                                    fontSize: 16,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
