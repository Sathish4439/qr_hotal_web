import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:ui';


class SearchField extends StatelessWidget {
  const SearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3), // Transparent white
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.5),
              width: 1.2,
            ),
          ),
          child: Center(
            child: TextField(
              onChanged: (value) => log(value),
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white, // White text for contrast
              ),
              decoration: const InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                hintText: "Search Dishes",
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.white70,
                ),
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
