import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ticats/app/service/ticats_service.dart';
import 'package:ticats/domain/entities/category.dart';
import 'package:ticats/domain/entities/ticket.dart';
import 'package:ticats/domain/usecases/ticket_use_cases.dart';
import 'package:ticats/presentation/common/enum/color_type.dart';
import 'package:ticats/presentation/common/enum/ticket_enum.dart';
import 'package:ticats/presentation/common/pages/crop_image_page.dart';

class MakeTicketController extends GetxController {
  final Rx<Ticket> ticket = Ticket(
    title: "",
    ticketDate: DateTime.now(),
    rating: 4.5,
    memo: "",
    ticketType: TicketType.type0,
    layoutType: TicketLayoutType.layout0,
  ).obs;

  RxBool isUploading = false.obs;

  // Ticket Information
  final Rx<XFile?> ticketImage = XFile("").obs;
  final TextEditingController titleController = TextEditingController();
  final Rx<int> titleTextLength = 0.obs;
  final Rx<Category> selectedCategory = TicatsService.to.ticatsCategories[0].obs;
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final Rx<double> selectedRating = 4.5.obs;
  final TextEditingController memoController = TextEditingController();
  final Rx<int> memoTextLength = 0.obs;
  final RxInt selectedColor = 1.obs;
  final RxBool isPrivate = false.obs;

  bool get isEnable => ticketImage.value!.path.isNotEmpty && titleTextLength.value != 0;

  Future<void> getImage() async {
    try {
      final ImagePicker picker = ImagePicker();

      XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        Uint8List? compressedImage = await FlutterImageCompress.compressWithFile(image.path, quality: 75);

        var imagePath = Get.to(() => CropImagePage(image: compressedImage!));

        if (imagePath != null) {
          ticketImage.value = XFile(await imagePath);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  // Ticket Layout
  final Rx<int> selectedLayoutTabIndex = 0.obs;

  final Rx<int> selectedTicketTypeIndex = 0.obs;
  final Rx<int> selectedTicketLayoutIndex = 0.obs;
  final Rx<int> selectedTicketTextColorIndex = 0.obs;

  // Make Ticket
  void makeTicket() {
    ticket.value = Ticket(
      imagePath: ticketImage.value!.path,
      title: titleController.text,
      category: selectedCategory.value,
      ticketDate: selectedDate.value,
      rating: selectedRating.value,
      memo: memoController.text,
      ticketType: TicketType.values[selectedTicketTypeIndex.value],
      layoutType: TicketLayoutType.values[selectedTicketLayoutIndex.value],
      color: ColorType.values[selectedColor.value].id.toString(),
      isPrivate: isPrivate.value ? "PRIVATE" : "PUBLIC",
    );
  }

  Future<void> postTicket() async {
    makeTicket();
    await Get.find<TicketUseCases>().postTicketUseCase.execute(ticket.value);
  }
}
