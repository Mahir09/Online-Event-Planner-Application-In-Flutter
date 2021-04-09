import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:login_screen/app/home/budget/budget_list_tile.dart';
import 'package:login_screen/app/home/budget/edit_budget_page.dart';
import 'package:login_screen/app/home/models/budget.dart';
import 'package:login_screen/app/home/models/event.dart';
import 'package:login_screen/components/list_items_builder.dart';
import 'package:login_screen/components/show_alert_dialog.dart';
import 'package:login_screen/components/show_exception_alert_dialog.dart';
import 'package:login_screen/constants.dart';
import 'package:login_screen/services/database.dart';
import 'package:provider/provider.dart';

class BudgetsPage extends StatefulWidget {
  const BudgetsPage({@required this.database, @required this.event});
  final Database database;
  final Event event;

  static Future<void> show(BuildContext context, Event event) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: false,
        builder: (context) => BudgetsPage(database: database, event: event),
      ),
    );
  }

  @override
  _BudgetsPageState createState() => _BudgetsPageState();
}

class _BudgetsPageState extends State<BudgetsPage> {

  Future<void> _confirmDelete(BuildContext context, Budget budget) async {
    final didRequestDelete = await showAlertDialog(
      context,
      title: 'Delete',
      content: 'Are you sure that you want to delete?',
      cancelActionText: 'No',
      defaultActionText: 'Yes',
    );
    if (didRequestDelete == true) {
      _delete(context, budget);
    }
  }

  Future<void> _delete(BuildContext context, Budget budget) async {
    try {
      await widget.database.deleteBudget(widget.event, budget);
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
          if(snapshot.data == null) return CircularProgressIndicator();
          final event = snapshot.data;
          return Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: Scaffold(
              appBar: AppBar(
                title: Text('Budgets'),
                actions: <Widget>[
                  // FlatButton(
                  //   child: Text(
                  //     'Logout',
                  //     style: TextStyle(
                  //       fontSize: 18.0,
                  //       color: Colors.white,
                  //     ),
                  //   ),
                  //   onPressed: () => _confirmSignOut(context),
                  // ),
                ],
              ),
              body: _buildContents(context, event),
              floatingActionButton: FloatingActionButton(
                backgroundColor: kPrimaryColor,
                child: Icon(Icons.add),
                onPressed: () => EditBudgetPage.show(
                  context: context,
                  database: widget.database,
                  event: event,
                ),
              ),
            ),
          );
        });
  }

  Widget _buildContents(BuildContext context, Event event) {
    return StreamBuilder<List<Budget>>(
      stream: widget.database.budgetsStream(eventId: event.id),
      builder: (context, snapshot) {
        return ListItemsBuilder<Budget>(
          snapshot: snapshot,
          itemBuilder: (context, budget) => Slidable(
            key: Key('budget-${budget.id}'),
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
                onTap: () => _confirmDelete(context, budget),
              ),
            ],
            child: BudgetListTile(
              budget: budget,
              onTap: () => EditBudgetPage.show(
                context: context,
                database: widget.database,
                event: event,
                budget: budget,
              ),
            ),
          ),
        );
      },
    );
  }
  // Widget _buildContents(BuildContext context, Event event) {
  //   return StreamBuilder<List<Budget>>(
  //     stream: widget.database.budgetsStream(eventId: event.id),
  //     builder: (context, snapshot) {
  //       return ListItemsBuilder<Budget>(
  //         snapshot: snapshot,
  //         itemBuilder: (context, budget) => Dismissible(
  //           key: Key('budget-${budget.id}'),
  //           background: Container(color: Colors.red),
  //           direction: DismissDirection.endToStart,
  //           onDismissed: (direction) => _delete(context, budget),
  //           child: BudgetListTile(
  //             budget: budget,
  //             onTap: () => EditBudgetPage.show(
  //               context: context,
  //               database: widget.database,
  //               event: event,
  //               budget: budget,
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
}
