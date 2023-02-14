import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:userlogin/constants.dart';
import 'package:userlogin/test/models/user_model.dart';
import 'package:userlogin/test/pages/cubit/main_states.dart';

class MainCubit extends Cubit<MainStates> {
  MainCubit() : super(MainInitialState());

  static MainCubit get(context) => BlocProvider.of(context);

  UserModel? userModel;


  getUserData(String id) {
    emit(MainGetUserDataLoadingState());
    FirebaseFirestore.instance.collection('users').doc(id).get().then((value) {
      userModel=UserModel.fromJson(value.data()!);
      emit(MainGetUserDataSuccessState());
    }).catchError((error) {
      emit(MainGetUserDataErrorState());
    });
  }

  updateUserData({
    required String name,
    required String phone,
    required String image,
    required String email,
}){
    emit(MainUpdateUserLoadingState());
    UserModel userModel=UserModel(
        name: name,
        phone: phone,
        image: image,
        email: email,
        uId: uId
    );
    FirebaseFirestore.instance.collection('users').doc(uId).update(userModel.toMap()).then((value){
      getUserData(uId!);
      emit(MainUpdateUserSuccessState());
    }).catchError((error){
      emit(MainUpdateUserErrorState());
    });
  }

  File ?image;
  final picker=ImagePicker();
  selectImage(){
     picker.getImage(source: ImageSource.gallery).then((value){
      if(value!=null){
        image=File(value.path);
      }
    });

  }
  
  uploadImage({
    required String name,
    required String phone,
    required String email,
}){
    FirebaseStorage.instance.ref().child('photos/${Uri.file(image!.path).pathSegments.last}').putFile(image!).then((value){
      value.ref.getDownloadURL().then((value){
        updateUserData(name: name, phone: phone, image: value, email: email);
      });
    });
  }


}
