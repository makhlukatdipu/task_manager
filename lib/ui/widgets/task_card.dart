import 'package:flutter/material.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/data/services/api_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/widgets/snack_bar.dart';
class TaskCard extends StatefulWidget {

  final TaskModel taskModel;
  final Color cardColor;
  final VoidCallback refreshParent;
  const TaskCard({
    super.key, required this.taskModel, required this.cardColor, required this.refreshParent,
  });

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {

  bool _changeStatusInProgress = false;

  Future<void> _changeStatus(String status)async{
    _changeStatusInProgress = true;
    setState(() {

    });

    final ApiResponse response = await ApiCaller.getRequest(
        url: Urls.changeStatus(widget.taskModel.id, status)
    );
    _changeStatusInProgress = false;
    setState(() {

    });

    if(response.isSuccess){
      widget.refreshParent();
      Navigator.pop(context);
    }else{
      showSnackBarMessage(context, response.errorMessage.toString());
    }
  }


  // Widget _statusTile(String status) {
  //   return ListTile(
  //     onTap: () {
  //       if (widget.taskModel.status != status) {
  //         _changeStatus(status);
  //       } else {
  //         Navigator.pop(context);
  //       }
  //     },
  //     title: Text(status),
  //     trailing: widget.taskModel.status == status
  //         ? const Icon(Icons.done, color: Colors.green)
  //         : null,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    void _showChangeStatusDialog(){
      showDialog(context: context, builder: (context){
        return AlertDialog(
          title: Text('Change Status'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: (){
                  _changeStatus('New');
                },
                title: Text('New'),
                trailing: widget.taskModel.status == 'New' ? Icon(Icons.done): null,
              ),

              ListTile(
                onTap: (){
                  _changeStatus('Progress');
                },
                title: Text('Progress'),
                trailing: widget.taskModel.status == 'Progress' ? Icon(Icons.done): null,
              ),
              ListTile(
                onTap: (){
                  _changeStatus('Cancel');
                },
                title: Text('Cancel'),
                trailing: widget.taskModel.status == 'Cancel' ? Icon(Icons.done): null,
              ),
              ListTile(
                onTap: (){
                  _changeStatus('Complete');
                },
                title: Text('Complete'),
                trailing: widget.taskModel.status == 'Complete' ? Icon(Icons.done): null,
              ),
              // _statusTile('New'),
              // _statusTile('Progress'),
              // _statusTile('Cancel'),
              // _statusTile('Complete'),
            ],
          ),
        );
      });
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        color: Colors.white,
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          title: Text(widget.taskModel.title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: 18,
          ),),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.taskModel.description),
              Text('Date: ${widget.taskModel.createDate}'),
              Row(
                children: [
                  Chip(
                    label: Text(widget.taskModel.status,),
                    backgroundColor: widget.cardColor,
                    labelStyle: TextStyle(color: Colors.white),
                    padding: EdgeInsets.symmetric(horizontal: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),

                  ),
                  Spacer(),
                  IconButton(onPressed: (){
                    _showChangeStatusDialog();
                  }, icon: Icon(Icons.edit_document),color: Colors.green,),
                  IconButton(onPressed: (){
                    _deleteTask();
                  }, icon: Icon(Icons.delete),color: Colors.red,),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  bool _isDeleteLoading = false;
  Future<void> _deleteTask()async{

    _isDeleteLoading = true;
    setState(() {

    });

    final ApiResponse response = await ApiCaller.getRequest(
        url: Urls.deleteTaskUrl(widget.taskModel.id)
    );

    _isDeleteLoading = false;
    setState(() {

    });

    if(response.isSuccess){
      showAdaptiveDialog(context: context, builder: (context)=>AlertDialog(
        icon: Icon(Icons.delete,size: 50,color: Colors.red,),
        title: Text('Are You Sure!',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
        actions: [
          TextButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: Text("No",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)),
          TextButton(onPressed: (){
            setState(() {
              widget.refreshParent();
            });
            Navigator.pop(context);
          }, child: Text('Yes',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.red)),
          )
        ],
      ));

    }else{
      showSnackBarMessage(context, response.errorMessage.toString());
    }

  }
}
