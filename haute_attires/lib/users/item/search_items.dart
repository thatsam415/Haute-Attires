import 'dart:convert';
import 'package:haute_attires/api_connection/api_connection.dart';
import 'package:haute_attires/users/model/app_colors.dart';
import 'package:haute_attires/users/model/clothes.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'item_details_screen.dart';

class SearchItems extends StatefulWidget {
  @override
  State<SearchItems> createState() => _SearchItemsState();
}

class _SearchItemsState extends State<SearchItems> {
  TextEditingController searchController = TextEditingController();

  Future<List<Clothes>> readSearchRecordsFound() async {
    List<Clothes> clothesSearchList = [];

    if (searchController.text != "") {
      try {
        var res = await http.post(Uri.parse(API.searchItems), body: {
          "typedKeyWords": searchController.text,
        });

        if (res.statusCode == 200) {
          var responseBodyOfSearchItems = jsonDecode(res.body);

          if (responseBodyOfSearchItems['success'] == true) {
            for (var eachItemData in (responseBodyOfSearchItems['itemsFoundData'] as List)) {
              clothesSearchList.add(Clothes.fromJson(eachItemData));
            }
          }
        } else {
          Fluttertoast.showToast(msg: "Status Code is not 200");
        }
      } catch (errorMsg) {
        Fluttertoast.showToast(msg: "Error:: $errorMsg");
      }
    }

    return clothesSearchList;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.sunsetOrange,
        title: showSearchBarWidget(),
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: searchItemDesignWidget(context),
    );
  }

  Widget showSearchBarWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: TextField(
        style: const TextStyle(color: Colors.pink),
        controller: searchController,
        decoration: InputDecoration(
          prefixIcon: IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: const Icon(
              Icons.search,
              color: Colors.black,
            ),
          ),
          hintText: "Search best clothes here...",
          hintStyle: const TextStyle(
            color: Colors.black87,
            fontSize: 12,
          ),
          suffixIcon: IconButton(
            onPressed: () {
              searchController.clear();
              setState(() {});
            },
            icon: const Icon(
              Icons.close,
              color: Colors.black,
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            borderSide: BorderSide(
              width: 2,
              color: Colors.black,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            borderSide: BorderSide(
              width: 2,
              color: Colors.black,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
        ),
      ),
    );
  }

  searchItemDesignWidget(context) {
    return FutureBuilder(
      future: readSearchRecordsFound(),
      builder: (context, AsyncSnapshot<List<Clothes>> dataSnapShot) {
        if (dataSnapShot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (dataSnapShot.data == null) {
          return const Center(
            child: Text(
              "No item found",
            ),
          );
        }
        if (dataSnapShot.data!.isNotEmpty) {
          return SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Use MediaQuery to determine screen width
                Container(
                  width: MediaQuery.of(context).size.width * 0.9, // 90% of screen width
                  child: ListView.builder(
                    itemCount: dataSnapShot.data!.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      Clothes eachClothItemRecord = dataSnapShot.data![index];

                      return GestureDetector(
                        onTap: () {
                          Get.to(ItemDetailsScreen(itemInfo: eachClothItemRecord));
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
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              eachClothItemRecord.name!,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 12, right: 12),
                                            child: Text(
                                              "₹ ${eachClothItemRecord.price}",
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                color: Colors.pink,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      //actualprice
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5, right: 8),
                                          child: Text(
                                            "MRP: ₹ ${eachClothItemRecord.actualprice}",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                              decoration: TextDecoration.lineThrough,
                                            ),
                                          ),
                                        ),
                                      const SizedBox(height: 16),
                                      Text(
                                        "Tags: \n${eachClothItemRecord.tags.toString().replaceAll("[", "").replaceAll("]", "")}",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                                child: Image.asset(
                                  'image_upload/${eachClothItemRecord.image}',
                                  height: 130,
                                  width: 130,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTraceError) {
                                    return const Center(
                                      child: Icon(Icons.broken_image_outlined),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Center(
            child: Text("Empty, No Data."),
          );
        }
      },
    );
  }
}
