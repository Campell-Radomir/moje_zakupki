import 'package:flutter/material.dart';
import 'package:moje_zakupki/category_enum.dart';
import 'package:moje_zakupki/db/product_dao.dart';
import 'package:moje_zakupki/product.dart';
import 'package:moje_zakupki/shop.dart';

class AddProductForm extends StatefulWidget {
  const AddProductForm({Key? key, required this.shop}) : super(key: key);

  final Shop shop;

  @override
  State<AddProductForm> createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  final _formKey = GlobalKey<FormState>();
  final ProductDao productDao = ProductDao();
  String _productName = '';
  Category _category = Category.other;
  int _pieces = 1;

  _onPressed() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();
    await productDao.save(Product(
        name: _productName,
        category: _category,
        pieces: _pieces,
        shop: widget.shop));
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.shop.name),),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildName(),
              _buildCategory(),
              _buildPieces(),
              ElevatedButton(onPressed: _onPressed, child: const Icon(Icons.add)),
            ],
          ),
        ),
      ),
    );
  }

  DropdownButtonFormField<Category> _buildCategory() {
    return DropdownButtonFormField(
      // value: _category,
      items: Category.values
          .map((category) => DropdownMenuItem(
                value: category,
                child: Text(category.displayName),
              ))
          .toList(),
      onChanged: (value) => _category = value!,
    );
  }

  TextFormField _buildName() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Nazwa produktu'),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Pole "Nazwa produktu" jest wymagana';
        }
      },
      onSaved: (newValue) => _productName = newValue!,
    );
  }

  TextFormField _buildPieces() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Liczba sztuk'),
      validator: (value) {
        if (value != null && int.tryParse(value) == null) {
          return 'Pole "Liczba sztuk" musi być liczbą całkowitą';
        }
      },
      onSaved: (newValue) => _pieces = int.parse(newValue!),
    );
  }
}
