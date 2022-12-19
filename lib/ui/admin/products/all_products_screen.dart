import 'package:deviceshop_admin/ui/admin/products/add_product_screen.dart';
import 'package:deviceshop_admin/ui/admin/products/update_product_screen.dart';
import 'package:deviceshop_admin/utils/color.dart';
import 'package:deviceshop_admin/view_models/products_view_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({Key? key}) : super(key: key);

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          iconSize: 36,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_circle_left_outlined),
          color: MyColors.appBarText,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "All products",
          style: GoogleFonts.raleway(color: MyColors.appBarText),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddProductScreen()));
              },
              icon: const Icon(
                Icons.add,
                color: MyColors.appBarText,
              ))
        ],
      ),
      body: Consumer<ProductViewModel>(
        builder: (context, productViewModel, child) {
          return ListView(
            children:
                List.generate(productViewModel.productsAdmin.length, (index) {
              var product = productViewModel.productsAdmin[index];
              return ListTile(
                title: Text(product.productName),
                trailing: SizedBox(
                  width: 100,
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateProductScreen(
                                  productModel: product,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.edit)),
                      IconButton(
                          onPressed: () {
                            context
                                .read<ProductViewModel>()
                                .deleteProduct(product.productId);
                            print("DELETING ID:${product.productId}");
                          },
                          icon: const Icon(Icons.delete)),
                    ],
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
