import 'package:flutter/material.dart';
import 'package:flutter_app/db/AppDatabase.dart';
import 'package:flutter_app/models/Label.dart';
import 'package:flutter_app/models/Project.dart';
import 'package:flutter_app/models/Tasks.dart';
import 'package:flutter_app/pages/home/side_drawer.dart';
import 'package:flutter_app/pages/tasks/add_task.dart';
import 'package:flutter_app/pages/tasks/row_task.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<HomeScreen> {
  final List<Tasks> taskList = new List();
  GlobalKey<ScaffoldState> _scaffoldHomeState = new GlobalKey<ScaffoldState>();
  String homeTitle = "Today";
  int taskStartTime, taskEndTime;

  @override
  void initState() {
    var dateTime = new DateTime.now();
    taskStartTime = new DateTime(dateTime.year, dateTime.month, dateTime.day)
        .millisecondsSinceEpoch;
    taskEndTime =
        new DateTime(dateTime.year, dateTime.month, dateTime.day, 23, 59)
            .millisecondsSinceEpoch;
    updateTasks(taskStartTime, taskEndTime);
    super.initState();
  }

  void updateTasks(int taskStartTime, int taskEndTime) {
    AppDatabase
        .get()
        .getTasks(
            startDate: taskStartTime,
            endDate: taskEndTime,
            taskStatus: TaskStatus.PENDING)
        .then((tasks) {
      if (tasks == null) return;
      setState(() {
        taskList.clear();
        taskList.addAll(tasks);
      });
    });
  }

  void updateTasksByProject(Project project) {
    AppDatabase.get().getTasksByProject(project.id).then((tasks) {
      if (tasks == null) return;
      setState(() {
        homeTitle = project.name;
        taskList.clear();
        taskList.addAll(tasks);
      });
    });
  }

  void updateTasksByLabel(Label label) {
    AppDatabase.get().getTasksByLabel(label.name).then((tasks) {
      if (tasks == null) return;
      setState(() {
        homeTitle = label.name;
        taskList.clear();
        taskList.addAll(tasks);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldHomeState,
      appBar: new AppBar(
        title: new Text(homeTitle),
      ),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.orange,
        onPressed: () async {
          bool isDataChanged = await Navigator.push(
            context,
            new MaterialPageRoute<bool>(
                builder: (context) => new AddTaskScreen()),
          );

          if (isDataChanged) {
            updateTasks(taskStartTime, taskEndTime);
          }
        },
      ),
      drawer: new SideDrawer(
        projectSelection: (project) {
          updateTasksByProject(project);
        },
        labelSelection: (label) {
          updateTasksByLabel(label);
        },
        dateSelection: (startTime, endTime) {
          var dayInMillis = 86340000;
          homeTitle =
              endTime - startTime > dayInMillis ? "Next 7 Days" : "Today";
          taskStartTime = startTime;
          taskEndTime = endTime;
          updateTasks(startTime, endTime);
        },
      ),
      body: new Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: new Container(
          child: new ListView.builder(
              itemCount: taskList.length,
              itemBuilder: (BuildContext context, int index) {
                return new Dismissible(
                    key: new Key("dismiss"),
                    onDismissed: (DismissDirection direction) {
                      if (direction == DismissDirection.endToStart) {
                        AppDatabase
                            .get()
                            .updateTaskStatus(
                                taskList[index].id, TaskStatus.COMPLETE)
                            .then((value) {
                          setState(() {
                            taskList.removeAt(index);
                          });
                          _showSnackbar("Task marks as completed");
                        });
                      } else {
                        AppDatabase
                            .get()
                            .deleteTask(taskList[index].id)
                            .then((value) {
                          setState(() {
                            taskList.removeAt(index);
                          });
                          _showSnackbar("Task Deleted");
                        });
                      }
                    },
                    background: new Container(
                      color: Colors.red,
                      child: new ListTile(
                        leading: new Icon(Icons.delete, color: Colors.white),
                      ),
                    ),
                    secondaryBackground: new Container(
                      color: Colors.green,
                      child: new ListTile(
                        trailing: new Icon(Icons.check, color: Colors.white),
                      ),
                    ),
                    child: new TaskRow(taskList[index]));
              }),
        ),
      ),
    );
  }

  _showSnackbar(String message) {
    if (message.isEmpty) return;
    // Find the Scaffold in the Widget tree and use it to show a SnackBar
    _scaffoldHomeState.currentState
        .showSnackBar(new SnackBar(content: new Text(message)));
  }
}
