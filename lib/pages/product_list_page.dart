import 'dart:io';

import 'package:ecomerce_admin/providers/product_provider.dart';
import 'package:ecomerce_admin/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductListPage extends StatefulWidget {
  static const String routeName = '/products';

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  late ProductProvider _productProvider;
  @override
  void didChangeDependencies() {
    _productProvider = Provider.of<ProductProvider>(context);
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Products'),
      ),
      body: _productProvider.productList.isEmpty? const Center(
        child: Text('No item found'),
      ): ListView.builder(
        itemCount: _productProvider.productList.length,
        itemBuilder: (context, index){
          final product = _productProvider.productList[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 5,
              child: ListTile(
                title: Text(product.name!,style: TextStyle(fontSize: 16),),
                textColor:Colors.teal ,
                leading: fadedImageWidget(product.imageDownloadUrl!) ,
                trailing: Chip(
                  label: Text('$takaSymbal${product.price}'),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  Widget fadedImageWidget(String url){
    return FadeInImage.assetNetwork(
        fadeInDuration: const Duration(seconds: 3),
        fadeInCurve: Curves.bounceInOut,
        fit: BoxFit.cover,
        placeholder: 'images/image_placeholder.png',
        image: url);
  }
}
