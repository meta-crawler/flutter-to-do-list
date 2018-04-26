import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/Tasks.dart';
import 'package:flutter_app/models/Priority.dart';

class TaskRow extends StatelessWidget {
  final Tasks tasks;

  TaskRow(this.tasks);

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          decoration: new BoxDecoration(
            border: new Border(
              left: new BorderSide(
                width: 4.0,
                color: priorityColor[tasks.priority.index],
              ),
            ),
          ),
          child: new Row(
            children: [
              new Expanded(
                  child: new Column(
                children: <Widget>[
                  new Text(tasks.title, style: new TextStyle(fontSize: 16.0)),
                  new Text(_getFormattedDate(tasks.dueDate)),
                ],
              ))
            ],
          ),
        ),
        new Divider(
          color: Colors.grey,
        )
      ],
    );
  }

  String _getFormattedDate(int scheduleDate) {
    DateTime date = new DateTime.fromMillisecondsSinceEpoch(scheduleDate);
    return "${date.day}/${date.month}/${date.year}";
  }
}
