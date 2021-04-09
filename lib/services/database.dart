import 'package:login_screen/app/home/models/event.dart';
import 'package:login_screen/app/home/models/guest.dart';
import 'package:login_screen/app/home/models/task.dart';
import 'package:login_screen/services/api_path.dart';
import 'package:login_screen/services/firestore_service.dart';
import 'package:meta/meta.dart';

abstract class Database {


  Stream<Event> eventStream({@required String eventId});
  Future<void> setEvent(Event event);
  Future<void> deleteEvent(Event event);
  Stream<List<Event>> eventsStream({@required String order});
  Stream<List<Event>> queryEventStream({@required String eventName});

  Future<void> setGuest(Event event, Guest guest);
  Future<void> deleteGuest(Event event, Guest job);
  Stream<List<Guest>> guestsStream({@required String eventId});

  Future<void> setTask(Event event, Task task);
  Future<void> deleteTask(Event event, Task task);
  Stream<List<Task>> tasksStream({@required String eventId});

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

  @override
  Future<void> setGuest(Event event, Guest guest) => _service.setData(
        path: APIPath.guest(uid, event.id, guest.id),
        data: guest.toMap(),
      );

  @override
  Future<void> deleteGuest(Event event, Guest guest) => _service.deleteData(
        path: APIPath.guest(uid, event.id, guest.id),
      );

  @override
  Stream<List<Guest>> guestsStream({@required String eventId}) =>
      _service.collectionStream(
        path: APIPath.guests(uid, eventId),
        builder: (data, documentId) => Guest.fromMap(data, documentId),
      );

  @override
  Future<void> setTask(Event event, Task task) => _service.setData(
        path: APIPath.task(uid, event.id, task.id),
        data: task.toMap(),
      );

  @override
  Future<void> deleteTask(Event event, Task task) => _service.deleteData(
        path: APIPath.task(uid, event.id, task.id),
      );

  @override
  Stream<List<Task>> tasksStream({@required String eventId}) =>
      _service.collectionStream(
        path: APIPath.tasks(uid, eventId),
        builder: (data, documentId) => Task.fromMap(data, documentId),
      );
}
