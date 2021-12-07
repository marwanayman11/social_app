import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_app/layout/layout.dart';
import 'package:social_app/modules/register/cubit/states.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'cubit/cubit.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);
  final emailCont = TextEditingController();
  final passCont = TextEditingController();
  final nameCont = TextEditingController();
  final phoneCont = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (context, state) {
          if(state is RegisterErrorState){
            showToast(message: state.error, state:toastStates.error);
          }
          if(state is CreateUserSuccessState){
            CacheHelper.saveData(key: 'uId', value:state.userModel!.uId).then((value){
              uId=CacheHelper.getData(key:'uId');
              pushToAndFinish(context, const HomeLayout());
            });
          }
        },
        builder: (context, state) => Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Register",
                          style: GoogleFonts.actor(
                              fontSize: 50, color: CacheHelper.getData(key: 'theme')?Colors.white:Colors.black),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Register to be a part of our community",
                          style: GoogleFonts.actor(
                              fontSize: 25, color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        defaultForm(
                            controller: nameCont,
                            type: TextInputType.name,
                            label: "Name",
                            prefix: Icons.person,
                            validate: (String value) {
                              if (value.isEmpty) {
                                return 'Name can\'t be empty';
                              }
                            }),
                        const SizedBox(
                          height: 10,
                        ),
                        defaultForm(
                            controller: emailCont,
                            type: TextInputType.emailAddress,
                            label: "Email Address",
                            prefix: Icons.email_outlined,
                            validate: (String value) {
                              if (value.isEmpty) {
                                return 'Email can\'t be empty';
                              }
                            }),
                        const SizedBox(
                          height: 10,
                        ),
                        defaultForm(
                            controller: passCont,
                            type: TextInputType.visiblePassword,
                            label: "Password",
                            prefix: Icons.lock_outline,
                            isPassword: RegisterCubit.get(context).passVis,
                            suffix: RegisterCubit.get(context).passVis
                                ? Icons.visibility_off
                                : Icons.visibility,
                            suffixPressed: () {
                              RegisterCubit.get(context).changePassVis();
                            },
                            validate: (String value) {
                              if (value.isEmpty) {
                                return 'Password can\'t be empty';
                              }
                            }),
                        const SizedBox(
                          height: 10,
                        ),
                        defaultForm(
                            controller: phoneCont,
                            type: TextInputType.phone,
                            label: "Phone",
                            prefix: Icons.phone,
                            validate: (String value) {
                              if (value.isEmpty) {
                                return 'Phone can\'t be empty';
                              }
                            }),
                        const SizedBox(
                          height: 30,
                        ),
                        state is RegisterLoadingState ? const Center(child: CircularProgressIndicator(),)
                        :defaultButton(
                          text: 'register',
                          function: () {
                            if (formKey.currentState!.validate()) {
                              RegisterCubit.get(context).register(
                                  name: nameCont.text,
                                  email: emailCont.text,
                                  password: passCont.text,
                                  phone: phoneCont.text);
                            }

                          },
                          isUpper: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
