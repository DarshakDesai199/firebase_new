import 'package:firebase_new/Demo/services/controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class ShoppingHome extends StatelessWidget {
  ApiController apiController = Get.put(ApiController());
  @override
  Widget build(BuildContext context) {
    var height = Get.height;
    var width = Get.width;
    return Scaffold(
      body: Obx(() {
        if (apiController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else {
          return MasonryGridView.count(
            itemCount: apiController.shoppingList.length,
            crossAxisCount: 2,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            itemBuilder: (context, index) {
              final shoppingItems = apiController.shoppingList[index];
              return Card(
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(children: [
                    Image.network("${shoppingItems.image}"),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Text(
                      "${shoppingItems.title}",
                      style: TextStyle(fontSize: 18),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "Rs. ${shoppingItems.price}",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Text(
                      "${shoppingItems.description}",
                      style: TextStyle(fontSize: 14),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    )
                  ]),
                ),
              );
            },
          );
        }
      }),
    );
  }
}
