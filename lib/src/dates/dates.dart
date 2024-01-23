// ignore_for_file: constant_identifier_names

import 'package:okhttp/src/dates/date_fromatter.dart';

/// The last four-digit year: "Fri, 31 Dec 9999 23:59:59 GMT".
const int MAX_DATE = 253402300799999;

/// Most websites serve cookies in the blessed format. Eagerly create the parser to ensure such
/// cookies are on the fast path.
//  final STANDARD_DATE_FORMAT =  {
//   override fun initialValue(): DateFormat {
//     // Date format specified by RFC 7231 section 7.1.1.1.
//     return SimpleDateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'", Locale.US).apply {
//       isLenient = false
//       timeZone = UTC
//     }
//   }
// }
extension HttpDateTimeExtensions on DateTime {
  String toHttpDateString() {
    return DateFormatter(this)
        .format(DateFromat('EEE, dd MMM yyyy HH:mm:ss \'GMT\''));
  }
}
