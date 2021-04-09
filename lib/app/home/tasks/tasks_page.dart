import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:login_screen/app/home/models/event.dart';
import 'package:login_screen/app/home/models/task.dart';
import 'package:login_screen/app/home/tasks/edit_task_page.dart';
import 'package:login_screen/app/home/tasks/task_list_tile.dart';
import 'package:login_screen/components/list_items_builder.dart';
import 'package:login_screen/components/show_alert_dialog.dart';
import 'package:login_screen/components/show_exception_alert_dialog.dart';
import 'package:login_screen/constants.dart';
import 'package:login_screen/services/database.dart';
import 'package:provider/provider.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({@required this.database, @required this.event});
  final Database database;
  final Event event;

  static Future<void> show(BuildContext context, Event event) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: false,
        builder: (context) => TasksPage(database: database, event: event),
      ),
    );
  }

  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  Future<void> _confirmDelete(BuildContext context, Task task) async {
    final didRequestDelete = await showAlertDialog(
      context,
      title: 'Delete',
      content: 'Are you sure that you want to delete?',
      cancelActionText: 'No',
      defaultActionText: 'Yes',
    );
    if (didRequestDelete == true) {
      _delete(context, task);
    }
  }

  Future<void> _delete(BuildContext context, Task task) async {
    try {
      await widget.database.deleteTask(widget.event, task);
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Operation failed',
        exception: e,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Event>(
      stream: widget.database.eventStream(eventId: widget.event.id),
      builder: (context, snapshot) {
        if (snapshot.data == null) return CircularProgressIndicator();
        final event = snapshot.data;
        return Padding(
          padding: const EdgeInsets.only(bottom: 40.0),
          child: Scaffold(
            appBar: AppBar(
              title: Text('Tasks'),
              actions: <Widget>[],
            ),
            body: _buildContents(context, event),
            floatingActionButton: FloatingActionButton(
              backgroundColor: kPrimaryColor,
              child: Icon(Icons.add),
              onPressed: () => EditTaskPage.show(
                context: context,
                database: widget.database,
                event: event,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContents(BuildContext context, Event event) {
    return StreamBuilder<List<Task>>(
      stream: widget.database.tasksStream(eventId: event.id),
      builder: (context, snapshot) {
        return ListItemsBuilder<Task>(
          snapshot: snapshot,
          itemBuilder: (context, task) => Slidable(
            key: Key('task-${task.id}'),
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            actions: <Widget>[
              IconSlideAction(
                  caption: 'View',
                  color: Colors.red,
                  icon: Icons.picture_as_pdf,
                  onTap: () => {}
                  //PDF.show(context, database: database, guest: guest),
                  ),
            ],
            secondaryActions: <Widget>[
              IconSlideAction(
                caption: 'Delete',
                color: Colors.red,
                icon: Icons.delete,
                onTap: () => _confirmDelete(context, task),
              ),
            ],
            child: TaskListTile(
              task: task,
              onTap: () => EditTaskPage.show(
                context: context,
                database: widget.database,
                event: event,
                task: task,
              ),
            ),
          ),
        );
      },
    );
  }
  // Widget _buildContents(BuildContext context, Event event) {
  //   return StreamBuilder<List<Task>>(
  //     stream: widget.database.tasksStream(eventId: event.id),
  //     builder: (context, snapshot) {
  //       return ListItemsBuilder<Task>(
  //         snapshot: snapshot,
  //         itemBuilder: (context, task) => Dismissible(
  //           key: Key('task-${task.id}'),
  //           background: Container(color: Colors.red),
  //           direction: DismissDirection.endToStart,
  //           onDismissed: (direction) => _delete(context, task),
  //           child: TaskListTile(
  //             task: task,
  //             onTap: () => EditTaskPage.show(
  //               context: context,
  //               database: widget.database,
  //               event: event,
  //               task: task,
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
}
