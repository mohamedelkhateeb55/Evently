import 'package:evently_app/l10n/app_localizations.dart';
import 'package:evently_app/providers/language_provider.dart';
import 'package:evently_app/providers/theme_provider.dart';
import 'package:evently_app/providers/user_provider.dart';
import 'package:evently_app/ui/auth/login_screen.dart';
import 'package:evently_app/ui/home/tabs/profile/language_button_sheet.dart';
import 'package:evently_app/ui/home/tabs/profile/theme_button_sheet.dart';
import 'package:evently_app/utilis/app_assets.dart';
import 'package:evently_app/utilis/app_colors.dart';
import 'package:evently_app/utilis/app_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var languageProvider = Provider.of<LanguageProvider>(context);
    var themeProvider = Provider.of<ThemeProvider>(context);
    var userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
        appBar: AppBar(
            backgroundColor: AppColors.primaryLight,
            toolbarHeight: height * 0.18,
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.only(bottomLeft: Radius.circular(70))),
            title: Directionality(
              textDirection: TextDirection.ltr,
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(AppAssets.avatar),
                    radius: 60,
                  ),
                  SizedBox(
                    width: width * 0.04,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(userProvider.currentUser!.name,
                            style: AppStyles.bold24White),
                        Text(
                          userProvider.currentUser!.email,
                          style: AppStyles.medium14White,
                        )
                      ],
                    ),
                  )
                ],
              ),
            )),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.language,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              InkWell(
                onTap: () {
                  showLanguageButtonSheet();
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: height * 0.02),
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.02, vertical: height * 0.01),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.primaryLight,
                        width: 2,
                      )),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        languageProvider.currentLocal == 'en'
                            ? AppLocalizations.of(context)!.english
                            : AppLocalizations.of(context)!.arabic,
                        style: AppStyles.bold20Primary,
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        color: AppColors.primaryLight,
                        size: 30,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Text(
                AppLocalizations.of(context)!.theme,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              InkWell(
                onTap: () {
                  showThemeButtonSheet();
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: height * 0.02),
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.02, vertical: height * 0.01),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.primaryLight,
                        width: 2,
                      )),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        themeProvider.currentTheme == ThemeMode.light
                            ? AppLocalizations.of(context)!.light
                            : AppLocalizations.of(context)!.dark,
                        style: AppStyles.bold20Primary,
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        color: AppColors.primaryLight,
                        size: 30,
                      )
                    ],
                  ),
                ),
              ),
              Spacer(),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.redColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 0.06, vertical: height * 0.017),
                  ),
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.of(context)
                        .pushReplacementNamed(LoginScreen.routeName);
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.logout,
                        color: AppColors.whiteColor,
                        size: 22,
                      ),
                      SizedBox(
                        width: width * 0.02,
                      ),
                      Text(
                        AppLocalizations.of(context)!.logout,
                        style: AppStyles.regular20White,
                      )
                    ],
                  )),
              SizedBox(
                height: height * 0.03,
              )
            ],
          ),
        ));
  }

  void showLanguageButtonSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => LanguageButtonSheet(),
    );
  }

  void showThemeButtonSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => ThemeButtonSheet(),
    );
  }
}
