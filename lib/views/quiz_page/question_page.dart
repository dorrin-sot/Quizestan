import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobdev_game_project/controllers/question_page_controller.dart';
import 'package:mobdev_game_project/models/question.dart';
import 'package:mobdev_game_project/models/subject.dart';
import 'package:mobdev_game_project/views/common/laoding.dart';
import 'package:mobdev_game_project/views/quiz_page/answer_widget.dart';
import 'package:mobdev_game_project/views/quiz_page/clock_widget.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class QuestionPage extends StatelessWidget {
  final Subject subject = Get.arguments['subject'];
  final QuestionPageController questionPageController =
      Get.put(QuestionPageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Question Page'),
        automaticallyImplyLeading: false,
        brightness: Brightness.light,
      ),
      body: FutureBuilder(
        future: questionPageController.fetchQuestions(subject),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData ||
              (snapshot.data as List<Question>).length == 0) {
            return LoadingSupportPage("سوالات!");
          } else {
            return Center(
              child: Obx(() {
                return Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: Text(
                            "question ${questionPageController.index.toString()} from controller: " +
                                questionPageController
                                    .questions![questionPageController.index]
                                    .question!),
                      ),
                    ),
                    Expanded(flex: 6, child: AnswersListView()),
                    Expanded(flex: 3, child: Clock()),
                  ],
                );
              }),
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
      shrinkWrap: true,
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