
class APIPath {
  static String event(String uid, String eventId) => 'users/$uid/Events/$eventId';
  static String events(String uid) => 'users/$uid/Events';

  static String guest(String uid, String eventId, String guestId) => 'users/$uid/Events/$eventId/Guests/$guestId';
  static String guests(String uid, String eventId) => 'users/$uid/Events/$eventId/Guests';
}