import 'package:flutter/material.dart';
import 'package:task_manager/data/models/task_status_count_model.dart';
import 'package:task_manager/data/services/api_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/screens/add_new_task_screen.dart';
import 'package:task_manager/ui/widgets/snack_bar.dart';

import '../../data/models/task_model.dart';
import '../widgets/task_card.dart';
import '../widgets/task_count_by_status.dart';
import '../widgets/tm_app_bar.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {

  bool _getTaskStatusCountProgress = false;
  bool _getNewTakProgress = false;
  List<TaskStatusCountModel> _taskStatusCountList = [];
  List<TaskModel> _newTaskList = [];

  Future<void> _getAllTaskCount()async{
    _getTaskStatusCountProgress = true;

    setState(() {

    });

    final ApiResponse response = await ApiCaller.getRequest(
        url: Urls.taskCountUrl,
    );
    _getTaskStatusCountProgress = false;
    setState(() {

    });
    List<TaskStatusCountModel> list = [];
    if(response.isSuccess){

      for(Map<String,dynamic> jsonData in response.responseData['data']){
        list.add(TaskStatusCountModel.fromJson(jsonData));
      }
    }else{
      showSnackBarMessage(context, response.errorMessage.toString());
    }
    _taskStatusCountList = list;
  }


  Future<void> _getAllNewTask()async{

    _getNewTakProgress = true;

    setState(() {

    });

    final ApiResponse response = await ApiCaller.getRequest(
        url: Urls.newTaskUrl,
    );
    _getNewTakProgress = false;
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
    _newTaskList = list;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAllTaskCount();
    _getAllNewTask();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(),
      body: Column(
        children: [
          SizedBox(height: 15),

          Padding(
            padding: const EdgeInsets.all(3),
            child: SizedBox(
              height: 90,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _taskStatusCountList.length,
                itemBuilder: (context, index) {
                  return TaskCountByStatus(
                      title: _taskStatusCountList[index].status,
                      count: _taskStatusCountList[index].count);
                },
                separatorBuilder: (context, index) {
                  return SizedBox(width: 4);
                },
              ),
            ),
          ),

          Expanded(

            child: ListView.separated(
              itemCount: _newTaskList.length,
              itemBuilder: (context, index) {
                return TaskCard(
                  taskModel: _newTaskList[index],
                  cardColor: Colors.blue,
                refreshParent: (){
                  _getAllTaskCount();
                  _getAllNewTask();
                }
                  ,);
              },

              separatorBuilder: (context, index) {
                return SizedBox(height: 4);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>AddNewTaskScreen()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
