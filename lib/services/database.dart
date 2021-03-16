import 'package:login_screen/services/firestore_service.dart';
import 'package:meta/meta.dart';

abstract class Database {
  }

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;

  final _service = FirestoreService.instance;

}
