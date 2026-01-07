import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/data/services/api_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/widgets/snack_bar.dart';

import '../../providers/task_provider.dart';
import '../widgets/task_card.dart';
import '../widgets/tm_app_bar.dart';

class CancelTaskScreen extends StatefulWidget {
  const CancelTaskScreen({super.key});

  @override
  State<CancelTaskScreen> createState() => _CancelTaskScreenState();
}

class _CancelTaskScreenState extends State<CancelTaskScreen> {
  // bool _getCancelTaskProgress = false;
  // List<TaskModel> _cancelTaskList = [];
  //
  // Future<void> _getAllCancelTask() async {
  //   _getCancelTaskProgress = true;
  //   setState(() {});
  //
  //   final ApiResponse response = await ApiCaller.getRequest(
  //     url: Urls.cancelTaskUrl,
  //   );
  //   List<TaskModel> list = [];
  //   _getCancelTaskProgress = false;
  //   setState(() {});
  //   if (response.isSuccess) {
  //     for (Map<String, dynamic> jsonData in response.responseData['data']) {
  //       list.add(TaskModel.fromJson(jsonData));
  //     }
  //   } else {
  //     showSnackBarMessage(context, response.errorMessage.toString());
  //   }
  //   _cancelTaskList = list;
  // }

  Future<void> loadData()async{
    final taskProvider = Provider.of<TaskProvider>(context,listen: false);
    Future.wait([
      taskProvider.fetchNewTaskByStatus('Cancelled'),
    ]);
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(),
      body: Consumer<TaskProvider>(
        builder: (context,taskProvider,child) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListView.separated(
              itemBuilder: (context, index) {
                return TaskCard(
                  taskModel: taskProvider.cancelledTask[index],
                  cardColor: Colors.red,
                  refreshParent: () async{
                    await loadData();
                  },
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 4);
              },
              itemCount: taskProvider.cancelledTask.length,
            ),
          );
        }
      ),
    );
  }
}
