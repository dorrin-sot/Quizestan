import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobdev_game_project/controllers/question_page_controller.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class QuestionPage extends StatelessWidget {
  final String subject;
  final QuestionPageController questionPageController =
      Get.put(QuestionPageController());

  QuestionPage(this.subject);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Question Page'),
        automaticallyImplyLeading: false,
        brightness: Brightness.light,
      ),
      body: FutureBuilder(
        future: questionPageController.fetchQuestions(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData ||
              (snapshot.data as List<dynamic>).length == 0) {
            return CircularProgressIndicator();
          } else {
            return Center(
              child: Obx(() {
                return Column(
                  children: [
                    Text("question from controller: " +
                        questionPageController
                            .questions[questionPageController.index()]),
                    Text("question: " +
                        snapshot.data[questionPageController.index()]
                            .get<String>("question")),
                    Text(questionPageController.index.toString()),
                    ElevatedButton(
                        onPressed: () => questionPageController.increment(),
                        child: Text("click me"))
                  ],
                );
              }),
            );
          }
        },
      ),
    );
  }
}
