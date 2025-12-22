import 'package:flutter/material.dart';

import '../../data/models/task_model.dart';
import '../../data/services/api_caller.dart';
import '../../data/utils/urls.dart';
import '../widgets/snack_bar.dart';
import '../widgets/task_card.dart';
import '../widgets/tm_app_bar.dart';
class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {


  bool _getProgressTakProgress = false;
  List<TaskModel> _progressTaskList = [];

  Future<void> _getAllTask()async{

    _getProgressTakProgress = true;

    setState(() {

    });

    final ApiResponse response = await ApiCaller.getRequest(
      url: Urls.progressTaskUrl,
    );
    _getProgressTakProgress = false;
    setState(() {

    });
    List<TaskModel> list = [];
    if(response.isSuccess){

      for(Map<String,dynamic> jsonData in response.responseData['data']){
        list.add(TaskModel.fromJson(jsonData));
      }
    }else{
      showSnackBarMessage(context, response.errorMessage.toString());
    }
    _progressTaskList = list;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAllTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
        child: ListView.separated(
            itemBuilder: (context,index){

              return TaskCard(taskModel: _progressTaskList[index],
                cardColor: Colors.purple,
              refreshParent: (){
                _getAllTask();
              },);
            },
            separatorBuilder: (context,index){
              return const SizedBox(height: 4,);
            },
            itemCount: _progressTaskList.length),
      ),
    );
  }
}
