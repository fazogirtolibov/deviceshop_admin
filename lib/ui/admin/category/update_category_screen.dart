import 'package:deviceshop_admin/data/models/category.dart';
import 'package:deviceshop_admin/utils/color.dart';
import 'package:deviceshop_admin/view_models/categories_view_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class UpdateCategoryScreen extends StatefulWidget {
  const UpdateCategoryScreen({Key? key, required this.categoryModel})
      : super(key: key);

  final CategoryModel categoryModel;

  @override
  State<UpdateCategoryScreen> createState() => _UpdateCategoryScreenState();
}

class _UpdateCategoryScreenState extends State<UpdateCategoryScreen> {
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
          "Update Category",
          style: GoogleFonts.raleway(color: MyColors.appBarText),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          IconButton(
            onPressed: () {
              CategoryModel categoryModel = CategoryModel(
                categoryId: widget.categoryModel.categoryId,
                categoryName: "Muzlat",
                description: widget.categoryModel.description,
                imageUrl: widget.categoryModel.imageUrl,
                createdAt: widget.categoryModel.createdAt,
              );
              Provider.of<CategoriesViewModel>(context, listen: false)
                  .updateCategory(categoryModel);
            },
            icon: const Icon(Icons.edit),
          )
        ],
      ),
    );
  }
}
