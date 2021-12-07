import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_app/layout/layout.dart';
import 'package:social_app/modules/login/cubit/cubit.dart';
import 'package:social_app/modules/login/cubit/states.dart';
import 'package:social_app/modules/register/register.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  final emailCont = TextEditingController();
  final passCont = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=>LoginCubit(),
      child: BlocConsumer<LoginCubit,LoginStates>(
        listener: (context,state){
          if(state is LoginErrorState){
            showToast(message: state.error, state:toastStates.error);
          }
          if(state is LoginSuccessState){
            CacheHelper.saveData(key: 'uId', value:state.userModel!.uId).then((value){
              uId=CacheHelper.getData(key:'uId');
              pushToAndFinish(context, const HomeLayout());
            });

          }
        },
        builder:(context,state)=> Scaffold(
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
                          "Login",
                          style:
                              GoogleFonts.actor(fontSize: 50, color: CacheHelper.getData(key: 'theme')?Colors.white:Colors.black),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Login to know what's happening now",
                          style:
                              GoogleFonts.actor(fontSize: 25, color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        defaultForm(
                            controller: emailCont,
                            type: TextInputType.emailAddress,
                            label: "Email Address",
                            prefix: Icons.email_outlined,
                            validate: (String value) {
                              if (value.isEmpty) {
                                return 'Email must not be empty';
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
                            isPassword: LoginCubit.get(context).passVis,
                            suffix: LoginCubit.get(context).passVis?Icons.visibility_off:Icons.visibility,
                            suffixPressed: () {
                              LoginCubit.get(context).changePassVis();
                            },
                            onSubmit: (value) {
                              if (formKey.currentState!.validate()) {}
                            },
                            validate: (String value) {
                              if (value.isEmpty) {
                                return 'Password must not be empty';
                              }
                            }),
                        const SizedBox(
                          height: 30,
                        ),
                        state is LoginLoadingState?const Center(child: CircularProgressIndicator(),)
                        :defaultButton(
                            text: 'Login',
                            function: () {
                              if (formKey.currentState!.validate()) {
                                LoginCubit.get(context).login(email: emailCont.text, password: passCont.text);
                              }
                            },
                            isUpper: true,
                            ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Don\'t have an account ?',
                                style: GoogleFonts.actor()),
                            TextButton(
                                onPressed: () {
                                  pushTo(context, RegisterScreen());
                                },
                                child: Text(
                                  'Register',
                                  style: GoogleFonts.actor(),
                                ))
                          ],
                        )
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
