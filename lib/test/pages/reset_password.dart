import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:userlogin/const.dart';
import 'package:userlogin/test/login/login_cubit/login_cubit.dart';
import 'package:userlogin/test/login/login_cubit/login_states.dart';
import 'package:userlogin/test/pages/cubit/main_cubit.dart';
import 'package:userlogin/test/pages/cubit/main_states.dart';

var emailController = TextEditingController();
var formKey = GlobalKey<FormState>();

class ResetPassword extends StatelessWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Form(
            key: formKey,
            child: SafeArea(
              child: Scaffold(
                body: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        defaultFormField(
                            controller: emailController,
                            obscure: false,
                            keyboardType: TextInputType.emailAddress,
                            label: 'email-address',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please Enter an email';
                              }
                            }),
                        const SizedBox(
                          height: 20,
                        ),
                        defaultButton(
                            backColor: Colors.blue,
                            label: 'Send',
                            function: () {
                              if (formKey.currentState!.validate()) {
                                LoginCubit.get(context).resetPassword(
                                    email: emailController.text,
                                    context: context);
                              }
                            })
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
