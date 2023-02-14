import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:userlogin/const.dart';
import 'package:userlogin/test/register/register_cubit/register_cubit.dart';
import 'package:userlogin/test/register/register_cubit/register_states.dart';

var emailController = TextEditingController();
var passwordController = TextEditingController();
var nameController = TextEditingController();
var phoneController = TextEditingController();
var formKey=GlobalKey<FormState>();
class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=>RegisterCubit(),
      child: BlocConsumer<RegisterCubit,RegisterStates>(
        listener: (context,state){
          if(state is RegisterCreateUserSuccessState){
            Navigator.pop(context);
          }
        },
        builder: (context,state){
          var cubit=RegisterCubit.get(context);
          return Form(
            key: formKey,
            child: Scaffold(
              appBar: AppBar(
                centerTitle: false,
                title: const Text(
                  'RegisterPage',
                ),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20))),
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Register',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        defaultFormField(
                            controller: nameController,
                            obscure: false,
                            keyboardType: TextInputType.text,
                            label: 'Name',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'it must not be empty';
                              }
                              return null;
                            }),
                        const SizedBox(
                          height: 20,
                        ),
                        defaultFormField(
                            controller: emailController,
                            obscure: false,
                            keyboardType: TextInputType.emailAddress,
                            label: 'Email',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'it must not be empty';
                              }
                              return null;
                            }),
                        const SizedBox(
                          height: 20,
                        ),
                        defaultFormField(
                            controller: phoneController,
                            obscure: false,
                            keyboardType: TextInputType.phone,
                            label: 'Phone',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'it must not be empty';
                              }
                              return null;
                            }),
                        const SizedBox(
                          height: 20,
                        ),
                        defaultFormField(
                            controller: passwordController,
                            obscure: cubit.isPassword?false:true,
                            keyboardType: TextInputType.text,
                            label: 'Password',
                            suffixIcon: IconButton(
                                onPressed: (){
                                  cubit.showPassword();
                                },
                                icon: !cubit.isPassword?const Icon(
                                    Icons.visibility
                                ):const Icon(
                                    Icons.visibility_off_outlined
                                )
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'it must not be empty';
                              }
                              return null;
                            }),
                        const SizedBox(
                          height: 20,
                        ),
                        ConditionalBuilder(
                          condition: state is! RegisterSignupLoadingState,
                          builder: (context)=>defaultButton(
                            backColor: Colors.blue,
                            label: 'REGISTER',
                            function: () {
                              if(formKey.currentState!.validate()){
                                cubit.userRegister(
                                    name: nameController.text,
                                    email: emailController.text,
                                    phone: phoneController.text,
                                    password: passwordController.text,
                                    context: context
                                );
                                nameController.clear();
                                emailController.clear();
                                passwordController.clear();
                                phoneController.clear();
                              }
                            },
                          ),
                          fallback: (context)=>const Center(child: CircularProgressIndicator(),),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.3333,
                                height: 1,
                                color: Colors.grey,
                              ),
                            ),
                            const Text('Or'),
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.3333,
                                height: 1,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        defaultButton(
                            label: 'LOGIN',
                            function: () {
                              Navigator.pop(context);
                            }),
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
