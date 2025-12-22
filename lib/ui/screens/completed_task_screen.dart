import 'package:flutter/material.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/data/services/api_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/widgets/snack_bar.dart';
import 'package:task_manager/ui/widgets/task_card.dart';
import 'package:task_manager/ui/widgets/tm_app_bar.dart';

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {
  bool _getCompletedTaskProgress = false;
  List<TaskModel> _progressTaskList = [];

  Future<void> _getAllCompletedTask() async {
    _getCompletedTaskProgress = true;

    setState(() {});

    final ApiResponse response = await ApiCaller.getRequest(
      url: Urls.completedTaskUrl,
    );

    _getCompletedTaskProgress = false;

    setState(() {});

    List<TaskModel> list = [];
    if (response.isSuccess) {
      for (Map<String, dynamic> jsonData in response.responseData['data']) {
        list.add(TaskModel.fromJson(jsonData));
      }
    } else {
      showSnackBarMessage(context, response.errorMessage.toString());
    }

    _progressTaskList = list;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAllCompletedTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: ListView.separated(
          itemBuilder: (context, index) {
            return TaskCard(
              taskModel: _progressTaskList[index],
              cardColor: Colors.green,
              refreshParent: () {
                _getAllCompletedTask();
              },
            );
          },
          separatorBuilder: (context, index) {
            return const SizedBox(height: 4);
          },
          itemCount: _progressTaskList.length,
        ),
      ),
    );
  }
}
