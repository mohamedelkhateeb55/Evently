import 'package:evently_app/firebase_utilis.dart';
import 'package:evently_app/l10n/app_localizations.dart';
import 'package:evently_app/model/my_user.dart';
import 'package:evently_app/providers/event_list_provider.dart';
import 'package:evently_app/providers/language_provider.dart';
import 'package:evently_app/providers/user_provider.dart';
import 'package:evently_app/ui/auth/register_screen.dart';
import 'package:evently_app/ui/home/widget/custom_elevated_button.dart';
import 'package:evently_app/ui/home/widget/custom_text_field.dart';
import 'package:evently_app/ui/home_screen.dart';
import 'package:evently_app/utilis/app_assets.dart';
import 'package:evently_app/utilis/app_colors.dart';
import 'package:evently_app/utilis/app_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../../utilis/dialog_utils.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = 'login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController =
      TextEditingController(text: 'mohamed@gmail.com');

  TextEditingController passwordController =
      TextEditingController(text: '123456');

  var formKey = GlobalKey<FormState>();

  bool obscureText = true;

  void togglePasswordVisibility() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var languageProvider = Provider.of<LanguageProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.04, vertical: height * 0.02),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(
                    AppAssets.eventLogo,
                    height: height * 0.2,
                    color: AppColors.primaryLight,
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  CustomTextField(
                    prefixIcon: Image.asset(AppAssets.emailIcon),
                    hintText: AppLocalizations.of(context)!.email,
                    keyboardInputType: TextInputType.emailAddress,
                    controller: emailController,
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return "Please enter your email";
                      }
                      final bool emailValid = RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(text);
                      if (!emailValid) {
                        return "Please enter valid email";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  CustomTextField(
                    prefixIcon: Image.asset(AppAssets.passwordIcon),
                    suffixIcon: InkWell(
                        onTap: () {
                          togglePasswordVisibility();
                        },
                        child: obscureText
                            ? Image.asset(AppAssets.shownPasswordIcon)
                            : Icon(Icons.visibility)),
                    hintText: AppLocalizations.of(context)!.password,
                    obscureText: obscureText,
                    keyboardInputType: TextInputType.number,
                    controller: passwordController,
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return "Please enter your password";
                      }
                      return null;
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () {},
                          child: Text(
                            AppLocalizations.of(context)!.forget_password,
                            style: AppStyles.bold16Primary.copyWith(
                                decoration: TextDecoration.underline,
                                decorationColor: AppColors.primaryLight),
                          )),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  CustomElevatedButton(
                      onButtonClick: login,
                      text: AppLocalizations.of(context)!.login),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.do_not_have_account,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(RegisterScreen.routeName);
                          },
                          child: Text(
                            AppLocalizations.of(context)!.create_account,
                            style: AppStyles.bold16Primary.copyWith(
                                decoration: TextDecoration.underline,
                                decorationColor: AppColors.primaryLight),
                          )),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Divider(
                        thickness: 1,
                        color: AppColors.primaryLight,
                        indent: width * 0.05,
                        endIndent: width * 0.05,
                      )),
                      Text(
                        AppLocalizations.of(context)!.or,
                        style: AppStyles.medium16Primary,
                      ),
                      Expanded(
                          child: Divider(
                        thickness: 1,
                        color: AppColors.primaryLight,
                        indent: width * 0.05,
                        endIndent: width * 0.05,
                      ))
                    ],
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  CustomElevatedButton(
                    backgroundColor: AppColors.whiteBgColor,
                    onButtonClick: signInWithGoogle,
                    widget: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          AppAssets.googleIcon,
                          height: height * 0.03,
                        ),
                        SizedBox(
                          width: width * 0.02,
                        ),
                        Text(
                          AppLocalizations.of(context)!.login_with_google,
                          style: AppStyles.medium20Primary,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: width * 0.37),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: AppColors.primaryLight)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                              onTap: () {
                                languageProvider.changeLanguage('en');
                              },
                              child: Image.asset(AppAssets.enIcon)),
                          InkWell(
                              onTap: () {
                                languageProvider.changeLanguage('ar');
                              },
                              child: Image.asset(AppAssets.egIcon)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void login() async {
    if (formKey.currentState?.validate() == true) {
      DialogUtils.showLoading(context: context, message: 'Waiting...');

      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);
        MyUser? user =
            await FirebaseUtilis.readFromFireStore(credential.user?.uid ?? '');
        if (user == null) {
          return;
        }
        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.updateUser(user);
        var eventListProvider =
            Provider.of<EventListProvider>(context, listen: false);
        eventListProvider.changeSelectedIndex(0, userProvider.currentUser!.id);
        DialogUtils.hideLoading(context);
        DialogUtils.showMessage(
            context: context,
            message: "Login successfully",
            title: 'Success',
            posActionName: 'Ok',
            posAction: () {
              Navigator.of(context).pushReplacementNamed(HomeScreen.routName);
            });
        print("Login successfully");
        print(credential.user?.uid ?? '');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        } else if (e.code == 'invalid-credential') {
          DialogUtils.hideLoading(context);
          DialogUtils.showMessage(
            context: context,
            message: "Wrong password or email_address",
            title: 'Error',
            posActionName: 'Ok',
          );
          print('Wrong password or email_address');
        }
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      DialogUtils.showLoading(
          context: context,
          message: "${AppLocalizations.of(context)!.login_with_google}...");
      GoogleSignIn googleSignIn = GoogleSignIn();

      await googleSignIn.signOut();
      var googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        DialogUtils.hideLoading(context);
        return;
      }
      var googleAuth = await googleUser.authentication;
      var credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      var userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      var firebaseUser = userCredential.user;
      if (userCredential == null) {
        DialogUtils.hideLoading(context);
        DialogUtils.showMessage(context: context, message: "faild");
      }
      var myUser = await FirebaseUtilis.readFromFireStore(firebaseUser!.uid);
      if (myUser == null) {
        myUser = MyUser(
            id: firebaseUser.uid,
            name: firebaseUser.displayName ?? '',
            email: firebaseUser.email ?? '');
        await FirebaseUtilis.addUserToFireStore(myUser);
      }
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.updateUser(myUser);
      var eventListProvider =
          Provider.of<EventListProvider>(context, listen: false);
      eventListProvider.changeSelectedIndex(0, userProvider.currentUser!.id);

      DialogUtils.hideLoading(context);
      DialogUtils.showMessage(
          context: context,
          message: "Success",
          posActionName: "Ok",
          posAction: () {
            Navigator.pushReplacementNamed(context, HomeScreen.routName);
          });
    } catch (e) {
      DialogUtils.hideLoading(context);
      DialogUtils.showMessage(context: context, message: e.toString());
      print("google error :$e");
    }
  }
}
