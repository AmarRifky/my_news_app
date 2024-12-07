import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function onSearch;

  CustomSearchBar({required this.controller, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Search for news...',
          suffixIcon: IconButton(
            icon: Icon(Icons.search),
            onPressed: () => onSearch(),
          ),
        ),
      ),
    );
  }
}
