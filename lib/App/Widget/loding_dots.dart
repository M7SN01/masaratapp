import 'dart:async';

import 'package:flutter/material.dart';

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
