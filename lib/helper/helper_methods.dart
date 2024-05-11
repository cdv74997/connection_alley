import 'package:cloud_firestore/cloud_firestore.dart';

String formatDate(Timestamp timestamp) {
  // Timestamp is the object we retrieve from firebase
  // to display, let's convert it to a DateTime object
  DateTime dateTime = timestamp.toDate();

  // Convert hour from military time to regular time
  int hour = dateTime.hour;
  String period = 'AM';
  if (hour >= 12) {
    period = 'PM';
    if (hour > 12) {
      hour -= 12;
    }
  }
  if (hour == 0) {
    hour = 12;
  }

  // Format minute with leading zero if needed
  String minute = dateTime.minute.toString().padLeft(2, '0');

  // Get year, month, and day
  String year = dateTime.year.toString();
  String month = dateTime.month.toString().padLeft(2, '0');
  String day = dateTime.day.toString().padLeft(2, '0');

  // Construct the formatted date string
  String formattedDate = '$hour:$minute $period   $month/$day/$year';

  return formattedDate;
}