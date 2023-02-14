import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:userlogin/cache_helper.dart';
import 'package:userlogin/const.dart';
import 'package:userlogin/constants.dart';
import 'package:userlogin/test/login/login_cubit/login_cubit.dart';
import 'package:userlogin/test/login/login_cubit/login_states.dart';
import 'package:userlogin/test/pages/main_screen.dart';
import 'package:userlogin/test/pages/reset_password.dart';
import 'package:userlogin/test/register/register_screen.dart';

var emailController=TextEditingController();
var passwordController=TextEditingController();
var formKey=GlobalKey<FormState>();

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=>LoginCubit(),
      child: BlocConsumer<LoginCubit,LoginStates>(
        listener: (context,state){
          if(state is LoginSignInSuccessState){
            CacheHelper.saveData(key: 'uId', value: state.uId).then((value){
              navigateToFinish(context, const MainScreen());
            });
          }
        },
        builder: (context,state){
          var cubit=LoginCubit.get(context);
          return Form(
            key: formKey,
            child: Scaffold(
              appBar: AppBar(
                centerTitle: false,
                title: const Text(
                  'LoginPage',
                ),
                shape:  const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)
                    )
                ),
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
                          'LOGIN',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        defaultFormField(
                            controller: emailController,
                            obscure: false,
                            keyboardType: TextInputType.emailAddress,
                            label: 'Email',
                            validator: (value){
                              if(value!.isEmpty){
                                return 'it must not be empty';
                              }
                              return null;
                            }
                        ),
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
                            validator: (value){
                              if(value!.isEmpty){
                                return 'it must not be empty';
                              }
                              return null;
                            }
                        ),
                        const SizedBox(
                          height: 20,
                        ),

                        ConditionalBuilder(
                            condition: state is! LoginSignInLoadingState,
                            builder: (context)=>defaultButton(
                              backColor: Colors.blue,
                              label: 'LOGIN',
                              function: (){
                                if(formKey.currentState!.validate()){
                                  LoginCubit.get(context).userLogin(
                                      email: emailController.text,
                                      password: passwordController.text,
                                      context: context
                                  );
                                  emailController.clear();
                                  passwordController.clear();
                                }

                              },
                            ),
                            fallback: (context)=>os=='android'?const Center(child: CircularProgressIndicator(),):const Center(child: CupertinoActivityIndicator(),)
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                                onPressed: (){
                                  navigateTo(context, const ResetPassword());
                                },
                                child: const Text(
                                    'Forget Password'
                                )
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: Container(
                                width: MediaQuery.of(context).size.width*0.3333,
                                height: 1,
                                color: Colors.grey,
                              ),
                            ),
                            const Text('Or'),
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Container(
                                width: MediaQuery.of(context).size.width*0.3333,
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
                            label: 'Register',
                            function: (){
                              navigateTo(context, const RegisterScreen());
                            }
                        ),
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
