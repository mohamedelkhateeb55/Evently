import 'package:evently_app/utilis/app_assets.dart';
import 'package:evently_app/utilis/app_colors.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = 'splash';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Column(
        children: [
          Spacer(),
          Center(
            child: Image.asset(
              AppAssets.logo,
              color: AppColors.primaryLight,
              width: 150,
            ),
          ),
          Spacer(),
          Image.asset(AppAssets.evently, color: AppColors.primaryLight),
          SizedBox(
            height: height * 0.03,
          )
        ],
      ),
    );
  }
}
