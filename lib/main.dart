import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:userlogin/bloc_observer.dart';
import 'package:userlogin/cache_helper.dart';
import 'package:userlogin/constants.dart';
import 'package:userlogin/test/login/login_screen.dart';
import 'package:userlogin/test/pages/cubit/main_cubit.dart';
import 'package:userlogin/test/pages/main_screen.dart';

import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Bloc.observer=MyBlocObserver();
  await CacheHelper.init();
  Widget widget;
  uId=CacheHelper.getData(key: 'uId');
  if(uId!=null){
    widget=const MainScreen();
  }else{
    widget=const LoginScreen();
  }
  runApp( MyApp(
    startPage: widget,
  ));
}

class MyApp extends StatelessWidget {
   MyApp({super.key,required this.startPage});

  Widget ?startPage;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=>MainCubit(),
      child:  MaterialApp(
        home: startPage,
      ),
    );
  }
}

