import 'package:flutter/material.dart';

class CategoryModel {
  String name;
  String iconPath;
  Color boxColor;
  String description;

  CategoryModel(
      {required this.name,
      required this.iconPath,
      required this.boxColor,
      required this.description});

// a method that return list of items
  static List<CategoryModel> getCategories() {
    List<CategoryModel> categories = [];

    categories.add(CategoryModel(
        name: 'salad',
        iconPath: 'assets/icons/plate.svg',
        boxColor: Color(0xff92A3FD),
        description: "salad "));

    categories.add(CategoryModel(
        name: 'Cake',
        iconPath: 'assets/icons/pancakes.svg',
        boxColor: Color(0xffc588f2),
        description: 'cake'));

    categories.add(CategoryModel(
        name: 'Pie',
        iconPath: 'assets/icons/pie.svg',
        boxColor: Color(0xff92A3FD),
        description: 'pie'));

    categories.add(CategoryModel(
        name: 'Smoothies',
        iconPath: 'assets/icons/orange-snacks.svg',
        boxColor: Color(0xffc588f2),
        description: 'smoothies'));

    return categories;
  }
}
