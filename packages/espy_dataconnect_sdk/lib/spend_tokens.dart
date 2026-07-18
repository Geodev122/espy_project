part of 'espy.dart';

class SpendTokensVariablesBuilder {
  String userId;
  int cost;
  int ledgerAmount;
  Optional<TransactionType> _type = Optional.optional((data) => TransactionType.values.byName(data), enumSerializer);
  String description;

  final FirebaseDataConnect _dataConnect;  SpendTokensVariablesBuilder type(TransactionType? t) {
   _type.value = t;
   return this;
  }

  SpendTokensVariablesBuilder(this._dataConnect, {required  this.userId,required  this.cost,required  this.ledgerAmount,required  this.description,});
  Deserializer<SpendTokensData> dataDeserializer = (dynamic json)  => SpendTokensData.fromJson(jsonDecode(json));
  Serializer<SpendTokensVariables> varsSerializer = (SpendTokensVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<SpendTokensData, SpendTokensVariables>> execute() {
    return ref().execute();
  }

  MutationRef<SpendTokensData, SpendTokensVariables> ref() {
    SpendTokensVariables vars= SpendTokensVariables(userId: userId,cost: cost,ledgerAmount: ledgerAmount,type: _type,description: description,);
    return _dataConnect.mutation("SpendTokens", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class SpendTokensUserUpdate {
  final String id;
  SpendTokensUserUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final SpendTokensUserUpdate otherTyped = other as SpendTokensUserUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  SpendTokensUserUpdate({
    required this.id,
  });
}

@immutable
class SpendTokensWalletTransactionInsert {
  final String id;
  SpendTokensWalletTransactionInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final SpendTokensWalletTransactionInsert otherTyped = other as SpendTokensWalletTransactionInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  SpendTokensWalletTransactionInsert({
    required this.id,
  });
}

@immutable
class SpendTokensData {
  final SpendTokensUserUpdate? user_update;
  final SpendTokensWalletTransactionInsert walletTransaction_insert;
  SpendTokensData.fromJson(dynamic json):
  
  user_update = json['user_update'] == null ? null : SpendTokensUserUpdate.fromJson(json['user_update']),
  walletTransaction_insert = SpendTokensWalletTransactionInsert.fromJson(json['walletTransaction_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final SpendTokensData otherTyped = other as SpendTokensData;
    return user_update == otherTyped.user_update && 
    walletTransaction_insert == otherTyped.walletTransaction_insert;
    
  }
  @override
  int get hashCode => Object.hashAll([user_update.hashCode, walletTransaction_insert.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (user_update != null) {
      json['user_update'] = user_update!.toJson();
    }
    json['walletTransaction_insert'] = walletTransaction_insert.toJson();
    return json;
  }

  SpendTokensData({
    this.user_update,
    required this.walletTransaction_insert,
  });
}

@immutable
class SpendTokensVariables {
  final String userId;
  final int cost;
  final int ledgerAmount;
  late final Optional<TransactionType>type;
  final String description;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  SpendTokensVariables.fromJson(Map<String, dynamic> json):
  
  userId = nativeFromJson<String>(json['userId']),
  cost = nativeFromJson<int>(json['cost']),
  ledgerAmount = nativeFromJson<int>(json['ledgerAmount']),
  description = nativeFromJson<String>(json['description']) {
  
  
  
  
  
    type = Optional.optional((data) => TransactionType.values.byName(data), enumSerializer);
    type.value = json['type'] == null ? null : TransactionType.values.byName(json['type']);
  
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final SpendTokensVariables otherTyped = other as SpendTokensVariables;
    return userId == otherTyped.userId && 
    cost == otherTyped.cost && 
    ledgerAmount == otherTyped.ledgerAmount && 
    type == otherTyped.type && 
    description == otherTyped.description;
    
  }
  @override
  int get hashCode => Object.hashAll([userId.hashCode, cost.hashCode, ledgerAmount.hashCode, type.hashCode, description.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['userId'] = nativeToJson<String>(userId);
    json['cost'] = nativeToJson<int>(cost);
    json['ledgerAmount'] = nativeToJson<int>(ledgerAmount);
    if(type.state == OptionalState.set) {
      json['type'] = type.toJson();
    }
    json['description'] = nativeToJson<String>(description);
    return json;
  }

  SpendTokensVariables({
    required this.userId,
    required this.cost,
    required this.ledgerAmount,
    required this.type,
    required this.description,
  });
}

