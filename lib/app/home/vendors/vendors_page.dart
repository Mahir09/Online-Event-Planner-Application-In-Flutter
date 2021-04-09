import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:login_screen/app/home/models/event.dart';
import 'package:login_screen/app/home/models/vendors.dart';
import 'package:login_screen/app/home/vendors/edit_vendor_page.dart';
import 'package:login_screen/app/home/vendors/vendor_list_tile.dart';
import 'package:login_screen/components/list_items_builder.dart';
import 'package:login_screen/components/show_alert_dialog.dart';
import 'package:login_screen/components/show_exception_alert_dialog.dart';
import 'package:login_screen/constants.dart';
import 'package:login_screen/services/database.dart';
import 'package:provider/provider.dart';

class VendorsPage extends StatefulWidget {
  const VendorsPage({@required this.database, @required this.event});
  final Database database;
  final Event event;

  static Future<void> show(BuildContext context, Event event) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: false,
        builder: (context) => VendorsPage(database: database, event: event),
      ),
    );
  }

  @override
  _VendorsPageState createState() => _VendorsPageState();
}

class _VendorsPageState extends State<VendorsPage> {

  Future<void> _confirmDelete(BuildContext context, Vendor vendor) async {
    final didRequestDelete = await showAlertDialog(
      context,
      title: 'Delete',
      content: 'Are you sure that you want to delete?',
      cancelActionText: 'No',
      defaultActionText: 'Yes',
    );
    if (didRequestDelete == true) {
      _delete(context, vendor);
    }
  }

  Future<void> _delete(BuildContext context, Vendor vendor) async {
    try {
      await widget.database.deleteVendor(widget.event, vendor);
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
                title: Text('Vendors'),
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
                onPressed: () => EditVendorPage.show(
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
    return StreamBuilder<List<Vendor>>(
      stream: widget.database.vendorsStream(eventId: event.id),
      builder: (context, snapshot) {
        return ListItemsBuilder<Vendor>(
          snapshot: snapshot,
          itemBuilder: (context, vendor) => Slidable(
            key: Key('vendor-${vendor.id}'),
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
                onTap: () => _confirmDelete(context, vendor),
              ),
            ],
            child: VendorListTile(
              vendor: vendor,
              onTap: () => EditVendorPage.show(
                context: context,
                database: widget.database,
                event: event,
                vendor: vendor,
              ),
            ),
          ),
        );
      },
    );
  }
  // Widget _buildContents(BuildContext context, Event event) {
  //   return StreamBuilder<List<Vendor>>(
  //     stream: widget.database.vendorsStream(eventId: event.id),
  //     builder: (context, snapshot) {
  //       return ListItemsBuilder<Vendor>(
  //         snapshot: snapshot,
  //         itemBuilder: (context, vendor) => Dismissible(
  //           key: Key('vendor-${vendor.id}'),
  //           background: Container(color: Colors.red),
  //           direction: DismissDirection.endToStart,
  //           onDismissed: (direction) => _delete(context, vendor),
  //           child: VendorListTile(
  //             vendor: vendor,
  //             onTap: () => EditVendorPage.show(
  //               context: context,
  //               database: widget.database,
  //               event: event,
  //               vendor: vendor,
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
}
