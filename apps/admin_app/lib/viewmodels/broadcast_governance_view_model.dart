import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:espy_core/espy_core.dart';

class BroadcastGovernanceViewModel extends ChangeNotifier {
  final EspyRepository _repository;

  List<BroadcastModel> _broadcasts = [];
  bool _isLoading = false;
  StreamSubscription? _broadcastSub;

  BroadcastGovernanceViewModel(this._repository);

  List<BroadcastModel> get broadcasts => _broadcasts;
  bool get isLoading => _isLoading;

  void listenToBroadcastModerationQueue({ModerationStatus status = ModerationStatus.pending}) {
    _isLoading = true;
    notifyListeners();

    _broadcastSub?.cancel();
    _broadcastSub = _repository.listBroadcastModerationQueue(status: status).listen((data) {
      _broadcasts = data.map((map) => BroadcastModel.fromMap(map)).toList();
      _isLoading = false;
      notifyListeners();
    }, onError: (e) {
      debugPrint("Error listening to broadcast queue: $e");
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> moderateBroadcast(String id, ModerationStatus status, {String? reason}) async {
    try {
      await _repository.moderateBroadcast(id, status, reason: reason);
    } catch (e) {
      debugPrint("Error moderating broadcast: $e");
      rethrow;
    }
  }

  @override
  void dispose() {
    _broadcastSub?.cancel();
    super.dispose();
  }
}
