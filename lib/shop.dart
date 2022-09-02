import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Shop {
  Uuid id = Uuid();
  String name;
  int priority;
  Color backgroundColor;
  Color foregroundColor;
  
  
  Shop({required this.name, this.priority = 0,
    this.backgroundColor = Colors.blueAccent, this.foregroundColor = Colors.black});

  static int compare(Shop a, Shop b) {
    if (a.priority == b.priority) {
      return a.name.compareTo(b.name);
    }
    return a.priority > b.priority ? -1 : 1;
  }

  static List<Shop> generateShops() {
    List<Shop> shopList = [
      Shop(name: 'Selgros', priority: 100, backgroundColor: Colors.red, foregroundColor: Colors.white),
      Shop(name: 'Auchan'),
      Shop(name: 'Warus'),
      Shop(name: 'Carrefour'),
      Shop(name: 'Topaz'),
      Shop(name: 'Lidl'),
      Shop(name: 'Żabka', priority: 1, backgroundColor: Colors.green, foregroundColor: Colors.white),
      Shop(name: 'Makro')
    ];
    shopList.sort(
          (a, b) => Shop.compare(a, b),
    );
    return shopList;
  }
}