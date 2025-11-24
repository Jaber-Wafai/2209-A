import 'package:flutter/material.dart';
import 'package:app/models/category.dart';

class CategoryTile extends StatelessWidget {
  final Category category;

  const CategoryTile({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            category.name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
