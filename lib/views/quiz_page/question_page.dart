import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobdev_game_project/controllers/question_page_controller.dart';
import 'package:mobdev_game_project/models/question.dart';
import 'package:mobdev_game_project/models/subject.dart';
import 'package:mobdev_game_project/utils/utils.dart';
import 'package:mobdev_game_project/views/common/laoding.dart';
import 'package:mobdev_game_project/views/quiz_page/answer_widget.dart';
import 'package:mobdev_game_project/views/quiz_page/clock_widget.dart';

class QuestionPage extends StatelessWidget {
  final Subject subject = Get.arguments['subject'];
  final QuestionPageController questionPageController =
      Get.put(QuestionPageController());

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      body: FutureBuilder(
        future: questionPageController.fetchQuestions(subject),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData ||
              (snapshot.data as List<Question>).length == 0) {
            return LoadingSupportPage("سوالات");
          } else {
            return SafeArea(
              child: Container(
                decoration: BoxDecoration(
                    // gradient: LinearGradient(
                    //     colors: [Colors.indigo, Colors.white],
                    //     begin: Alignment.topRight,
                    //     end: Alignment.bottomLeft,
                    //     tileMode: TileMode.clamp),
                    ),
                child: Center(
                  child: Obx(() {
                    return Column(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: DecoratedBox(
                              decoration: BoxDecoration(boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    blurRadius: 40,
                                    spreadRadius: 20)
                              ]),
                              child: Text(
                                questionPageController
                                    .questions![questionPageController.index]
                                    .question!,
                                style: themeData.textTheme.headline2,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 8,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: AnswersListView(),
                            )),
                        Expanded(flex: 4, child: Clock()),
                      ],
                    );
                  }),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  ListView AnswersListView() {
    questionPageController.correctAnswer = questionPageController
            .questions![questionPageController.index].correctAns! -
        1;
    return ListView(
      children: List.generate(
        4,
        (index) => AnswerWidget(
          questionPageController
              .questions![questionPageController.index].answers![index],
          index,
        ),
      ),
    );
  }
}
