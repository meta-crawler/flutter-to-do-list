import 'package:flutter/material.dart';
import 'package:flutter_app/bloc/bloc_provider.dart';
import 'package:flutter_app/db/app_db.dart';
import 'package:flutter_app/db/project_db.dart';
import 'package:flutter_app/models/label.dart';
import 'package:flutter_app/models/project.dart';
import 'package:flutter_app/pages/about/about_us.dart';
import 'package:flutter_app/pages/labels/add_label.dart';
import 'package:flutter_app/pages/projects/project_bloc.dart';
import 'package:flutter_app/pages/projects/project_widget.dart';

class SideDrawer extends StatefulWidget {
  ProjectSelection projectSelection;
  LabelSelection labelSelection;
  DateSelection dateSelection;

  SideDrawer({this.projectSelection, this.labelSelection, this.dateSelection});

  @override
  _SideDrawerState createState() => new _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  final List<Project> projectList = new List();
  final List<Label> labelList = new List();

  @override
  void initState() {
    super.initState();
    updateLabels();
  }

  void updateLabels() {
    AppDatabase.get().getLabels().then((projects) {
      if (projects != null) {
        setState(() {
          labelList.clear();
          labelList.addAll(projects);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: new ListView(
        children: <Widget>[
          new UserAccountsDrawerHeader(
            accountName: new Text("Burhanuddin Rashid"),
            accountEmail: new Text("burhanrashid5253@gmail.com"),
            otherAccountsPictures: <Widget>[
              new IconButton(
                  icon: new Icon(
                    Icons.info,
                    color: Colors.white,
                    size: 36.0,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      new MaterialPageRoute<bool>(
                          builder: (context) => new AboutUsScreen()),
                    );
                  })
            ],
            currentAccountPicture: new CircleAvatar(
              backgroundColor: Theme.of(context).accentColor,
              backgroundImage: new AssetImage("assets/profile_pic.jpg"),
            ),
          ),
          new ListTile(
              leading: new Icon(Icons.inbox),
              title: new Text("Inbox"),
              onTap: () {
                if (widget.projectSelection != null) {
                  var project = Project.getInbox();
                  widget.projectSelection(project);
                  Navigator.pop(context);
                }
              }),
          new ListTile(
              onTap: () {
                var dateTime = new DateTime.now();
                var taskStartTime =
                    new DateTime(dateTime.year, dateTime.month, dateTime.day)
                        .millisecondsSinceEpoch;
                var taskEndTime = new DateTime(
                        dateTime.year, dateTime.month, dateTime.day, 23, 59)
                    .millisecondsSinceEpoch;

                if (widget.dateSelection != null) {
                  widget.dateSelection(taskStartTime, taskEndTime);
                }
                Navigator.pop(context);
              },
              leading: new Icon(Icons.calendar_today),
              title: new Text("Today")),
          new ListTile(
            onTap: () {
              var dateTime = new DateTime.now();
              var taskStartTime =
                  new DateTime(dateTime.year, dateTime.month, dateTime.day)
                      .millisecondsSinceEpoch;
              var taskEndTime = new DateTime(
                      dateTime.year, dateTime.month, dateTime.day + 7, 23, 59)
                  .millisecondsSinceEpoch;

              if (widget.dateSelection != null) {
                widget.dateSelection(taskStartTime, taskEndTime);
              }
              Navigator.pop(context);
            },
            leading: new Icon(Icons.calendar_today),
            title: new Text("Next 7 Days"),
          ),
          BlocProvider(
            bloc: ProjectBloc(ProjectDB.get()),
            child: ProjectPage(widget.projectSelection),
          ),
          buildExpansionTile(Icons.label, "Labels")
        ],
      ),
    );
  }

  ExpansionTile buildExpansionTile(IconData icon, String projectName) {
    return new ExpansionTile(
      leading: new Icon(icon),
      title: new Text(projectName,
          style: new TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold)),
      children: buildLabels(),
    );
  }

  List<Widget> buildLabels() {
    List<Widget> projectWidgetList = new List();
    labelList.forEach((label) =>
        projectWidgetList.add(new LabelRow(label, labelSelection: (label) {
          widget.labelSelection(label);
          Navigator.pop(context);
        })));
    projectWidgetList.add(new ListTile(
        leading: new Icon(Icons.add),
        title: new Text("Add Label"),
        onTap: () async {
          Navigator.pop(context);
          bool isDataChanged = await Navigator.push(
              context,
              new MaterialPageRoute<bool>(
                  builder: (context) => new AddLabel()));

          if (isDataChanged) {
            updateLabels();
          }
        }));
    return projectWidgetList;
  }
}

class ProjectRow extends StatelessWidget {
  final Project project;
  final ProjectSelection projectSelection;

  ProjectRow(this.project, {this.projectSelection});

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      onTap: () {
        if (projectSelection != null) {
          projectSelection(project);
        }
      },
      leading: new Container(
        width: 24.0,
        height: 24.0,
      ),
      title: new Text(project.name),
      trailing: new Container(
        height: 10.0,
        width: 10.0,
        child: new CircleAvatar(
          backgroundColor: new Color(project.colorValue),
        ),
      ),
    );
  }
}

class LabelRow extends StatelessWidget {
  final Label label;
  final LabelSelection labelSelection;

  LabelRow(this.label, {this.labelSelection});

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      onTap: () {
        if (labelSelection != null) {
          labelSelection(label);
        }
      },
      leading: new Container(
        width: 24.0,
        height: 24.0,
      ),
      title: new Text("@ ${label.name}"),
      trailing: new Container(
        height: 10.0,
        width: 10.0,
        child: new Icon(
          Icons.label,
          size: 16.0,
          color: new Color(label.colorValue),
        ),
      ),
    );
  }
}

typedef void ProjectSelection(Project project);
typedef void LabelSelection(Label label);
typedef void DateSelection(int startDate, int endDate);
