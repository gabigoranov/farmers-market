import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:market/services/user_service.dart';
import 'package:market/views/discover.dart';
import 'package:market/views/history.dart';
import 'package:market/views/home.dart';
import 'package:market/views/profile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      bottomNavigationBar: BottomNavigationBar(
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
    );
  }
}
