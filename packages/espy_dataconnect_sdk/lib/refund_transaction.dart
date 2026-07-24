part of 'espy.dart';

class RefundTransactionVariablesBuilder {
  String id;
  String reason;

  final FirebaseDataConnect _dataConnect;
  RefundTransactionVariablesBuilder(this._dataConnect, {required  this.id,required  this.reason,});
  Deserializer<RefundTransactionData> dataDeserializer = (dynamic json)  => RefundTransactionData.fromJson(jsonDecode(json));
  Serializer<RefundTransactionVariables> varsSerializer = (RefundTransactionVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<RefundTransactionData, RefundTransactionVariables>> execute() {
    return ref().execute();
  }

  MutationRef<RefundTransactionData, RefundTransactionVariables> ref() {
    RefundTransactionVariables vars= RefundTransactionVariables(id: id,reason: reason,);
    return _dataConnect.mutation("RefundTransaction", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class RefundTransactionWalletTransactionUpdate {
  final String id;
  RefundTransactionWalletTransactionUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final RefundTransactionWalletTransactionUpdate otherTyped = other as RefundTransactionWalletTransactionUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  RefundTransactionWalletTransactionUpdate({
    required this.id,
  });
}

@immutable
class RefundTransactionData {
  final RefundTransactionWalletTransactionUpdate? walletTransaction_update;
  RefundTransactionData.fromJson(dynamic json):
  
  walletTransaction_update = json['walletTransaction_update'] == null ? null : RefundTransactionWalletTransactionUpdate.fromJson(json['walletTransaction_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final RefundTransactionData otherTyped = other as RefundTransactionData;
    return walletTransaction_update == otherTyped.walletTransaction_update;
    
  }
  @override
  int get hashCode => walletTransaction_update.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (walletTransaction_update != null) {
      json['walletTransaction_update'] = walletTransaction_update!.toJson();
    }
    return json;
  }

  RefundTransactionData({
    this.walletTransaction_update,
  });
}

@immutable
class RefundTransactionVariables {
  final String id;
  final String reason;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  RefundTransactionVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']),
  reason = nativeFromJson<String>(json['reason']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final RefundTransactionVariables otherTyped = other as RefundTransactionVariables;
    return id == otherTyped.id && 
    reason == otherTyped.reason;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, reason.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['reason'] = nativeToJson<String>(reason);
    return json;
  }

  RefundTransactionVariables({
    required this.id,
    required this.reason,
  });
}

