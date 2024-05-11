import 'package:intl/intl.dart';

class DateTimeFormat {
  static String date(String date) {
    return DateFormat('dd MMMM yyyy', 'en')
        .format(DateTime.parse(date.toString()).toLocal())
        .replaceAll(DateTime.parse(date.toString()).toLocal().year.toString(), (DateTime.parse(date.toString()).toLocal().year).toString());
  }

  static String dateTime(String date) {
    return DateFormat('EEEE ที่ dd เดือน MMMM ปี yyyy เวลา kk:mm', 'en')
        .format(DateTime.parse(date.toString()).toLocal())
        .replaceAll(DateTime.parse(date.toString()).toLocal().year.toString(), (DateTime.parse(date.toString()).toLocal().year).toString());
  }
}
