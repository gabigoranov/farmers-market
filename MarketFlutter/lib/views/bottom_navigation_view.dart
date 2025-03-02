import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:market/services/user_service.dart';
import 'package:market/views/discover_screen.dart';
import 'package:market/views/history_screen.dart';
import 'package:market/views/home_screen.dart';
import 'package:market/views/profile_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:market/views/shopping_list_screen.dart';

const storage = FlutterSecureStorage();

class Navigation extends StatefulWidget {
  final int index;
  final String? text;
  final String? category;
  const Navigation({super.key, required this.index, this.text, this.category});
  @override
  State<Navigation> createState() => _NavigationState(index, text, category);
}

class _NavigationState extends State<Navigation> {
  int _currentIndex = 1;
  String? text;
  String? category;
  late PageController _pageController = PageController(initialPage: _currentIndex);
  _NavigationState(int index, String? input, String? selectedCategory){
    _currentIndex = index;
    _pageController = PageController(initialPage: _currentIndex);
    text = input;
    category = selectedCategory;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      floatingActionButton: _currentIndex != 3 ? FloatingActionButton(
        onPressed: () {
          Get.to(() => const ShoppingListView(), transition: Transition.circularReveal,);
        },
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: const Icon(Icons.shopping_basket_outlined),
      ) : null,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: SafeArea(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
                text = text;
              });
            },
            children: [
              const Home(),
              Discover(text: text, category: category,),
              const History(),
              Profile(userData: UserService.instance.user),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: const Color(0xFFFFFFFF),
          type: BottomNavigationBarType.fixed,
          selectedIconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary, size: 34),
          selectedLabelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
          selectedItemColor: Colors.black,
          currentIndex: _currentIndex,
          onTap: (index) {
            // Handle navigation bar item tap
            setState(() {
              _currentIndex = index;
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home,),
              label: AppLocalizations.of(context)!.home,
            ),
            BottomNavigationBarItem(
              icon: const Icon(CupertinoIcons.compass, ),
              label: AppLocalizations.of(context)!.discover,

            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.history, ),
              label: AppLocalizations.of(context)!.history,

            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person, ),
              label: AppLocalizations.of(context)!.profile,

            ),
          ],
        ),
      ),
    );
  }
}
