import 'package:intl/intl.dart';

String formatDateByddmmyyyy(DateTime dateTime) {
  return DateFormat("d MMM, yyyy").format(dateTime);
}
