import 'package:deviceshop_admin/data/models/category.dart';
import 'package:deviceshop_admin/data/models/product_model.dart';
import 'package:deviceshop_admin/utils/color.dart';
import 'package:deviceshop_admin/utils/my_utils.dart';
import 'package:deviceshop_admin/view_models/categories_view_model.dart';
import 'package:deviceshop_admin/view_models/products_view_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController countController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  List<String> productImages = [
    "https://www.pngitem.com/pimgs/m/183-1831803_laptop-collection-png-transparent-png.png",
    "https://www.pngitem.com/pimgs/m/183-1831803_laptop-collection-png-transparent-png.png",
  ];
  String categoryId = "";
  CategoryModel? categoryModel;
  String createdAt = DateTime.now().toString();
  List<String> currencies = ["USD", "SO'M", "RUBL", "TENGE"];
  String selectedCurrency = "USD";

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
        title: Text(
          "Add Product Screen",
          style: GoogleFonts.raleway(color: MyColors.appBarText),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: countController,
                keyboardType: TextInputType.number,
                decoration: getInputDecoration(label: "Count"),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: getInputDecoration(label: "Price"),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                keyboardType: TextInputType.text,
                decoration: getInputDecoration(label: "Product Name"),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 200,
                child: TextField(
                  controller: descriptionController,
                  keyboardType: TextInputType.text,
                  maxLines: 20,
                  decoration: getInputDecoration(label: "Description"),
                ),
              ),
              const SizedBox(height: 20),
              ExpansionTile(
                title: Text(selectedCurrency.isEmpty
                    ? "Select  Currncy"
                    : selectedCurrency),
                children: [
                  ...List.generate(
                      currencies.length,
                      (index) => ListTile(
                            title: Text(currencies[index]),
                            onTap: () {
                              setState(() {
                                selectedCurrency = currencies[index];
                              });
                            },
                          ))
                ],
              ),
              TextButton(
                onPressed: () {
                  selectCategory((selectedCategory) {
                    categoryModel = selectedCategory;
                    categoryId = categoryModel!.categoryId;
                    setState(() {});
                  });
                },
                child: Text(
                  categoryModel == null
                      ? "Select Category"
                      : categoryModel!.categoryName,
                ),
              ),
              TextButton(
                onPressed: () {
                  ProductModel productModel = ProductModel(
                    count: int.parse(countController.text),
                    price: int.parse(priceController.text),
                    productImages: productImages,
                    categoryId: categoryId,
                    productId: "",
                    productName: nameController.text,
                    description: descriptionController.text,
                    createdAt: createdAt,
                    currency: selectedCurrency,
                  );

                  Provider.of<ProductViewModel>(context, listen: false)
                      .addProduct(productModel);
                },
                child: const Text("Add Product to Fire Store"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  selectCategory(ValueChanged<CategoryModel> onCategorySelect) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.6,
              width: double.infinity,
              child: StreamBuilder<List<CategoryModel>>(
                stream: Provider.of<CategoriesViewModel>(context, listen: false)
                    .listenCategories(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasData) {
                    List<CategoryModel> categories = snapshot.data!;
                    return ListView(
                      children: List.generate(
                        categories.length,
                        (index) => ListTile(
                          title: Text(categories[index].categoryName),
                          onTap: () {
                            onCategorySelect.call(categories[index]);
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    );
                  } else {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  }
                },
              ),
            ),
          );
        });
  }
}
