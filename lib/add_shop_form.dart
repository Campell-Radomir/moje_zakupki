import 'package:flutter/material.dart';
import 'package:moje_zakupki/db/shop_dao.dart';
import 'package:moje_zakupki/shop.dart';

class AddShopForm extends StatefulWidget {
  const AddShopForm({Key? key}) : super(key: key);

  @override
  State<AddShopForm> createState() => _AddShopFormState();
}

class _AddShopFormState extends State<AddShopForm> {
  final _formKey = GlobalKey<FormState>();
  final ShopDao shopDao = ShopDao();
  var _shopName = '';
  var _priority = 0;

  _onPressed() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();
    await shopDao.save(Shop(name: _shopName, priority: _priority));
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dodaj sklep"),),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildShopName(),
              _buildPriority(),
              ElevatedButton(onPressed: _onPressed, child: const Icon(Icons.add)),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField _buildPriority() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Priorytet'),
      validator: (value) {
        if (value != null && int.tryParse(value) == null) {
          return 'Pole "Priorytet" musi być liczbą całkowitą';
        }
      },
      onSaved: (newValue) => _priority = int.parse(newValue!),
    );
  }

  TextFormField _buildShopName() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Nazwa sklepu'),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Pole "Nazwa sklepu" jest wymagana';
        }
      },
      onSaved: (newValue) => _shopName = newValue!,
    );
  }
}
