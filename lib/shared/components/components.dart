import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';

Widget defaultForm({
  context,
  required TextEditingController controller,
  required TextInputType type,
  required String label,
  required IconData prefix,
  IconData? suffix,
  bool isPassword = false,
  bool visible = false,
  Function? suffixPressed,
  required Function validate,
  Function? onSubmit,
  Function? onChange,
  Function? onTap,
}) =>
    Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
            color: CacheHelper.getData(key: 'theme')?Colors.grey[900]:Colors.white,
      ),
      child: TextFormField(
          controller: controller,
          onFieldSubmitted: (value) => onSubmit!(value),
          onChanged: (value) => onChange!(value),
          validator: (value) => validate(value),
          onTap: () => onTap!(),
          keyboardType: type,
          obscureText: isPassword,
          style: GoogleFonts.actor(

            color    : CacheHelper.getData(key: 'theme')?Colors.white:Colors.black,
          ),
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: label,
            prefixIcon: Icon(
              prefix,
              color: CacheHelper.getData(key: 'theme')?Colors.white:Colors.black,
            ),
            suffixIcon: suffix != null
                ? IconButton(
                onPressed: () => suffixPressed!(), icon: Icon(suffix,color: CacheHelper.getData(key: 'theme')?Colors.white:Colors.black,))
                : null,
            labelStyle: GoogleFonts.actor(color: CacheHelper.getData(key: 'theme')?Colors.white:Colors.black),
          )),
    );

Widget defaultButton({
  double width = double.infinity,
  Color color = Colors.blue,
  double height = 40,
  double radius = 0,
  bool isUpper = true,
  required String text,
  required Function function,
}) =>
    Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: color,
        ),
        child: MaterialButton(
          onPressed: () => function(),
          child: Text(
            isUpper ? text.toUpperCase() : text.toLowerCase(),
            style: GoogleFonts.actor(color: Colors.white, fontSize: 15),
          ),
        ));

void pushTo(context, widget) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
}
void pushToAndFinish(context, widget) {
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => widget),
      ((route) =>false));
}
void showToast ({required String message,required toastStates state})=>BotToast.showSimpleNotification(
    title: message,
    backgroundColor: colorStates(state),
    duration: const Duration(seconds: 2),
    align: Alignment.bottomCenter,
    titleStyle: GoogleFonts.actor(color: Colors.white,fontSize: 20)
);


enum toastStates{error,success,warning}
Color colorStates(toastStates state){
  Color color;
  switch(state)
  {
    case toastStates.success:
      color = Colors.green;
      break;
    case toastStates.error:
      color = Colors.red;
      break;
    case toastStates.warning:
      color = Colors.amber;
      break;
  }
  return color;

}