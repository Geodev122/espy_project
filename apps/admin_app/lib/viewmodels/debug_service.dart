import 'package:flutter/foundation.dart';

class DebugLog {
  final DateTime timestamp;
  final String category;
  final String message;
  final dynamic data;

  DebugLog({
    required this.timestamp,
    required this.category,
    required this.message,
    this.data,
  });
}

class DebugService extends ChangeNotifier {
  static final DebugService _instance = DebugService._internal();
  factory DebugService() => _instance;
  DebugService._internal();

  final List<DebugLog> _logs = [];
  List<DebugLog> get logs => List.unmodifiable(_logs);

  void log(String category, String message, {dynamic data}) {
    final newLog = DebugLog(
      timestamp: DateTime.now(),
      category: category.toUpperCase(),
      message: message,
      data: data,
    );
    
    _logs.insert(0, newLog);
    if (_logs.length > 200) _logs.removeLast();
    
    debugPrint('[$category] $message');
    notifyListeners();
  }

  void clear() {
    _logs.clear();
    notifyListeners();
  }
}
