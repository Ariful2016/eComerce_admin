import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomerce_admin/models/product_model.dart';
import 'package:ecomerce_admin/pages/dashboard_page.dart';
import 'package:ecomerce_admin/utils/helper_function.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';
import '../utils/constant.dart';

class NewProductPage extends StatefulWidget {
  static const String routeName = '/newProduct';

  @override
  State<NewProductPage> createState() => _NewProductPageState();
}

class _NewProductPageState extends State<NewProductPage> {
  final _formKey = GlobalKey<FormState>();
  String? _category;
  late ProductProvider _productProvider;
  DateTime? _dateTime;
  ProductModel _productModel = ProductModel();
  ImageSource _imageSource = ImageSource.camera;
  String? _imagePath;
  bool isSaving = false;
  @override
  void didChangeDependencies() {
    _productProvider = Provider.of<ProductProvider>(context);
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Product'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveProduct,
          )
        ],
      ),
      body: Stack(
        children: [
          if(isSaving) const Center(child: CircularProgressIndicator(),),
          Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(12.0),
              children: [
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text('Add New Product', style: TextStyle(fontSize: 20, color: Colors.green,), ),
                  ),
                ),
                SizedBox(height: 10,),
                Column(
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        //borderRadius: BorderRadius.circular(24.0),
                          border: Border.all(color : Colors.grey, width: 2.0)
                      ),
                      child: _imagePath == null? Image.asset('images/image_placeholder.png') : Image.file(File(_imagePath!), width: 150, height: 150, fit: BoxFit.cover,),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed:(){
                              _imageSource = ImageSource.camera;
                              _pickImage();
                            },
                            child: const Text('Camera')),
                        const SizedBox(width: 20.0,),
                        ElevatedButton(
                            onPressed:(){
                              _imageSource = ImageSource.gallery;
                              _pickImage();
                            },
                            child: const Text('Gallery')),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                TextFormField(
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return 'This field can not be empty';
                    }
                    return null;
                  },
                  onSaved: (value){
                    _productModel.name = value;
                  },
                  decoration: const InputDecoration(
                      labelText: 'Product Name',
                      border: OutlineInputBorder()
                  ),
                ),
                const SizedBox(height: 10,),
                TextFormField(
                  keyboardType: TextInputType.number,
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return 'This field can not be empty';
                    }
                    return null;
                  },
                  onSaved: (value){
                    _productModel.price = num.parse(value!);
                  },
                  decoration: const InputDecoration(
                      labelText: 'Product Price',
                      border: OutlineInputBorder()
                  ),
                ),
                const SizedBox(height: 10,),
                TextFormField(
                  keyboardType: TextInputType.number,
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return 'This field can not be empty';
                    }
                    return null;
                  },
                  onSaved: (value){
                    _productModel.stock = int.parse(value!);
                  },
                  decoration: const InputDecoration(
                      labelText: 'Product Quantity',
                      border: OutlineInputBorder()
                  ),
                ),
                const SizedBox(height: 10,),
                TextFormField(
                  maxLines: 3,
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return 'This field can not be empty';
                    }
                    return null;
                  },
                  onSaved: (value){
                    _productModel.description = value;
                  },
                  decoration: const InputDecoration(
                      labelText: 'Product Description',
                      border: OutlineInputBorder()
                  ),
                ),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonFormField<String>(
                    hint: const Text('Select Category'),
                    // dropdownColor: Colors.teal,
                    value: _category,
                    onChanged: (value){
                      setState(() {
                        _category = value;
                      });
                      _productModel.category = _category;
                    },
                    items: _productProvider.categoryList.map((cat) => DropdownMenuItem(
                        child: Text(cat),
                      value: cat,
                    )).toList(),
                    validator: (value){
                      if(value == null){
                        return 'Please select a category';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 10,),
               Card(
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceAround,
                   children: [
                     ElevatedButton.icon(
                         onPressed: _showDatePicker,
                         icon: const Icon(Icons.date_range),
                         label: const Text('Select date'),
                     ),
                     Text(_dateTime == null? 'No date chosen' : getFormattedDate(_dateTime!, 'dd/MM/yyyy') ),
                   ],
                 ),
               )

              ],
            ),
          ),
        ],
      ),
    );
  }

  void _saveProduct() async{
    final isConnected = await isConnectedToInternet();
    if(isConnected){
      if(_formKey.currentState!.validate()){
        _formKey.currentState!.save();
        if(_dateTime == null){
          showMessage(context, 'Select a date');
        }
        if(_imagePath == null){
          showMessage(context, 'Select an product image');
        }
        isSaving = true;
        _uploadImageToStorage();
        // print(_productModel);

      }
    }else{
       showMessage(context, 'No internet, please check connection!');
    }

  }

  void _showDatePicker() async {
    final dt = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year-1),
        lastDate: DateTime.now()
    );

    if(dt != null){
      setState(() {
        _dateTime = dt;
      });
      _productModel.purchaseDate = Timestamp.fromDate(_dateTime!);
    }
  }

  void _pickImage() async{
    final pickedFile = await ImagePicker().pickImage(source: _imageSource, imageQuality: 60);
    if(pickedFile != null){
      setState(() {
        _imagePath = pickedFile.path ;
      });
      _productModel.localImagePath = _imagePath;
    }
  }

  void _uploadImageToStorage()async{

    final uploadFile= File(_imagePath!);
    final imageName = 'Product_${DateTime.now()}';
    final imageRef = FirebaseStorage.instance.ref().child('$imageDirectory/$imageName');
    try{
      final uploadTask = imageRef.putFile(uploadFile);
      final snapshot = await uploadTask.whenComplete(() {

      });
      final dlUrl = await snapshot.ref.getDownloadURL();
      _productModel.imageDownloadUrl = dlUrl;
      _productModel.imageName = imageName;
      _productProvider.insertNewProduct(_productModel).then((_) => Navigator.pushReplacementNamed(context, DashBoardPage.routeName));
    }catch(e){
      setState(() {
        isSaving = false;
      });
      showMessage(context, 'Failed to upload product image');
      throw e;
    }

  }
}
