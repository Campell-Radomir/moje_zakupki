import 'package:flutter/material.dart';
enum Category {
  alcohol('Alkohol', Colors.yellow),
  bread('Pieczywo', Colors.brown),
  candy('Słodycze', Colors.pinkAccent),
  clothing('Ubrania', Colors.orange),
  chemistry('Chemia', Colors.blue),
  dairy('Nabiał', Colors.white),
  electronic('Elektronika', Colors.cyan),
  fish('Ryby', Colors.blueGrey),
  meat('Mięso', Colors.red),
  other('Inne', Colors.white60),
  vegetables('Owoce i Warzywa', Colors.green),
  ;

  const Category(this.displayName, this.color);
  final String displayName;
  final Color color;
}