import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haute_attires/users/model/app_colors.dart';
import 'package:haute_attires/users/cart/cart_list_screen.dart';
import 'package:haute_attires/users/fragments/categories_fragment_screen.dart';
import 'package:haute_attires/users/fragments/favorites_fragment_screen.dart';
import 'package:haute_attires/users/fragments/home_fragment_screen.dart';
import 'package:haute_attires/users/fragments/order_fragment_screen.dart';
import 'package:haute_attires/users/fragments/profile_fragment_screen.dart';
import 'package:haute_attires/users/item/search_items.dart';
import 'package:haute_attires/users/userPreferences/current_user.dart';

// ignore: must_be_immutable
class DashboardOfFragments extends StatelessWidget {
  final CurrentUser _rememberCurrentUser = Get.put(CurrentUser());
  TextEditingController searchController = TextEditingController();

  final List<Widget> _fragmentScreens = [
    HomeFragmentScreen(),
    const CategoriesFragmentScreen(),
    FavoritesFragmentScreen(),
    OrderFragmentScreen(),
    ProfileFragmentScreen(),
    
  ];


  final List<String> _navigationButtonLabels = [
    "Home",
    "Categories",
    "Favourites",
    "Orders",
    "Profile",
  ];

  final RxInt _indexNumber = 0.obs;

  DashboardOfFragments({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: CurrentUser(),
      initState: (currentState) {
        _rememberCurrentUser.getUserInfo();
      },
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColors.deepSeaBlue,
          body: SafeArea(
            child: Column(
              children: [
                // Haute Attire Banner Image and search bar in the same row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Image widget
                      Container(
                        height: 120,
                        width: 200,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('images/main_logo.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),

                      const Spacer(),
                      // Search bar widget (Expanded to take up available space)
                      Material(
                        color: Colors
                            .transparent, // Ensure the background remains transparent
                        child: InkWell(
                          onTap: () {
                            Get.to(SearchItems());
                          },
                          child: const IntrinsicWidth(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                    width: 8), // Space between icon and text
                                Text(
                                  'Search',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16, // Adjust font size as needed
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 20,),
                      // Cart button
                      Material(
                        color: Colors
                            .transparent, // Ensure the background remains transparent
                        child: InkWell(
                          onTap: () {
                            Get.to(const CartListScreen());
                          },
                          child: const IntrinsicWidth(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.shopping_cart,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                    width: 8), // Space between icon and text
                                Text(
                                  'My Cart',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16, // Adjust font size as needed
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Black strip with text navigation buttons
                Obx(
                  () => Container(
                    color: AppColors.goldenSand,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(_navigationButtonLabels.length,
                          (index) {
                        return GestureDetector(
                          onTap: () {
                            _indexNumber.value = index;
                          },
                          child: Text(
                            _navigationButtonLabels[index],
                            style: TextStyle(
                              // Change text color based on active/inactive state
                              color: _indexNumber.value == index
                                  ? Colors.pink
                                  : Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),

                // Fragment Content
                Expanded(
                  child: Obx(
                    () => _fragmentScreens[_indexNumber
                        .value], // Correctly display the selected fragment
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
