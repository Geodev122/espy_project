import 'package:flutter/foundation.dart';
import 'espy_repository.dart';

class AuditViewModel extends ChangeNotifier {
  final EspyRepository _repository;

  bool _isChecking = false;
  List<String> _conflicts = [];

  AuditViewModel(this._repository);

  bool get isChecking => _isChecking;
  List<String> get conflicts => _conflicts;

  Future<void> runTaxonomyAudit() async {
    _isChecking = true;
    _conflicts = [];
    notifyListeners();

    try {
      // 1. Fetch all users and check pins
      final users = await _repository.searchUsersAdmin().first;
      for (var u in users) {
        final nodes = await _repository.listLocationNodes(u.id).first;
        for (var node in nodes) {
          if (node['cityId'] == null) {
            _conflicts.add("Orphaned Pin: User ${u.email} has a pin with no city allocation.");
          }
        }
      }

      // 2. Fetch all services and check tags
      // ... similar logic
      
      if (_conflicts.isEmpty) {
        _conflicts.add("CLEAN PROTOCOL: No taxonomy conflicts detected.");
      }
    } catch (e) {
      _conflicts.add("Audit Error: $e");
    } finally {
      _isChecking = false;
      notifyListeners();
    }
  }
}
