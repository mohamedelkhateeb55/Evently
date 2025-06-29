import 'package:evently_app/l10n/app_localizations.dart';
import 'package:evently_app/ui/home/tabs/favourite_tab/favourite_tab.dart';
import 'package:evently_app/ui/home/tabs/home_tab/create_event.dart';
import 'package:evently_app/ui/home/tabs/home_tab/home_tab.dart';
import 'package:evently_app/ui/home/tabs/map_tab/map_tab.dart';
import 'package:evently_app/ui/home/tabs/profile/profile_tab.dart';
import 'package:evently_app/utilis/app_assets.dart';
import 'package:evently_app/utilis/app_colors.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const String routName = 'home_screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  List<Widget> tabs = [HomeTab(), MapTab(), FavouriteTab(), ProfileTab()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Theme(
        data:
            Theme.of(context).copyWith(canvasColor: AppColors.transparentColor),
        child: BottomAppBar(
          padding: EdgeInsets.zero,
          color: Theme.of(context).primaryColor,
          shape: CircularNotchedRectangle(),
          notchMargin: 4,
          child: BottomNavigationBar(
              currentIndex: selectedIndex,
              onTap: (index) {
                selectedIndex = index;
                setState(() {});
              },
              items: [
                buildBottomNavigationBarItem(
                    index: 0,
                    selectedIconName: AppAssets.iconSelectedHome,
                    unselectedIconUnName: AppAssets.iconHome,
                    label: AppLocalizations.of(context)!.home),
                buildBottomNavigationBarItem(
                    index: 1,
                    unselectedIconUnName: AppAssets.iconMap,
                    selectedIconName: AppAssets.iconSelectedMap,
                    label: AppLocalizations.of(context)!.map),
                buildBottomNavigationBarItem(
                    index: 2,
                    unselectedIconUnName: AppAssets.iconFav,
                    selectedIconName: AppAssets.iconSelectedFav,
                    label: AppLocalizations.of(context)!.favourite),
                buildBottomNavigationBarItem(
                    index: 3,
                    unselectedIconUnName: AppAssets.iconProfile,
                    selectedIconName: AppAssets.iconSelectedProfile,
                    label: AppLocalizations.of(context)!.profile)
              ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(CreateEvent.routeName);
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: tabs[selectedIndex],
    );
  }

  BottomNavigationBarItem buildBottomNavigationBarItem(
      {required String unselectedIconUnName,
      required String selectedIconName,
      required int index,
      required String label}) {
    return BottomNavigationBarItem(
        icon: ImageIcon(AssetImage(
            selectedIndex == index ? selectedIconName : unselectedIconUnName)),
        label: label);
  }
}
