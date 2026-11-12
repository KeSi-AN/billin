import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

const appLocale = 'en_IN';

/// Loads Indian-English date names. Call once before formatting dates.
Future<void> initDateFormatting() => initializeDateFormatting(appLocale);

/// `12 Nov 2026`
String formatDate(DateTime date) => DateFormat('d MMM y', appLocale).format(date);

/// `12 Nov 2026, 4:05 pm`
String formatDateTime(DateTime date) =>
    DateFormat('d MMM y, h:mm a', appLocale).format(date).replaceAll('AM', 'am').replaceAll('PM', 'pm');
