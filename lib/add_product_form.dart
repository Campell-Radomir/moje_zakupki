import 'package:flutter/material.dart';
import 'package:moje_zakupki/category_enum.dart';
import 'package:moje_zakupki/db/product_dao.dart';
import 'package:moje_zakupki/product.dart';
import 'package:moje_zakupki/shop.dart';

class AddProductFormWidget extends StatefulWidget {
  const AddProductFormWidget({Key? key, required this.shop}) : super(key: key);

  final Shop shop;

  @override
  State<AddProductFormWidget> createState() => AddProductFormWidgetState();
}

class AddProductFormWidgetState<T extends AddProductFormWidget> extends State<T> {
  final formKey = GlobalKey<FormState>();
  final ProductDao productDao = ProductDao();
  String productName = '';
  Category category = Category.other;
  int pieces = 1;

  onPressed() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    formKey.currentState!.save();
    await productDao.save(Product(
        name: productName,
        category: category,
        pieces: pieces,
        shop: widget.shop));
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.shop.name),),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildName(),
              _buildCategory(),
              _buildPieces(),
              ElevatedButton(onPressed: onPressed, child: const Icon(Icons.add)),
            ],
          ),
        ),
      ),
    );
  }

  DropdownButtonFormField<Category> _buildCategory() {
    return DropdownButtonFormField(
      value: category,
      items: Category.values
          .map((category) => DropdownMenuItem(
                value: category,
                child: Text(category.displayName),
              ))
          .toList(),
      onChanged: (value) => category = value!,
    );
  }

  TextFormField _buildName() {
    return TextFormField(
      initialValue: productName.isEmpty ? null : productName,
      decoration: const InputDecoration(labelText: 'Nazwa produktu'),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Pole "Nazwa produktu" jest wymagana';
        }
      },
      onSaved: (newValue) => productName = newValue!,
    );
  }

  TextFormField _buildPieces() {
    return TextFormField(
      initialValue: pieces.toString().isEmpty ? null : pieces.toString(),
      decoration: const InputDecoration(labelText: 'Liczba sztuk'),
      validator: (value) {
        if (value != null && int.tryParse(value) == null) {
          return 'Pole "Liczba sztuk" musi być liczbą całkowitą';
        }
      },
      onSaved: (newValue) => pieces = int.parse(newValue!),
    );
  }
}
