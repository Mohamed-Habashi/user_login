import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:userlogin/const.dart';
import 'package:userlogin/constants.dart';
import 'package:userlogin/test/pages/cubit/main_cubit.dart';
import 'package:userlogin/test/pages/cubit/main_states.dart';

var nameController=TextEditingController();
var emailController=TextEditingController();
var phoneController=TextEditingController();

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    MainCubit.get(context).getUserData(uId!);
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit,MainStates>(
      listener: (context,state){},
      builder: (context,state){
        var cubit=MainCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: const Text('Main Screen'),
            centerTitle: false,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                )
            ),
            actions: [
              TextButton(
                  onPressed: (){
                    cubit.updateUserData(
                        name: nameController.text,
                        phone: phoneController.text,
                      image: 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                        email: emailController.text,
                    );
                  },
                  child: const Text(
                    'Update',
                    style: TextStyle(
                      color: Colors.white
                    ),
                  )
              ),
            ],
          ),
          body: ConditionalBuilder(
            condition: cubit.userModel!=null,
            builder: (context){
              nameController.text=cubit.userModel!.name!;
              phoneController.text=cubit.userModel!.phone!;
              emailController.text=cubit.userModel!.email!;
              var image=cubit.image;
              var model=cubit.userModel;
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if(state is MainUpdateUserLoadingState)
                          const LinearProgressIndicator(),
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage:image==null? NetworkImage('${model!.image}'):FileImage(image)as ImageProvider,
                            ),
                            CircleAvatar(
                              child: IconButton(
                                onPressed: (){
                                  cubit.selectImage();
                                },
                                icon: const Icon(
                                    Icons.camera_alt
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        defaultFormField(
                            controller: emailController,
                            obscure: false,
                            keyboardType: TextInputType.emailAddress,
                            label: 'email',
                            validator: (value){
                              return null;
                            }
                        ),const SizedBox(
                          height: 30,
                        ),
                        defaultFormField(
                            controller: nameController,
                            obscure: false,
                            keyboardType: TextInputType.text,
                            label: 'name',
                            validator: (value){
                              return null;
                            }
                        ),const SizedBox(
                          height: 30,
                        ),
                        defaultFormField(
                            controller: phoneController,
                            obscure: false,
                            keyboardType: TextInputType.phone,
                            label: 'phone',
                            validator: (value){
                              return null;
                            }
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            fallback: (context)=>os=='android'?const Center(child: CircularProgressIndicator(),):const Center(child: CupertinoActivityIndicator(),),
          ),
        );
      },
    );
  }
}
