
class APIPath {
  static String event(String uid, String eventId) => 'users/$uid/Events/$eventId';
  static String events(String uid) => 'users/$uid/Events';
}