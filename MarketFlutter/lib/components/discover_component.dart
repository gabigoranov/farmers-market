import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:market/views/discover_screen.dart';

class DiscoverComponent extends StatelessWidget {
  final String title;
  final String value;
  final String imgURL;
  final int color;

  const DiscoverComponent({
    super.key,
    required this.title,
    required this.imgURL,
    required this.color,
    required this.value,
  });

  // Method for handling navigation when tapping on the category
  void _onCategoryTap(BuildContext context) {
    Get.to(
      Scaffold(
        appBar: AppBar(
          title: Align(
            alignment: Alignment.centerRight,
            child: Text("Discover $title"),
          ),
          shadowColor: Colors.black87,
          elevation: 0.4,
        ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
          child: SafeArea(
            child: DiscoverBody(category: value),
          ),
        ),
      ),
      transition: Transition.fade,
    );
  }

  // Method for building the category container
  Widget _buildCategoryContainer(BuildContext context) {
    return GestureDetector(
      onTap: () => _onCategoryTap(context),
      child: Container(
        padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.11,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(imgURL), fit: BoxFit.cover),
          color: Color(color).withOpacity(0.85),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 0,
              blurRadius: 15,
              offset: Offset(5, 5),
            ),
          ],
          borderRadius: BorderRadius.circular(20),
        ),
        child: _buildCategoryText(),
      ),
    );
  }

  // Method for building the title text inside the category
  Widget _buildCategoryText() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildCategoryContainer(context);
  }
}
