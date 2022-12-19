import 'package:deviceshop_admin/data/models/category.dart';
import 'package:deviceshop_admin/data/services/file_uploader.dart';
import 'package:deviceshop_admin/utils/color.dart';
import 'package:deviceshop_admin/utils/my_utils.dart';
import 'package:deviceshop_admin/view_models/categories_view_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({Key? key}) : super(key: key);

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final ImagePicker _picker = ImagePicker();
  String imageUrl = "";

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
          "Add Category",
          style: GoogleFonts.raleway(color: MyColors.appBarText),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          IconButton(
            onPressed: () {
              if (imageUrl.isEmpty) {
                MyUtils.getMyToast(message: "Image tanla!!!!");
                return;
              }
              CategoryModel categoryModel = CategoryModel(
                categoryId: "",
                categoryName: "Televizor",
                description: "Yaxshi",
                imageUrl: imageUrl,
                createdAt: DateTime.now().toString(),
              );

              Provider.of<CategoriesViewModel>(context, listen: false)
                  .addCategory(categoryModel);
            },
            icon: const Icon(Icons.add),
          ),
          if (imageUrl.isNotEmpty)
            Image.network(
              imageUrl,
              width: 200,
              height: 120,
            ),
          for (int index = 0; index < 3; index++)
            const ListTile(
              title: Text("sdf"),
            ),
          IconButton(
              onPressed: () {
                _showPicker(context);
              },
              icon: const Icon(Icons.upload))
        ],
      ),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text("Gallery"),
                    onTap: () {
                      _getFromGallery();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    _getFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  _getFromGallery() async {
    XFile? pickedFile = await _picker.pickImage(
      maxWidth: 1000,
      maxHeight: 1000,
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      if (!mounted) return;
      imageUrl = await FileUploader.imageUploader(pickedFile);
      setState(() {});
    }
  }

  _getFromCamera() async {
    XFile? pickedFile = await _picker.pickImage(
      maxWidth: 1920,
      maxHeight: 2000,
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      if (!mounted) return;
      imageUrl = await FileUploader.imageUploader(pickedFile);
      setState(() {});
    }
  }
}
