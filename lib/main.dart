// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterwoocommerce/config.dart';
import 'package:flutterwoocommerce/model/product.dart';

import 'package:http/http.dart' as http;
import 'config.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProductPage(),
    );
  }
}

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

List<Product> productList = [];

class _ProductPageState extends State<ProductPage> {
  @override
  void initState() {
    getProduct();
    super.initState();
  }

  Future<void> getProduct() async {
    // setState(() {
    //   // isloading = true;
    // });
    final String url =
        "https://primomoto.es/wp-json/wc/v3/products?consumer_key=ck_008c1ec07fdc83108e72eb7df00d458303eee62a&consumer_secret=cs_237f64b7958def9bc401229553d93c8628531255";
    List<Product> productData = [];
    // try {
    http.Response response = await http.get(Uri.parse(url));
    print(json.decode(response.body));
    productData = List<Product>.from(
        json.decode(response.body).map((data) => Product.fromJson(data)));

    print("ip " + productData[0].name);
    setState(() {
      productList = productData;
    });
    // } catch (e) {
    //   print(e);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        scrollDirection: Axis.vertical,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 4.0, mainAxisSpacing: 4.0),
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: InkWell(
            onTap: () {
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => DetailsScreen(
              //               product: productList[index],
              //             )));
            },
            child: Container(
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(3),
                      width: 100,
                      height: 100,
                      // ignore: prefer_const_constructors
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white),
                      child: Hero(
                        tag: 'img',
                        child: Image.network(
                          productList[index].image,
                          fit: BoxFit.contain,
                          scale: 7,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(2)),
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: Column(
                        children: [
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.only(
                              left: 15.0,
                            ),
                            child: Text(
                              productList[index].name,
                              style: TextStyle(fontSize: 16),
                              overflow: TextOverflow.ellipsis,
                            ),
                          )),
                          Text(
                            "RS:" + productList[index].price.toString(),
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        itemCount: productList.length,
      ),
    );
  }
}
