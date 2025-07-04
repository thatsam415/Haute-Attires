import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:haute_attires/api_connection/api_connection.dart';
import 'package:haute_attires/users/item/item_details_screen.dart';
import 'package:haute_attires/users/model/app_colors.dart';
import 'package:haute_attires/users/model/clothes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

class CategoriesFragmentScreen extends StatefulWidget {
  const CategoriesFragmentScreen({super.key});

  @override
  _CategoriesFragmentScreenState createState() => _CategoriesFragmentScreenState();
}

class _CategoriesFragmentScreenState extends State<CategoriesFragmentScreen> {
  List<Clothes> clothesSearchList = [];
  String selectedCategory = ""; // New variable to store the selected category

  Future<void> categoriesItems(String categories) async {
    if (categories.isNotEmpty) {
      try {
        var res = await http.post(Uri.parse(API.categoriesItems), body: {
          "categories": categories, // Use the selected category
        });

        print('Response status: ${res.statusCode}'); // Print the status code
        // print('Response body: ${res.body}'); // Print the raw response body

        if (res.statusCode == 200) {
          var responseBodyOfSearchItems = jsonDecode(res.body);

          if (responseBodyOfSearchItems['success'] == true) {
            setState(() {
              clothesSearchList = (responseBodyOfSearchItems['itemsFoundData'] as List)
                  .map((eachItemData) => Clothes.fromJson(eachItemData))
                  .toList();
            });
          } else {
            // Display error message from response
            Fluttertoast.showToast(msg: "Error: ${responseBodyOfSearchItems['error'] ?? 'Unknown error'}");
          }
        } else {
          Fluttertoast.showToast(msg: "Status Code is not 200");
        }
      } catch (errorMsg) {
        print("Error:: $errorMsg");
      }
    }
  }

    

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('Categories'),
        backgroundColor: AppColors.tropicalTeal,
      ),
      drawer: _buildDrawer(context), // Only the drawer is built
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              color: AppColors.bg, // Expanded area left blank with bg color
            ),
          ),
          Expanded(
            flex: 24,
            child: _buildItemsList(), // Build the items list here
          ),
          Expanded(
            flex: 2,
            child: Container(
              color: AppColors.bg, // Expanded area left blank with bg color
            ),
          ),
        ],
      ),
    );
  }

  // Side menu drawer with additional categories
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: AppColors.coralRed),
            child: Text(
              'Categories',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          _buildCategoryListTile(context, 'Men', "Man"),
          _buildCategoryListTile(context, 'Women', "Women"),
          _buildCategoryListTile(context, 'Kids', "Kids"),
          _buildCategoryListTile(context, 'T-shirt', "T-shirt"),
          _buildCategoryListTile(context, 'Jeans', "Jeans"),
          _buildCategoryListTile(context, 'Saree', "Saree"),
          _buildCategoryListTile(context, 'Shirts', "Shirts"),
          _buildCategoryListTile(context, 'Jackets', "Jackets"),
          _buildCategoryListTile(context, 'Tops', "Tops"),
        ],
      ),
    );
  }

  // Helper method to build category items in the drawer
  Widget _buildCategoryListTile(BuildContext context, String title, String categories) {
    return ListTile(
      title: Text(title),
      onTap: () {
        Navigator.pop(context); // Close the drawer
        setState(() {
          selectedCategory = categories; // Update the selected category
        });
        categoriesItems(selectedCategory); // Fetch items based on the selected category
      },
    );
  }
  
  Widget _buildItemsList() {
  // if (clothesSearchList.isEmpty) {
  //   return const Center(
      
  //   ); // Show a default message
  // }
  if (clothesSearchList.isEmpty) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Center vertically
        crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
        children: [
          // Image from assets
          SizedBox(
            width: MediaQuery.of(context).size.width, // Set the width according to your design
            height: 430, // Set the height according to your design
            child: Image.asset(
              'images/categoryimage.png', // Replace with your image path
              fit: BoxFit.contain, // Maintain aspect ratio
            ),
          ),
          const SizedBox(height: 16), // Spacing between image and text
          const Text(
            'Search Items by your category in the side bar.', // Default message
            style: TextStyle(
              fontSize: 14,
              // fontWeight: FontWeight.bold,
              color: Colors.black, // Adjust color as needed
            ),
          ),
        ],
      ),
    );
  }

  return ListView.builder(
    itemCount: clothesSearchList.length,
    itemBuilder: (context, index) {
      final item = clothesSearchList[index];
      return InkWell(
        onTap: () {
          // Navigate to item details screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ItemDetailsScreen(itemInfo: item),
            ),
          );
        },
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display image on the left
                item.image != null
                    ? Image.asset(
                        'image_upload/${item.image!}',
                        width: 100, // Set desired width
                        height: 150, // Set desired height
                        fit: BoxFit.contain, // Ensure the image covers the container
                      )
                    : const Icon(Icons.image, size: 80), // Placeholder if no image

                const SizedBox(width: 12), // Add space between image and details

                // Display item details on the right
                Expanded( // Use Expanded to fill available space
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name ?? "No name available",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      Text(
                        "Tags: \n${item.tags.toString().replaceAll("[", "").replaceAll("]", "")}",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),

                      Row(
                        children: [
                          Text(
                            "₹ ${item.price!.toStringAsFixed(2)}", // Display original price
                            style: const TextStyle(
                              color: Colors.pink,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "₹ ${item.actualprice!.toStringAsFixed(2)}", // Display actual price
                            style: const TextStyle(
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "${item.offer!}% OFF", // Display discount offer
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Display rating and number of ratings
                      Row(
                        children: [
                          RatingBar.builder(
                            initialRating: item.rating!,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemBuilder: (context, c) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (updateRating) {},
                            ignoreGestures: true,
                            unratedColor: Colors.grey,
                            itemSize: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "(${item.rating})",
                            style: const TextStyle(
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

}
