import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          child: ElevatedButton(
            child: Text("کلیک بنمای"),
            onPressed: () => Get.toNamed('/subjects'),
          ),
        ),
      );
}
