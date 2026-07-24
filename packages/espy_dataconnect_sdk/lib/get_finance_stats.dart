part of 'espy.dart';

class GetFinanceStatsVariablesBuilder {
  Optional<Timestamp> _start = Optional.optional((json) => json['start'] = Timestamp.fromJson(json['start']), defaultSerializer);
  Optional<Timestamp> _end = Optional.optional((json) => json['end'] = Timestamp.fromJson(json['end']), defaultSerializer);

  final FirebaseDataConnect _dataConnect;
  GetFinanceStatsVariablesBuilder start(Timestamp? t) {
   _start.value = t;
   return this;
  }
  GetFinanceStatsVariablesBuilder end(Timestamp? t) {
   _end.value = t;
   return this;
  }

  GetFinanceStatsVariablesBuilder(this._dataConnect, );
  Deserializer<GetFinanceStatsData> dataDeserializer = (dynamic json)  => GetFinanceStatsData.fromJson(jsonDecode(json));
  Serializer<GetFinanceStatsVariables> varsSerializer = (GetFinanceStatsVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetFinanceStatsData, GetFinanceStatsVariables>> execute() {
    return ref().execute();
  }

  QueryRef<GetFinanceStatsData, GetFinanceStatsVariables> ref() {
    GetFinanceStatsVariables vars= GetFinanceStatsVariables(start: _start,end: _end,);
    return _dataConnect.query("GetFinanceStats", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetFinanceStatsWalletTransactions {
  final String id;
  final int amount;
  final EnumValue<TransactionType> type;
  final String? description;
  final String? invoiceNumber;
  final bool? isRefunded;
  final String? parentTransactionId;
  final Timestamp createdAt;
  final GetFinanceStatsWalletTransactionsUser user;
  GetFinanceStatsWalletTransactions.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  amount = nativeFromJson<int>(json['amount']),
  type = transactionTypeDeserializer(json['type']),
  description = json['description'] == null ? null : nativeFromJson<String>(json['description']),
  invoiceNumber = json['invoiceNumber'] == null ? null : nativeFromJson<String>(json['invoiceNumber']),
  isRefunded = json['isRefunded'] == null ? null : nativeFromJson<bool>(json['isRefunded']),
  parentTransactionId = json['parentTransactionId'] == null ? null : nativeFromJson<String>(json['parentTransactionId']),
  createdAt = Timestamp.fromJson(json['createdAt']),
  user = GetFinanceStatsWalletTransactionsUser.fromJson(json['user']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetFinanceStatsWalletTransactions otherTyped = other as GetFinanceStatsWalletTransactions;
    return id == otherTyped.id && 
    amount == otherTyped.amount && 
    type == otherTyped.type && 
    description == otherTyped.description && 
    invoiceNumber == otherTyped.invoiceNumber && 
    isRefunded == otherTyped.isRefunded && 
    parentTransactionId == otherTyped.parentTransactionId && 
    createdAt == otherTyped.createdAt && 
    user == otherTyped.user;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, amount.hashCode, type.hashCode, description.hashCode, invoiceNumber.hashCode, isRefunded.hashCode, parentTransactionId.hashCode, createdAt.hashCode, user.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['amount'] = nativeToJson<int>(amount);
    json['type'] = 
    transactionTypeSerializer(type)
    ;
    if (description != null) {
      json['description'] = nativeToJson<String?>(description);
    }
    if (invoiceNumber != null) {
      json['invoiceNumber'] = nativeToJson<String?>(invoiceNumber);
    }
    if (isRefunded != null) {
      json['isRefunded'] = nativeToJson<bool?>(isRefunded);
    }
    if (parentTransactionId != null) {
      json['parentTransactionId'] = nativeToJson<String?>(parentTransactionId);
    }
    json['createdAt'] = createdAt.toJson();
    json['user'] = user.toJson();
    return json;
  }

  GetFinanceStatsWalletTransactions({
    required this.id,
    required this.amount,
    required this.type,
    this.description,
    this.invoiceNumber,
    this.isRefunded,
    this.parentTransactionId,
    required this.createdAt,
    required this.user,
  });
}

@immutable
class GetFinanceStatsWalletTransactionsUser {
  final String id;
  final String email;
  final String? name;
  GetFinanceStatsWalletTransactionsUser.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  email = nativeFromJson<String>(json['email']),
  name = json['name'] == null ? null : nativeFromJson<String>(json['name']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetFinanceStatsWalletTransactionsUser otherTyped = other as GetFinanceStatsWalletTransactionsUser;
    return id == otherTyped.id && 
    email == otherTyped.email && 
    name == otherTyped.name;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, email.hashCode, name.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['email'] = nativeToJson<String>(email);
    if (name != null) {
      json['name'] = nativeToJson<String?>(name);
    }
    return json;
  }

  GetFinanceStatsWalletTransactionsUser({
    required this.id,
    required this.email,
    this.name,
  });
}

@immutable
class GetFinanceStatsData {
  final List<GetFinanceStatsWalletTransactions> walletTransactions;
  GetFinanceStatsData.fromJson(dynamic json):
  
  walletTransactions = (json['walletTransactions'] as List<dynamic>)
        .map((e) => GetFinanceStatsWalletTransactions.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetFinanceStatsData otherTyped = other as GetFinanceStatsData;
    return walletTransactions == otherTyped.walletTransactions;
    
  }
  @override
  int get hashCode => walletTransactions.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['walletTransactions'] = walletTransactions.map((e) => e.toJson()).toList();
    return json;
  }

  GetFinanceStatsData({
    required this.walletTransactions,
  });
}

@immutable
class GetFinanceStatsVariables {
  late final Optional<Timestamp>start;
  late final Optional<Timestamp>end;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetFinanceStatsVariables.fromJson(Map<String, dynamic> json) {
  
  
    start = Optional.optional((json) => json['start'] = Timestamp.fromJson(json['start']), defaultSerializer);
    start.value = json['start'] == null ? null : Timestamp.fromJson(json['start']);
  
  
    end = Optional.optional((json) => json['end'] = Timestamp.fromJson(json['end']), defaultSerializer);
    end.value = json['end'] == null ? null : Timestamp.fromJson(json['end']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetFinanceStatsVariables otherTyped = other as GetFinanceStatsVariables;
    return start == otherTyped.start && 
    end == otherTyped.end;
    
  }
  @override
  int get hashCode => Object.hashAll([start.hashCode, end.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if(start.state == OptionalState.set) {
      json['start'] = start.toJson();
    }
    if(end.state == OptionalState.set) {
      json['end'] = end.toJson();
    }
    return json;
  }

  GetFinanceStatsVariables({
    required this.start,
    required this.end,
  });
}

