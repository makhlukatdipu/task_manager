import 'package:flutter/material.dart';
import 'package:task_manager/data/services/api_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/snack_bar.dart';
import 'package:task_manager/ui/widgets/tm_app_bar.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(),
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Form(
              key:  _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 60),
                
                    Text(
                      'Add New Task',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                
                    const SizedBox(height: 20),
                
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(hintText: 'Title'),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter title';
                        }
                        return null;
                      },
                    ),
                
                    const SizedBox(height: 20),
                
                    TextFormField(
                      controller:  _descriptionController,
                      maxLines: 6,
                      decoration: InputDecoration(hintText: 'Description'),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter description';
                        }
                        return null;
                      },
                    ),
                
                    const SizedBox(height: 20),
                
                    FilledButton(
                      onPressed: () {
                        if(_formKey.currentState!.validate()){
                          addNewTask();
                        }
                      },
                      child: Icon(Icons.arrow_circle_right_outlined),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _addTaskProgress = false;

  Future<void> addNewTask()async{


    setState(() {
      _addTaskProgress = true;
    });
    Map<String,dynamic> requestBody = {
      "title": _titleController.text,
      "description":_descriptionController.text,
      "status":"New"
    };
    
    final ApiResponse response = await ApiCaller.postRequest(
        url: Urls.createTaskUrl,
      body: requestBody,
    );
    

    setState(() {
      _addTaskProgress = false;
    });
    
    if(response.isSuccess){
      _clearTextField();
      Navigator.pushNamedAndRemoveUntil(context, '/NavBar', (predicate)=> false);
      showSnackBarMessage(context, 'New task added');
    }else
      {
        showSnackBarMessage(context, response.errorMessage!);
      }
    
  }

  _clearTextField(){
    _titleController.clear();
    _descriptionController.clear();
  }

 
}
