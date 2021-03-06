import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mobdev_game_project/utils/constants.dart';
import 'package:mobdev_game_project/views/appbar_and_navbar/appbar_related.dart';
import 'package:mobdev_game_project/views/appbar_and_navbar/navbar_related.dart';
import 'package:mobdev_game_project/views/no_network_page.dart';
import 'package:mobdev_game_project/views/quiz_page/question_page.dart';
import 'package:mobdev_game_project/views/quiz_page/quiz_result.dart';
import 'package:mobdev_game_project/views/subject_page/subject_page.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/question.dart';
import 'models/subject.dart';
import 'models/user.dart';

Future main() async {
  // await initServices();
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp();

  final keyApplicationId = dotenv.env['keyApplicationId']!;
  final keyParseServerUrl = dotenv.env['keyParseServerUrl']!;
  final keyClientKey = dotenv.env['keyParseClientKey']!;

  await Parse().initialize(
    keyApplicationId,
    keyParseServerUrl,
    clientKey: keyClientKey,
    registeredSubClassMap: <String, ParseObject Function()>{
      'Question': () => Question(),
      'Subject': () => Subject()
    },
    parseUserConstructor: (username, password, emailAddress,
            {client, debug, sessionToken}) =>
        User(username, password),
    debug: true,
    coreStore: await CoreStoreSharedPrefsImp.getInstance(),
  );

  Get.put(AppController());
  runApp(MyApp());
}

//initServices() async {
//  await Get.putAsync(()=>SettingsService().init());
//}
//
//class SettingsService extends GetxService {
//  AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();
//
//  init() async {
//    audioPlayer.open(Audio('assets/sounds/Main-Theme.mp3'));
//  }
//}

class MyApp extends StatelessWidget {
  //const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double screenWidth = window.physicalSize.width;

    return GetMaterialApp(
      theme : THEME_DATA,
      initialRoute: '/main-pages',
      getPages: [
        GetPage(
            name: '/main-pages',
            page: () => Scaffold(
                  appBar: CustomAppbar.build(),
                  bottomNavigationBar: CustomBottomNavBar.build(),
                  backgroundColor: Colors.white,
                  body: GetBuilder<NavBarController>(
                    init: Get.find<NavBarController>(),
                    builder: (c) {
                      final body = c.currentPage.value;
                      print('current page = $body');
                      return body;
                    },
                  ),
                ),
            transition: Transition.noTransition),
        GetPage(
            name: '/no-network',
            page: () => NoNetworkPage(),
            transition: Transition.rightToLeft),
        GetPage(
            name: '/subjects',
            page: () => SubjectPage(),
            transition: Transition.rightToLeft),
        GetPage(
            name: '/question_page',
            page: () => QuestionPage(),
            transition: Transition.rightToLeft),
        GetPage(
            name: '/quiz-res',
            page: () => QuizResultPage(),
            transition: Transition.rightToLeft),
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}

class AppController extends GetxController {
  RxBool isLoggedIn = false.obs;
  User? currentUser;
  final player = AudioPlayer();
  final quizPlayer = AudioPlayer();
  double musicVolume = 0.1;

  @override
  Future<void> onInit() async {
    super.onInit();
    await prefsOnInit();
    await setMusic();
  }


  @override
  void onClose() {
    super.onClose();
    player.dispose();
  }

  prefsOnInit() async {
    print('AppController::prefsOnInit');
    await getUserFromPrefs();
    await getMusicVolumePrefs();
    update();
  }

  Future<void> saveUserInPrefs(ParseUser? user) async {
    print('AppController::saveUserInPrefs');
    if (user != null) {
      currentUser = User.fromJsonn(user.getJsonMap());
      isLoggedIn.value = true;
    } else {
      currentUser = null;
      isLoggedIn.value = false;
    }
    update();
  }

  Future<void> getUserFromPrefs() async {
    print('AppController::getUserFromPrefs');
    ParseUser.currentUser().then((response) async {
      final updatedResult = await (response as ParseUser).getUpdatedUser();

      currentUser =
          User.fromJsonn((updatedResult.result as ParseUser).getJsonMap());
      isLoggedIn.value = true;
      print('currentUser: $currentUser');

      update();
    });
  }

  Future<void> getMusicVolumePrefs() async {
    final prefs = await SharedPreferences.getInstance();

    double? curVolume = await prefs.getDouble('musicVolume');

    if (curVolume != null) {
      musicVolume = curVolume;
    }
    update();
  }

  Future<void> setMusic() async {
    await player.setAsset('assets/sounds/Main-Theme.mp3');
    await quizPlayer.setAsset('assets/sounds/Quiz-Song.mp3');
    setMusicVolume(musicVolume);
    player.play();
    await player.setLoopMode(LoopMode.one);
    await quizPlayer.setLoopMode(LoopMode.one);
  }

  Future<void> setMusicVolume(double value) async {
    await player.setVolume(value);
    await quizPlayer.setVolume(value);
  }

  Future<void> saveMusicVolumeInPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setDouble('musicVolume', musicVolume);
  }
}

extension ObjectMapGet on Object {
  Map<String, dynamic> getJsonMap() => jsonDecode(jsonEncode(this));
}
