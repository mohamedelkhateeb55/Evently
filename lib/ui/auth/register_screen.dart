import 'package:evently_app/firebase_utilis.dart';
import 'package:evently_app/l10n/app_localizations.dart';
import 'package:evently_app/model/my_user.dart';
import 'package:evently_app/providers/language_provider.dart';
import 'package:evently_app/providers/user_provider.dart';
import 'package:evently_app/ui/auth/login_screen.dart';
import 'package:evently_app/ui/home/widget/custom_elevated_button.dart';
import 'package:evently_app/ui/home_screen.dart';
import 'package:evently_app/utilis/app_styles.dart';
import 'package:evently_app/utilis/dialog_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/event_list_provider.dart';
import '../../utilis/app_assets.dart';
import '../../utilis/app_colors.dart';
import '../home/widget/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = 'register_screen';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController =
      TextEditingController(text: 'mohamed@gmail.com');

  TextEditingController passwordController =
      TextEditingController(text: '123456');

  TextEditingController nameController = TextEditingController(text: 'Mohamed');

  TextEditingController RePasswordController =
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
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          AppLocalizations.of(context)!.register,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        centerTitle: true,
      ),
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
                    prefixIcon: Image.asset(AppAssets.nameIcon),
                    hintText: AppLocalizations.of(context)!.name,
                    controller: nameController,
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return "Please enter your name";
                      }
                      return null;
                    },
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
                    hintText: AppLocalizations.of(context)!.re_password,
                    obscureText: obscureText,
                    keyboardInputType: TextInputType.number,
                    controller: RePasswordController,
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return "Please enter your password";
                      }
                      if (text != passwordController.text) {
                        return "Password not correct!";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  CustomElevatedButton(
                      onButtonClick: createAccount,
                      text: AppLocalizations.of(context)!.create_account),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.already_have_account,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(LoginScreen.routeName);
                          },
                          child: Text(
                            AppLocalizations.of(context)!.login,
                            style: AppStyles.bold16Primary.copyWith(
                                decoration: TextDecoration.underline,
                                decorationColor: AppColors.primaryLight),
                          )),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.015,
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
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void createAccount() async {
    if (formKey.currentState?.validate() == true) {
      DialogUtils.showLoading(context: context, message: 'Loading...');
      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        MyUser myUser = MyUser(
            id: credential.user?.uid ?? '',
            name: nameController.text,
            email: emailController.text);
        await FirebaseUtilis.addUserToFireStore(myUser);
        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.updateUser(myUser);
        var eventListProvider =
            Provider.of<EventListProvider>(context, listen: false);
        eventListProvider.changeSelectedIndex(0, userProvider.currentUser!.id);
        DialogUtils.hideLoading(context);
        DialogUtils.showMessage(
            context: context,
            message: "RegisterSuccessfully",
            title: 'Success',
            posActionName: 'Ok',
            posAction: () {
              Navigator.of(context).pushReplacementNamed(HomeScreen.routName);
            });
        print("register successfully");
        print(credential.user?.uid ?? '');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          DialogUtils.hideLoading(context);
          DialogUtils.showMessage(
              title: 'Error',
              posActionName: 'Ok',
              context: context,
              message: "The password provided is too weak.");
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          DialogUtils.hideLoading(context);
          DialogUtils.showMessage(
              title: 'error',
              posActionName: 'Ok',
              context: context,
              message: "The account already exists for that email.");
          print('The account already exists for that email.');
        }
      } catch (e) {
        DialogUtils.hideLoading(context);
        DialogUtils.showMessage(
            title: 'error',
            posActionName: 'Ok',
            context: context,
            message: "The account already exists for that email.");
        print(e.toString());
        print(e);
      }
    }
  }
}
