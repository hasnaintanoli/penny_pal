/// Pure Dart Date formatting utility for Admin views without external dependencies.
class AdminDateFormat {
  static const List<String> _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  /// Formats date to: "MMM d, yyyy" (e.g. "May 12, 2026")
  static String formatShort(DateTime dt) {
    return '${_months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }

  /// Formats date to: "MMM d, h:mm a" (e.g. "May 12, 4:30 PM")
  static String formatTime(DateTime dt) {
    final hour = dt.hour == 0 ? 12 : (dt.hour > 12 ? dt.hour - 12 : dt.hour);
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '${_months[dt.month - 1]} ${dt.day}, $hour:$minute $period';
  }

  /// Formats date to: "MMM d, yyyy • h:mm a" (e.g. "May 12, 2026 • 4:30 PM")
  static String formatFull(DateTime dt) {
    final hour = dt.hour == 0 ? 12 : (dt.hour > 12 ? dt.hour - 12 : dt.hour);
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '${_months[dt.month - 1]} ${dt.day}, ${dt.year} • $hour:$minute $period';
  }
}
