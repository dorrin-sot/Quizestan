import 'dart:async';

import 'package:cron/cron.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:get/get.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:mobdev_game_project/misc/custom_icons_icons.dart';
import 'package:mobdev_game_project/models/user.dart';

import '../../main.dart';

class CustomAppbar extends AppBar {
  static AppBar build() {
    final c = Get.find<AppController>();
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 62.5,
      title: SafeArea(
        child: Obx(
          () => c.isLoggedIn.isFalse ? Container() : signedIn(),
        ),
      ),
    );
  }

  static Widget signedIn() => Padding(
        padding: const EdgeInsets.only(bottom: 22.5),
        child: Row(
          children: [
            HeartIndicator(),
            Spacer(),
            MoneyIndicator(),
            Spacer(),
            PointsIndicator()
          ],
        ),
      );
}

class HeartIndicator extends StatelessWidget {
  const HeartIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(HeartController());

    return Column(
      children: [
        Center(
          child: GetBuilder<HeartController>(
            builder: (c) => LiquidCustomProgressIndicator(
              value: c.currentUser.timeDoneFraction,
              valueColor: AlwaysStoppedAnimation(Colors.red.shade500),
              backgroundColor: Colors.lightBlueAccent.shade100,
              direction: Axis.vertical,
              shapePath: getHeartPath(Size.square(40)),
            ),
          ),
        ),
        SizedBox(
          height: 2.5,
        ),
        Center(
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: GetBuilder<HeartController>(
              builder: (c) => Padding(
                padding: const EdgeInsets.only(left: 2.5),
                child: Text(
                  c.currentUser.hearts.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  static Path getHeartPath(Size size) {
    final path = Path();
    path.lineTo(size.width / 2, size.height * 0.89);
    path.cubicTo(size.width / 2, size.height * 0.89, size.width * 0.44,
        size.height * 0.83, size.width * 0.44, size.height * 0.83);
    path.cubicTo(size.width * 0.23, size.height * 0.64, size.width * 0.08,
        size.height * 0.51, size.width * 0.08, size.height * 0.35);
    path.cubicTo(size.width * 0.08, size.height * 0.23, size.width * 0.18,
        size.height * 0.13, size.width * 0.31, size.height * 0.13);
    path.cubicTo(size.width * 0.39, size.height * 0.13, size.width * 0.45,
        size.height * 0.16, size.width / 2, size.height / 5);
    path.cubicTo(size.width * 0.55, size.height * 0.16, size.width * 0.62,
        size.height * 0.13, size.width * 0.69, size.height * 0.13);
    path.cubicTo(size.width * 0.82, size.height * 0.13, size.width * 0.92,
        size.height * 0.23, size.width * 0.92, size.height * 0.35);
    path.cubicTo(size.width * 0.92, size.height * 0.51, size.width * 0.78,
        size.height * 0.64, size.width * 0.56, size.height * 0.84);
    path.cubicTo(size.width * 0.56, size.height * 0.84, size.width / 2,
        size.height * 0.89, size.width / 2, size.height * 0.89);
    path.cubicTo(size.width / 2, size.height * 0.89, size.width / 2,
        size.height * 0.89, size.width / 2, size.height * 0.89);
    return path;
  }
}

class HeartController extends GetxController {
  User currentUser = Get.find<AppController>().currentUser!;

  @override
  Future<void> onInit() async {
    super.onInit();

    await currentUser.updateHearts().then((value) => scheduleUpdateHeart());
  }

  void scheduleUpdateHeart() {
    Cron().schedule(Schedule.parse("*/10 * * * * *"), () => update());
    Future.delayed(
        DateTime.now().difference(currentUser.heartsLastUpdateTime!
            .add(Duration(minutes: User.HEART_ADD_INTERVAL))),
        () => Cron().schedule(
                Schedule.parse(
                    "9,19,29,39,49,59 */${User.HEART_ADD_INTERVAL} * * * *"),
                () {
              print('should update heart now :/');
              if (Get.find<AppController>().currentUser != null)
                currentUser.updateHearts();
            }));
  }
}

class MoneyIndicator extends StatelessWidget {
  const MoneyIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final c = Get.put(MoneyController());

    return Column(
      children: [
        Center(
          child: Icon(
            CustomIcons.coins,
            size: 35,
            color: Colors.orangeAccent.shade200,
          ),
        ),
        SizedBox(
          height: 2.5,
        ),
        Center(
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Obx(
              () => Text(
                c.money.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class MoneyController extends GetxController {
  final money = 0.obs;

  @override
  void onInit() {
    super.onInit();

    money.value = Get.find<AppController>().currentUser!.money!;
  }
}

class PointsIndicator extends StatelessWidget {
  const PointsIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final c = Get.put(PointController());

    return Column(
      children: [
        Center(
          child: Icon(
            Icons.star,
            size: 37.5,
            color: Colors.yellow,
          ),
        ),
        Center(
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Obx(
              () => Text(
                c.points.value.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class PointController extends GetxController {
  final points = 0.obs;

  @override
  void onInit() {
    super.onInit();

    points.value = Get.find<AppController>().currentUser!.points!;
  }
}
