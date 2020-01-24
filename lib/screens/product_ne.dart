import 'package:flutter/material.dart';

class ProductNEScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  @override
  _ProductNEScreenState createState() => _ProductNEScreenState();
}

class _ProductNEScreenState extends State<ProductNEScreen> {
  final _priceFocusNode = FocusNode();
  final _desFocusNode = FocusNode();

  @override
  void dispose() {
    // TODO: implement dispose
    _priceFocusNode.dispose();
    _desFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit product',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Price',
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_desFocusNode);
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _desFocusNode,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
