import 'package:meta/meta.dart';
import 'Priority.dart';

class Tasks {
  static final tblTask = "Tasks";
  static final dbId = "id";
  static final dbTitle = "title";
  static final ddComment = "comment";
  static final dbDueDate = "dueDate";
  static final dbPriority = "priority";

  String title, comment;
  int id, dueDate;
  Status priority;

  Tasks(
      {@required this.id,
      @required this.title,
      this.comment = "",
      this.dueDate = -1,
      this.priority = Status.PRIORITY_4}) {
    if (this.dueDate == -1) {
      this.dueDate = new DateTime.now().millisecondsSinceEpoch;
    }
  }

  Tasks.fromMap(Map<String, dynamic> map)
      : this(
          id: map[dbId],
          title: map[dbTitle],
          comment: map[ddComment],
          dueDate: map[dbDueDate],
          priority: Status.values[map[dbPriority]],
        );
}
