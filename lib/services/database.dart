import 'package:login_screen/app/home/models/event.dart';
import 'package:login_screen/services/api_path.dart';
import 'package:login_screen/services/firestore_service.dart';
import 'package:meta/meta.dart';

abstract class Database {


  Stream<Event> eventStream({@required String eventId});
  Future<void> setEvent(Event event);
  Future<void> deleteEvent(Event event);
  Stream<List<Event>> eventsStream({@required String order});
  Stream<List<Event>> queryEventStream({@required String eventName});

}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;

  final _service = FirestoreService.instance;

  @override
  Future<void> setEvent(Event event) => _service.setData(
        path: APIPath.event(uid, event.id),
        data: event.toMap(),
      );

  @override
  Future<void> deleteEvent(Event event) => _service.deleteData(
        path: APIPath.event(uid, event.id),
      );

  @override
  Stream<List<Event>> eventsStream({@required String order}) =>
      _service.collectionStream(
        order: order,
        path: APIPath.events(uid),
        builder: (data, documentId) => Event.fromMap(data, documentId),
      );

  @override
  Stream<List<Event>> queryEventStream({@required String eventName}) =>
      _service.queryCollectionStream(
        eventName: eventName,
        path: APIPath.events(uid),
        builder: (data, documentId) => Event.fromMap(data, documentId),
      );

  @override
  Stream<Event> eventStream({@required String eventId}) =>
      _service.documentStream(
        path: APIPath.event(uid, eventId),
        builder: (data, documentId) => Event.fromMap(data, documentId),
      );
}
