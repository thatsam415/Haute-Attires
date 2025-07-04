import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:haute_attires/api_connection/api_connection.dart';
import 'package:haute_attires/users/model/clothes.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class AllItemsWidget extends StatefulWidget {
  const AllItemsWidget({super.key});

  @override
  _AllItemsWidgetState createState() => _AllItemsWidgetState();
}

class _AllItemsWidgetState extends State<AllItemsWidget> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ratingController = TextEditingController();
  final TextEditingController tagsController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController sizesController = TextEditingController();
  final TextEditingController colorsController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final offerController = TextEditingController(); // Offer in percent
  final categoriesController = TextEditingController(); // Stock available

  Clothes? selectedClothes; // To hold the selected item for editing
  bool isEditing = false; // To toggle between view and edit mode
  
  Future<List<Clothes>> getAllClothItems() async {
    List<Clothes> allClothItemsList = [];

    try {
      var res = await http.post(Uri.parse(API.getAllClothes));
      if (res.statusCode == 200) {
        var responseBodyOfAllClothes = jsonDecode(res.body);
        if (responseBodyOfAllClothes["success"] == true) {
          for (var eachRecord
              in (responseBodyOfAllClothes["clothItemsData"] as List)) {
            allClothItemsList.add(Clothes.fromJson(eachRecord));
          }
        }
      } else {
        Fluttertoast.showToast(msg: "Error, status code is not 200");
      }
    } catch (errorMsg) {
      print("Error:: $errorMsg");
    }

    return allClothItemsList;
  }

  Future<void> updateItemInfoToDatabase() async {
    List<String> tagsList = tagsController.text.split(',');
    List<String> sizesList = sizesController.text.split(',');
    List<String> colorsList = colorsController.text.split(',');
    List<String> categoriesList = categoriesController.text.split(',');
    try {
      // Convert price and offer to double for calculation
      double price = double.parse(priceController.text.trim());
      double offer = double.parse(offerController.text.trim());

      // Calculate offer price
      double offerPrice = price * (1 - offer / 100);
      var response = await http.post(
        Uri.parse(API.updateItems),
        body: {
          'item_id':
              selectedClothes!.item_id.toString(), // Ensure item_id is a string
          'name': nameController.text.trim(),
          'rating': ratingController.text.trim(),
          'tags': jsonEncode(tagsList)
              .replaceAll(RegExp(r'[\/\\\[\]"]'), ''), // Pass as a JSON array
          'actualprice': priceController.text.trim(),
          'sizes': jsonEncode(sizesList)
              .replaceAll(RegExp(r'[\/\\\[\]"]'), ''), // Pass as a JSON array
          'colors': jsonEncode(colorsList)
              .replaceAll(RegExp(r'[\/\\\[\]"]'), ''), // Pass as a JSON array
          'description': descriptionController.text.trim(),
          'offer': offerController.text.trim(), // Offer percent
          'categories': jsonEncode(categoriesList)
              .replaceAll(RegExp(r'[\/\\\[\]"]'), ''), // Selected categories
          'price': offerPrice.toStringAsFixed(2),
        },
      );

      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        var resBodyOfUploadItem = jsonDecode(response.body);

        if (resBodyOfUploadItem['success'] == true) {
          Fluttertoast.showToast(msg: "Item updated successfully");
          setState(() {
            isEditing = false;
            selectedClothes = null;
            nameController.clear();
            ratingController.clear();
            tagsController.clear();
            priceController.clear();
            sizesController.clear();
            colorsController.clear();
            descriptionController.clear();
            offerController.clear();
          });
        } else {
          Fluttertoast.showToast(msg: "Item not updated. Error, Try Again.");
        }
      } else {
        Fluttertoast.showToast(msg: "Status is not 200");
      }
    } catch (errorMsg) {
      print("Error:: $errorMsg");
    }
  }

  void enterEditMode(Clothes clothes) {
    setState(() {
      isEditing = true;
      selectedClothes = clothes;

      nameController.text = clothes.name ?? '';
      ratingController.text = clothes.rating?.toString() ?? '';
      tagsController.text = clothes.tags?.join(', ').replaceAll(RegExp(r'[\/\\\[\]"]'), '') ?? '';
      priceController.text = clothes.actualprice?.toString() ?? '';
      sizesController.text = clothes.sizes?.join(', ').replaceAll(RegExp(r'[\/\\\[\]"]'), '') ?? '';
      colorsController.text = clothes.colors?.join(', ').replaceAll(RegExp(r'[\/\\\[\]"]'), '') ?? '';
      descriptionController.text = clothes.description ?? '';
      offerController.text = clothes.offer?.toString() ?? '';
      categoriesController.text = clothes.categories?.join(',').replaceAll(RegExp(r'[\/\\\[\]"]'), '') ?? '';
    });
  }

  deleteItem(int item_id) async {
    try {
      var res = await http.post(Uri.parse(API.deleteItems), body: {
        "item_id": item_id.toString(),
      });

      if (res.statusCode == 200) {
        var responseBodyFromDeleteItem = jsonDecode(res.body);
        if (responseBodyFromDeleteItem["success"] == true) {
          Fluttertoast.showToast(msg: "Deleted item");
          setState(() {
            getAllClothItems();
          });
        }
      } else {
        Fluttertoast.showToast(msg: "Error, Status Code is not 200");
      }
    } catch (errorMessage) {
      print("Error: $errorMessage");

      Fluttertoast.showToast(msg: "Error: $errorMessage");
    }
  }

  deleteItemBox(int item_id) async {
    var resultResponse = await Get.dialog(
      AlertDialog(
        backgroundColor: Colors.grey,
        title: const Text(
          "Delete Item",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          "Are you sure?\nYou want to delete the item?",
        ),
        actions: [
          TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text(
                "No",
                style: TextStyle(
                  color: Colors.black,
                ),
              )),
          TextButton(
              onPressed: () {
                Get.back(result: "delete");
              },
              child: const Text(
                "Yes",
                style: TextStyle(
                  color: Colors.black,
                ),
              )),
        ],
      ),
    );
    if (resultResponse == "delete") {
      deleteItem(item_id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Clothes>>(
      future: getAllClothItems(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text("Error loading items"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No items available"));
        } else {
          if (isEditing && selectedClothes != null) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade900, // Dark background color
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black38, // Darker shadow
                      spreadRadius: 2,
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: selectedClothes!.image != null
                              ? Image.asset(
                                  "image_upload/${selectedClothes!.image!}",
                                  height: 150,
                                  width: 150,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(Icons.image,
                                  size: 100, color: Colors.grey),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            filled: true,
                            fillColor:
                                Colors.grey.shade800, // Darker input field
                            labelStyle: const TextStyle(color: Colors.white70),
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: ratingController,
                          decoration: InputDecoration(
                            labelText: 'Rating',
                            filled: true,
                            fillColor: Colors.grey.shade800,
                            labelStyle: const TextStyle(color: Colors.white70),
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: tagsController,
                          decoration: InputDecoration(
                            labelText: 'Tags (comma-separated)',
                            filled: true,
                            fillColor: Colors.grey.shade800,
                            labelStyle: const TextStyle(color: Colors.white70),
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: priceController,
                          decoration: InputDecoration(
                            labelText: 'Price',
                            filled: true,
                            fillColor: Colors.grey.shade800,
                            labelStyle: const TextStyle(color: Colors.white70),
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: sizesController,
                          decoration: InputDecoration(
                            labelText: 'Sizes (comma-separated)',
                            filled: true,
                            fillColor: Colors.grey.shade800,
                            labelStyle: const TextStyle(color: Colors.white70),
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: colorsController,
                          decoration: InputDecoration(
                            labelText: 'Colors (comma-separated)',
                            filled: true,
                            fillColor: Colors.grey.shade800,
                            labelStyle: const TextStyle(color: Colors.white70),
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: descriptionController,
                          decoration: InputDecoration(
                            labelText: 'Description',
                            filled: true,
                            fillColor: Colors.grey.shade800,
                            labelStyle: const TextStyle(color: Colors.white70),
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: offerController,
                          decoration: InputDecoration(
                            labelText: 'Offer (in %)',
                            filled: true,
                            fillColor: Colors.grey.shade800,
                            labelStyle: const TextStyle(color: Colors.white70),
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: categoriesController,
                          decoration: InputDecoration(
                            labelText:
                                'Categories (comma-separated) [Men, Women, Kids, T-shirt, Jeans, Saree, Shirts, Jackets, Tops]',
                            filled: true,
                            fillColor: Colors.grey.shade800,
                            labelStyle: const TextStyle(color: Colors.white70),
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: updateItemInfoToDatabase,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.blueGrey, // Darker button color
                              ),
                              child: const Text('Update Item'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  isEditing = false;
                                  selectedClothes = null;
                                  nameController.clear();
                                  ratingController.clear();
                                  tagsController.clear();
                                  priceController.clear();
                                  sizesController.clear();
                                  colorsController.clear();
                                  descriptionController.clear();
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.red.shade700, // Darker red
                              ),
                              child: const Text('Cancel'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                Clothes clothes = snapshot.data![index];

                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: clothes.image != null
                              ? Image.asset(
                                  "image_upload/${clothes.image!}",
                                  height: 250,
                                  width: 120,
                                  fit: BoxFit.contain,
                                )
                              : const Icon(Icons.image,
                                  size: 100, color: Colors.grey),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 7,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Item ID: ${clothes.item_id ?? 'N/A'}",
                                style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.blueGrey,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(clothes.name ?? "No name",
                                  style: const TextStyle(
                                      fontSize: 18, color: Colors.white)),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(
                                      "Price: ₹ ${clothes.price?.toStringAsFixed(2) ?? 'N/A'}",
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(width: 8),
                                  Text(
                                      "MRP: ₹ ${clothes.actualprice?.toStringAsFixed(2) ?? 'N/A'}",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.white54,
                                        decoration: TextDecoration.lineThrough,
                                      )),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Tags: ${clothes.tags?.join(',') ?? 'No tags'}"
                                    .replaceAll('[', '')
                                    .replaceAll(']', ''),
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.white70),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Sizes: ${clothes.sizes?.join(',') ?? 'N/A'}"
                                    .replaceAll('[', '')
                                    .replaceAll(']', ''),
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.white70),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Colors: ${clothes.colors?.join(',') ?? 'N/A'}"
                                    .replaceAll('[', '')
                                    .replaceAll(']', ''),
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.white70),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Categories: ${clothes.categories?.join(',') ?? 'No Category'}"
                                    .replaceAll('[', '')
                                    .replaceAll(']', ''),
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.white70),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  const Text(
                                    "Rating: ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  RatingBarIndicator(
                                    rating: clothes.rating?.toDouble() ?? 0.0,
                                    itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    itemCount: 5,
                                    itemSize: 20.0,
                                    direction: Axis.horizontal,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    "(${clothes.rating ?? 'N/A'})",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white70),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  // Update Button (Edit Icon)
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.blue),
                                    onPressed: () {
                                      enterEditMode(clothes);
                                    },
                                  ),
                                  // Delete Button (Delete Icon)
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () {
                                      deleteItemBox(clothes.item_id!);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        }
      },
    );
  }
}
