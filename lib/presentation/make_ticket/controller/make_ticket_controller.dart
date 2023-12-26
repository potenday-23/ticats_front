import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ticats/app/service/ticats_service.dart';
import 'package:ticats/domain/entities/category.dart';

class MakeTicketController extends GetxController {
  // Make Ticket
  final Rx<XFile?> ticketImage = XFile("").obs;
  final TextEditingController titleController = TextEditingController();
  final Rx<int> titleTextLength = 0.obs;
  final Rx<Category> selectedCategory = TicatsService.to.ticatsCategories[0].obs;
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final Rx<double> selectedRating = 4.5.obs;
  final TextEditingController memoController = TextEditingController();
  final Rx<int> memoTextLength = 0.obs;

  Future<void> getImage() async {
    try {
      final ImagePicker picker = ImagePicker();

      ticketImage.value = await picker.pickImage(source: ImageSource.gallery);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
