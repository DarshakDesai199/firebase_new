import 'package:firebase_new/Demo/services/ApiService.dart';
import 'package:get/get.dart';

import 'model.dart';

class ApiController extends GetxController {
  RxBool isLoading = true.obs;

  var shoppingList = <Shopping>[].obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  void getData() async {
    isLoading(true);
    try {
      final data = await ApiService.apiData();
      if (data != null) {
        shoppingList.value = data;
      }
    } finally {
      isLoading(false);
    }
  }
}
