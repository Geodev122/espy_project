part of 'espy.dart';

class GetWalletTransactionsVariablesBuilder {
  String userId;

  final FirebaseDataConnect _dataConnect;
  GetWalletTransactionsVariablesBuilder(this._dataConnect, {required  this.userId,});
  Deserializer<GetWalletTransactionsData> dataDeserializer = (dynamic json)  => GetWalletTransactionsData.fromJson(jsonDecode(json));
  Serializer<GetWalletTransactionsVariables> varsSerializer = (GetWalletTransactionsVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetWalletTransactionsData, GetWalletTransactionsVariables>> execute() {
    return ref().execute();
  }

  QueryRef<GetWalletTransactionsData, GetWalletTransactionsVariables> ref() {
    GetWalletTransactionsVariables vars= GetWalletTransactionsVariables(userId: userId,);
    return _dataConnect.query("GetWalletTransactions", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetWalletTransactionsWalletTransactions {
  final String id;
  final EnumValue<TransactionType> type;
  final int amount;
  final String? referenceId;
  final String? description;
  final Timestamp createdAt;
  GetWalletTransactionsWalletTransactions.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  type = transactionTypeDeserializer(json['type']),
  amount = nativeFromJson<int>(json['amount']),
  referenceId = json['referenceId'] == null ? null : nativeFromJson<String>(json['referenceId']),
  description = json['description'] == null ? null : nativeFromJson<String>(json['description']),
  createdAt = Timestamp.fromJson(json['createdAt']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetWalletTransactionsWalletTransactions otherTyped = other as GetWalletTransactionsWalletTransactions;
    return id == otherTyped.id && 
    type == otherTyped.type && 
    amount == otherTyped.amount && 
    referenceId == otherTyped.referenceId && 
    description == otherTyped.description && 
    createdAt == otherTyped.createdAt;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, type.hashCode, amount.hashCode, referenceId.hashCode, description.hashCode, createdAt.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['type'] = 
    transactionTypeSerializer(type)
    ;
    json['amount'] = nativeToJson<int>(amount);
    if (referenceId != null) {
      json['referenceId'] = nativeToJson<String?>(referenceId);
    }
    if (description != null) {
      json['description'] = nativeToJson<String?>(description);
    }
    json['createdAt'] = createdAt.toJson();
    return json;
  }

  GetWalletTransactionsWalletTransactions({
    required this.id,
    required this.type,
    required this.amount,
    this.referenceId,
    this.description,
    required this.createdAt,
  });
}

@immutable
class GetWalletTransactionsData {
  final List<GetWalletTransactionsWalletTransactions> walletTransactions;
  GetWalletTransactionsData.fromJson(dynamic json):
  
  walletTransactions = (json['walletTransactions'] as List<dynamic>)
        .map((e) => GetWalletTransactionsWalletTransactions.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetWalletTransactionsData otherTyped = other as GetWalletTransactionsData;
    return walletTransactions == otherTyped.walletTransactions;
    
  }
  @override
  int get hashCode => walletTransactions.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['walletTransactions'] = walletTransactions.map((e) => e.toJson()).toList();
    return json;
  }

  GetWalletTransactionsData({
    required this.walletTransactions,
  });
}

@immutable
class GetWalletTransactionsVariables {
  final String userId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetWalletTransactionsVariables.fromJson(Map<String, dynamic> json):
  
  userId = nativeFromJson<String>(json['userId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetWalletTransactionsVariables otherTyped = other as GetWalletTransactionsVariables;
    return userId == otherTyped.userId;
    
  }
  @override
  int get hashCode => userId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['userId'] = nativeToJson<String>(userId);
    return json;
  }

  GetWalletTransactionsVariables({
    required this.userId,
  });
}

