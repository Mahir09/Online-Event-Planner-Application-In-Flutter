import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/app/Event/edit_event_page.dart';
import 'package:login_screen/app/Event/guest_list_tile.dart';
import 'package:login_screen/app/home/guests/guests_page.dart';
import 'package:login_screen/app/home/guests/list_items_builder.dart';
import 'package:login_screen/app/home/models/event.dart';
import 'package:login_screen/components/show_alert_dialog.dart';
import 'package:login_screen/components/show_exception_alert_dialog.dart';
import 'package:login_screen/services/auth.dart';
import 'package:login_screen/services/database.dart';
import 'package:provider/provider.dart';

class EventsPage extends StatelessWidget {
  const EventsPage({Key key, this.dataBase}) : super(key: key);

  final Database dataBase;

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await showAlertDialog(
      context,
      title: 'Logout',
      content: 'Are you sure that you want to logout?',
      cancelActionText: 'Cancel',
      defaultActionText: 'Logout',
    );
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  Future<void> _delete(BuildContext context, Event event) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteEvent(event);
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 40.0),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Events'),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Logout',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () => _confirmSignOut(context),
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: new Text('Mahir Shekh'),
                accountEmail: new Text('123@gmail.com'),
                currentAccountPicture: new CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: new Text('M'),
                ),
                // otherAccountsPictures: <Widget>[
                //   new CircleAvatar(
                //     backgroundColor: Colors.blue,
                //     child: new Text("A"),
                //   )
                // ],
              ),
              FlatButton(
                // onPressed:() async {
                //   const url = 'mailto:19it135@charusat.edu.in?subject=Feedback&body= ';
                //   if (await canLaunch(url)) {
                //     await launch(url);
                //   } else {
                //     throw 'Could not launch $url';
                //   }
                // },
                child: ListTile(
                  leading: Icon(Icons.event_available_outlined),
                  title: Text('Manage Events'),
                  onTap:() {
                    print("Mahir");
                  },
                ),
              ),
              Divider(
                thickness: 1,
              ),
              FlatButton(
                // onPressed:() async {
                //   const url = 'mailto:19it135@charusat.edu.in?subject=Feedback&body= ';
                //   if (await canLaunch(url)) {
                //     await launch(url);
                //   } else {
                //     throw 'Could not launch $url';
                //   }
                // },
                child: ListTile(
                  leading: Icon(Icons.category_outlined),
                  title: Text('Manage Category'),
                  onTap:() {
                    print("Mahir");
                  },
                ),
              ),
              Divider(
                thickness: 1,
              ),
              FlatButton(
                // onPressed:() async {
                //   const url = 'mailto:19it135@charusat.edu.in?subject=Feedback&body= ';
                //   if (await canLaunch(url)) {
                //     await launch(url);
                //   } else {
                //     throw 'Could not launch $url';
                //   }
                // },
                child: ListTile(
                  leading: Icon(Icons.picture_as_pdf_rounded),
                  title: Text('PDF Reports'),
                  onTap:() {
                    print("Mahir");
                  },
                ),
              ),
              Divider(
                thickness: 1,
              ),
              FlatButton(
                // onPressed:() async {
                //   const url = 'https://mahirshekh.blogspot.com/';
                //   if (await canLaunch(url)) {
                //     await launch(url);
                //   } else {
                //     throw 'Could not launch $url';
                //   }
                // },
                child: ListTile(
                  leading: Icon(Icons.info_outlined),
                  title: Text('For More Info.'),
                ),
              ),
              Divider(
                thickness: 1,
              ),
              FlatButton(
                // onPressed:() async {
                //   const url = 'mailto:19it135@charusat.edu.in?subject=Feedback&body= ';
                //   if (await canLaunch(url)) {
                //     await launch(url);
                //   } else {
                //     throw 'Could not launch $url';
                //   }
                // },
                child: ListTile(
                  leading: Icon(Icons.feedback_outlined),
                  title: Text('Feedback'),
                ),
              ),
            ],
          ),
        ),
        body: _buildContents(context),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => CreateEvent.show(
            context,
            database: Provider.of<Database>(context, listen: false),
          ),
          //onPressed: () => CreateEvent.show(context, database:database)
        ),
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Event>>(
      stream: database.eventsStream(),
      builder: (context, snapshot) {
        return ListItemsBuilder<Event>(
          snapshot: snapshot,
          itemBuilder: (context, event) => Dismissible(
            key: Key('event-${event.id}'),
            background: Container(color: Colors.red),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => _delete(context, event),
            child: EventListTile(
              event: event,
              onTap: () => GuestsPage.show(context,event),
              // onTap: () => CreateEvent.show(
              //   context,
              //   //database: dataBase,
              //   event: event,
              // ),
            ),
          ),
        );
      },
    );
  }
}
