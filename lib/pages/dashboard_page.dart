import 'package:ecomerce_admin/auth/firebase_auth_service.dart';
import 'package:ecomerce_admin/pages/login_page.dart';
import 'package:ecomerce_admin/pages/new_product_page.dart';
import 'package:ecomerce_admin/pages/product_list_page.dart';
import 'package:ecomerce_admin/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashBoardPage extends StatefulWidget {
  static const String routeName = '/dashboard';

  @override
  State<DashBoardPage> createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  late ProductProvider _productProvider;
  @override
  void didChangeDependencies() {
    _productProvider = Provider.of<ProductProvider>(context, listen: false);
    _productProvider.getAllCategories();
    _productProvider.getAllProducts();
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard',),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuthService.logoutAdmin().then((_) => Navigator.pushReplacementNamed(context, LoginPage.routeName));
                    },
              icon: const Icon (Icons.logout)
          ),
        ]
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
          children: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.deepPurpleAccent,
                ) ,
              child: const Text('Add Product', style: TextStyle(fontSize: 20, color: Colors.white),),
              onPressed: () => Navigator.pushReplacementNamed(context, NewProductPage.routeName)
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.deepOrange,
                ) ,
                child: const Text('View Product', style: TextStyle(fontSize: 20, color: Colors.white),),
                onPressed: () => Navigator.pushReplacementNamed(context, ProductListPage.routeName)
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.deepOrange,
                ) ,
                child: const Text('Categories', style: TextStyle(fontSize: 20, color: Colors.white),),
                onPressed: () => Navigator.pushReplacementNamed(context, NewProductPage.routeName)
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.deepPurpleAccent,
                ) ,
                child: const Text('Orders', style: TextStyle(fontSize: 20, color: Colors.white),),
                onPressed: () => Navigator.pushReplacementNamed(context, NewProductPage.routeName)
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.teal,
                ) ,
                child: const Text('Customers', style: TextStyle(fontSize: 20, color: Colors.white),),
                onPressed: () => Navigator.pushReplacementNamed(context, NewProductPage.routeName)
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                ) ,
                child: const Text('Purchase History', style: TextStyle(fontSize: 20, color: Colors.white),),
                onPressed: () => Navigator.pushReplacementNamed(context, NewProductPage.routeName)
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                ) ,
                child: const Text('Report', style: TextStyle(fontSize: 20, color: Colors.white),),
                onPressed: () => Navigator.pushReplacementNamed(context, NewProductPage.routeName)
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.teal,
                ) ,
                child: const Text('New Features', style: TextStyle(fontSize: 20, color: Colors.white),),
                onPressed: () => Navigator.pushReplacementNamed(context, NewProductPage.routeName)
            ),
          ],
        ),
      ),
    );
  }
}
