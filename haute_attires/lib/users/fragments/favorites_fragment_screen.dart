import 'dart:convert';

import 'package:haute_attires/users/model/app_colors.dart';
import 'package:haute_attires/users/fragments/footer_widget.dart';
import 'package:haute_attires/users/item/item_details_screen.dart';
import 'package:haute_attires/users/model/clothes.dart';
import 'package:haute_attires/users/model/favorite.dart';
import 'package:haute_attires/users/userPreferences/current_user.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../api_connection/api_connection.dart';

class FavoritesFragmentScreen extends StatefulWidget {
  FavoritesFragmentScreen({super.key});

  @override
  State<FavoritesFragmentScreen> createState() =>
      _FavoritesFragmentScreenState();
}

class _FavoritesFragmentScreenState extends State<FavoritesFragmentScreen> {
  final currentOnlineUser = Get.put(CurrentUser());

  Future<List<Favorite>> getCurrentUserFavoriteList() async {
    List<Favorite> favoriteListOfCurrentUser = [];

    try {
      var res = await http.post(Uri.parse(API.readFavorite), body: {
        "user_id": currentOnlineUser.user.user_id.toString(),
      });

      if (res.statusCode == 200) {
        var responseBodyOfCurrentUserFavoriteListItems = jsonDecode(res.body);

        if (responseBodyOfCurrentUserFavoriteListItems['success'] == true) {
          for (var eachCurrentUserFavoriteItemData
              in (responseBodyOfCurrentUserFavoriteListItems[
                  'currentUserFavoriteData'] as List)) {
            favoriteListOfCurrentUser
                .add(Favorite.fromJson(eachCurrentUserFavoriteItemData));
          }
        }
      } else {
        Fluttertoast.showToast(msg: "Status Code is not 200");
      }
    } catch (errorMsg) {
      print("Error:: $errorMsg");
      Fluttertoast.showToast(msg: "Error:: $errorMsg");
    }

    return favoriteListOfCurrentUser;
  }

  
  
@override
  void initState() {
    super.initState();
    getCurrentUserFavoriteList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 245, 210, 190),
                  borderRadius:
                      BorderRadius.circular(20), // Set circular border
                ),
                width: MediaQuery.of(context).size.width,
                child: const Center(
                  child: Text(
                    "My Favorite List",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            //displaying favoriteList
            favoriteListItemDesignWidget(context),
            const SizedBox(height: 350),
            const FooterWidget(),
          ],
        ),
      ),
    );
  }

  favoriteListItemDesignWidget(context) {
    return Center(
      child: SizedBox(
        width: 700,
        child: FutureBuilder(
            future: getCurrentUserFavoriteList(),
            builder: (context, AsyncSnapshot<List<Favorite>> dataSnapShot) {
              if (dataSnapShot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (dataSnapShot.data == null) {
                return const Center(
                  child: Text(
                    "No favorite item found",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                );
              }
              if (dataSnapShot.data!.isNotEmpty) {
                return ListView.builder(
                  itemCount: dataSnapShot.data!.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    Favorite eachFavoriteItemRecord = dataSnapShot.data![index];
                    Clothes clickedClothItem = Clothes(
                      item_id: eachFavoriteItemRecord.item_id,
                      name: eachFavoriteItemRecord.name,
                      rating: eachFavoriteItemRecord.rating,
                      tags: eachFavoriteItemRecord.tags,
                      price: eachFavoriteItemRecord.price,
                      sizes: eachFavoriteItemRecord.sizes,
                      colors: eachFavoriteItemRecord.colors,
                      description: eachFavoriteItemRecord.description,
                      image: eachFavoriteItemRecord.image,
                      // stock: eachFavoriteItemRecord.stock,
                      actualprice: eachFavoriteItemRecord.actualprice,
                      offer: eachFavoriteItemRecord.offer,
                      categories: eachFavoriteItemRecord.categories,
                    );

                    return GestureDetector(
                      onTap: () {
                        Get.to(() => ItemDetailsScreen(
                            itemInfo: clickedClothItem));
                      },
                      child: Container(
                        margin: EdgeInsets.fromLTRB(
                          16,
                          index == 0 ? 16 : 8,
                          16,
                          index == dataSnapShot.data!.length - 1 ? 16 : 8,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                              offset: Offset(0, 0),
                              blurRadius: 6,
                              color: Colors.black,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            //name + price
                            //tags
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //name and price
                                    Row(
                                      children: [
                                        //name
                                        Expanded(
                                          child: Text(
                                            eachFavoriteItemRecord.name!,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),

                                        //price
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 12, right: 12),
                                          child: Text(
                                            "₹ ${eachFavoriteItemRecord.price}",
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.pink,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),

                                        //actualprice
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5, right: 8),
                                          child: Text(
                                            "₹ ${eachFavoriteItemRecord.actualprice}",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                              decoration:
                                                  TextDecoration.lineThrough,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),

                                    //tags
                                    Text(
                                      "Tags: \n${eachFavoriteItemRecord.tags.toString().replaceAll("[", "").replaceAll("]", "")}",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            //image clothes
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                              child: Image.asset(
                                'image_upload/${eachFavoriteItemRecord.image}', // Asset image path
                                height: 130,
                                width: 130,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTraceError) {
                                  return const Center(
                                    child: Icon(
                                      Icons.broken_image_outlined,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else {
                return const SingleChildScrollView(
                  child: SizedBox(
                      width: 1200,
                      height: 500,
                      child: Center(
                        child: Text("Empty, No Data."),
                      )),
                );
              }
            }),
      ),
    );
  }
}
