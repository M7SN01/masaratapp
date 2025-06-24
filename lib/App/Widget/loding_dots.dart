import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TextLodingDotController extends GetxController {
  final RxInt dotCount = 0.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      dotCount.value = (dotCount.value + 1) % 4;
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}

class TextLodingDot extends StatelessWidget {
  final String dot;
  final String text;

  const TextLodingDot({super.key, this.dot = ".", this.text = "جاري احضار البيانات"});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TextLodingDotController());

    return Obx(() {
      final dots = dot * controller.dotCount.value;
      return Text(
        "$text$dots",
        style: const TextStyle(color: Colors.black), // غير اللون حسب الحاجة
      );
    });
  }
}

//Old not work in get dialoag ..
class TextLodingDots extends StatefulWidget {
  final String dot;
  final String text;
  const TextLodingDots({super.key, this.dot = ".", this.text = "جاري احضار البيانات"});

  @override
  State<TextLodingDots> createState() => _TextLodingDotsState();
}

class _TextLodingDotsState extends State<TextLodingDots> {
  int dotCount = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      setState(() {
        dotCount = (dotCount + 1) % 4; // cycles from 0 to 3
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // String dots = '.' * dotCount;
    return Text(
      "${widget.text}${widget.dot * dotCount}",
      style: TextStyle(color: Colors.white),
    );
  }
}
