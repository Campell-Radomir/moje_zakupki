import 'package:flutter/material.dart';
import 'package:moje_zakupki/product.dart';
import 'package:moje_zakupki/shop.dart';

import 'add_product_form.dart';

class EditProductFormWidget extends AddProductFormWidget {
  const EditProductFormWidget({Key? key, required this.editProduct, required Shop shop}) : super(key: key, shop: shop);

  final Product editProduct;

  @override
  AddProductFormWidgetState<EditProductFormWidget> createState() => _EditProductFormWidgetState();
}

class _EditProductFormWidgetState extends AddProductFormWidgetState<EditProductFormWidget> {


  @override
  void initState() {
    super.initState();
     productName = widget.editProduct.name;
     category = widget.editProduct.category;
     pieces = widget.editProduct.pieces;
  }

  @override
  onPressed() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    formKey.currentState!.save();
    final Product product = widget.editProduct;
    product.name = productName;
    product.category = category;
    product.pieces = pieces;
    await productDao.save(product);
    if (!mounted) return;
    Navigator.pop(context);
  }
}
