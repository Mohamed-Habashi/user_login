import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:userlogin/test/models/user_model.dart';
import 'package:userlogin/test/register/register_cubit/register_states.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  bool isPassword = false;

  userRegister({
    required String name,
    required String email,
    required String phone,
    required String password,
    required context,
  }) {
    emit(RegisterSignupLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      final snackBar = SnackBar(
        elevation: 0,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Success',
          message: 'Register Success',
          contentType: ContentType.success,
        ),
      );
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
      userCreate(
          name: name,
          phone: phone,
          image: 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
          uId: value.user!.uid,
          email: email,
      );
      emit(RegisterSignupSuccessState());
    }).catchError((error) {
      final snackBar = SnackBar(
        elevation: 0,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Error',
          message: error.toString(),
          contentType: ContentType.failure,
        ),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
      emit(RegisterSignupErrorState());
    });
  }

  userCreate({
    required String name,
    required String phone,
    required String image,
    required String uId,
    required String email,
  }) {
    emit(RegisterCreateUserLoadingState());
    UserModel userModel = UserModel(
        name: name, phone: phone, image: image, email: email, uId: uId);
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(userModel.toMap())
        .then((value) {
      emit(RegisterCreateUserSuccessState());
    }).catchError((error) {
      emit(RegisterCreateUserErrorState());
    });
  }

  showPassword() {
    isPassword = !isPassword;
    emit(RegisterShowPassSuccessState());
  }
}
