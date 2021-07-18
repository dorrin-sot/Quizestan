import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:mobdev_game_project/views/navigation_pages/accounts.dart';
import 'package:mobdev_game_project/views/navigation_pages/home.dart';
import 'package:mobdev_game_project/views/navigation_pages/settings.dart';
import 'package:mobdev_game_project/views/no_network_page.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

import 'models/question.dart';
import 'models/subject.dart';
import 'models/user.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  final keyApplicationId = dotenv.env['keyApplicationId']!;
  final keyParseServerUrl = dotenv.env['keyParseServerUrl']!;
  final keyClientKey = dotenv.env['keyParseClientKey']!;

  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey,
      registeredSubClassMap: <String, ParseObject Function()>{
        'Question': () => Question(),
        'Subject': () => Subject()
      },
      parseUserConstructor: (username, password, emailAddress,
              {client, debug, sessionToken}) =>
          User(username!, password!),
      debug: true);

  final c = AppController();
  Get.put(c);

  runApp(GetMaterialApp(
    initialRoute: '/home',
    getPages: [
      GetPage(
          name: '/home',
          page: () => HomePage(),
          transition: Transition.noTransition),
      GetPage(
          name: '/settings',
          page: () => SettingsPage(),
          transition: Transition.noTransition),
      GetPage(
          name: '/account/profile',
          page: () => AccountsPageProfile(),
          transition: Transition.noTransition),
      GetPage(
          name: '/account/login',
          page: () => AccountsPageLogin(),
          transition: Transition.noTransition),
      GetPage(
          name: '/account/register',
          page: () => AccountsPageRegister(),
          transition: Transition.noTransition),
      GetPage(
          name: '/no-network',
          page: () => NoNetworkPage(),
          transition: Transition.rightToLeft),
    ],
  ));
}

class AppController extends GetxController {
  bool? isLoggedIn;
  User? currentUser;
}
