import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:haute_attires/api_connection/api_connection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class UploadItemWidget extends StatefulWidget {
  @override
  _UploadItemWidgetState createState() => _UploadItemWidgetState();
}

class _UploadItemWidgetState extends State<UploadItemWidget> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final ratingController = TextEditingController();
  final tagsController = TextEditingController();
  final priceController = TextEditingController();
  final sizesController = TextEditingController();
  final colorsController = TextEditingController();
  final descriptionController = TextEditingController();
  final offerController = TextEditingController(); // Offer in percent
  // final stockController = TextEditingController(); // Stock available

  final ImagePicker _picker = ImagePicker();
  Uint8List? webImage;
  XFile? pickedImageXFile;
  String? imageName;

  bool _isImageUploaded = false; // Track if the image is uploaded
  Map<String, bool> categories = {
    'Man': false,
    'Women': false,
    'Kids': false,
    'T-shirt': false,
    'Jeans': false,
    'Saree': false,
    'Shirts': false,
    'Jackets': false,
    'Tops': false,
  };

  Future<void> pickImageFromImageUpload(BuildContext context) async {
    try {
      if (kIsWeb) {
        var result = await FilePicker.platform.pickFiles(
          type: FileType.image,
          allowMultiple: false,
        );

        if (result != null && result.files.isNotEmpty) {
          setState(() {
            webImage = result.files.first.bytes;
            imageName = result.files.first.name;
            _isImageUploaded = true; // Image is uploaded, disable button
          });

          Fluttertoast.showToast(msg: "Image selected successfully");
        }
      } else {
        final XFile? image =
            await _picker.pickImage(source: ImageSource.gallery);
        if (image != null) {
          setState(() {
            pickedImageXFile = image;
            imageName = image.name;
            _isImageUploaded = true; // Image is uploaded, disable button
          });

          Fluttertoast.showToast(msg: "Image selected successfully");
        }
      }
    } catch (e) {
      print("Error picking image: $e");
      Fluttertoast.showToast(msg: "Failed to pick image");
    }
  }

  void saveItemInfoToDatabase(BuildContext context) async {
    List<String> tagsList = tagsController.text.split(', ');
    List<String> sizesList = sizesController.text.split(', ');
    List<String> colorsList = colorsController.text.split(', ');

    // Get selected categories
    List<String> selectedCategories = categories.keys
        .where((category) => categories[category] == true)
        .toList();

    try {
      // Convert price and offer to double for calculation
      double price = double.parse(priceController.text.trim());
      double offer = double.parse(offerController.text.trim());

      // Calculate offer price
      double offerPrice = price * (1 - offer / 100);

      var response = await http.post(
        Uri.parse(API.uploadNewItem),
        body: {
          'item_id': '1',
          'name': nameController.text.trim(),
          'rating': ratingController.text.trim(),
          'tags': tagsList.toString().replaceAll(RegExp(r'[\/\\\[\]"]'), ''),
          'actualprice': priceController.text.trim(),
          'sizes': sizesList.toString().replaceAll(RegExp(r'[\/\\\[\]"]'), ''),
          'colors':
              colorsList.toString().replaceAll(RegExp(r'[\/\\\[\]"]'), ''),
          'description': descriptionController.text.trim(),
          'offer': offerController.text.trim(), // Offer percent
          // 'stock': stockController.text.trim(), // Stock available
          'categories': selectedCategories
              .toString()
              .replaceAll(RegExp(r'[\/\\\[\]"]'), ''), // Selected categories
          'image': imageName,
          'price': offerPrice.toStringAsFixed(2),
        },
      );

      if (response.statusCode == 200) {
        var resBodyOfUploadItem = jsonDecode(response.body);
        print(response.body);
        if (resBodyOfUploadItem['success'] == true) {
          Fluttertoast.showToast(msg: "New item uploaded successfully");

          // Clear form fields
          nameController.clear();
          ratingController.clear();
          tagsController.clear();
          priceController.clear();
          sizesController.clear();
          colorsController.clear();
          descriptionController.clear();
          // stockController.clear();
          offerController.clear();
          // Clear selected categories
          categories.updateAll((key, value) => false);
          setState(() {
            webImage = null;
            pickedImageXFile = null;
            _isImageUploaded = false; // Enable upload button again
          });
        } else {
          Fluttertoast.showToast(msg: "Item not uploaded. Try again.");
        }
      }
    } catch (errorMsg) {
      print("Error:: $errorMsg");
      Fluttertoast.showToast(msg: "Error uploading item. Try again.");
    }
  }

  Widget uploadItemFormScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                // Image Preview
                if (kIsWeb && webImage != null)
                  Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: MemoryImage(webImage!),
                        fit: BoxFit.contain,
                      ),
                    ),
                  )
                else if (!kIsWeb && pickedImageXFile != null)
                  Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(File(pickedImageXFile!.path)),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                Material(
                  color: _isImageUploaded ? Colors.grey : Colors.deepPurple,
                  borderRadius: BorderRadius.circular(30),
                  child: InkWell(
                    onTap: _isImageUploaded
                        ? null
                        : () {
                            pickImageFromImageUpload(context);
                          },
                    borderRadius: BorderRadius.circular(30),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 28,
                      ),
                      child: Text(
                        _isImageUploaded ? "Image Picked" : "Pick Image",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      // Input fields
                      textField("Item Name", nameController),
                      textField("Rating", ratingController),
                      textField("Tags (comma-separated)", tagsController),
                      textField("Price", priceController),
                      textField("Sizes (comma-separated)", sizesController),
                      textField("Colors (comma-separated)", colorsController),
                      textField("Description", descriptionController),
                      textField("Offer in Percent", offerController),
                      // textField("Stock Available", stockController),

                      const SizedBox(height: 20),

                      // Category Checkboxes
                      const SizedBox(
                        width: 700,
                        child: Text(
                          "Choose Category: ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 700,
                        child: Wrap(
                          spacing: 10.0,
                          runSpacing: 5.0,
                          children: categories.keys.map((category) {
                            return CheckboxListTile(
                              title: Text(
                                category,
                                style: const TextStyle(color: Colors.white),
                              ),
                              value: categories[category],
                              onChanged: (bool? value) {
                                setState(() {
                                  categories[category] = value!;
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Material(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(30),
                        child: InkWell(
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              Fluttertoast.showToast(msg: "Uploading now...");
                              saveItemInfoToDatabase(context);
                            }
                          },
                          borderRadius: BorderRadius.circular(30),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 28,
                            ),
                            child: Text(
                              "Upload Now",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget textField(String labelText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        width: MediaQuery.of(context).size.width, // Set 80% of screen width
        constraints: const BoxConstraints(
            maxWidth: 800), // Limit the maximum width to 400
        child: TextFormField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: const TextStyle(color: Colors.white54),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white54),
              borderRadius: BorderRadius.circular(30),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.deepPurple),
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "Please enter $labelText";
            }
            return null;
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return uploadItemFormScreen(context);
  }
}
