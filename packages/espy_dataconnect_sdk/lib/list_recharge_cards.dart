part of 'espy.dart';

class ListRechargeCardsVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  ListRechargeCardsVariablesBuilder(this._dataConnect, );
  Deserializer<ListRechargeCardsData> dataDeserializer = (dynamic json)  => ListRechargeCardsData.fromJson(jsonDecode(json));
  
  Future<QueryResult<ListRechargeCardsData, void>> execute() {
    return ref().execute();
  }

  QueryRef<ListRechargeCardsData, void> ref() {
    
    return _dataConnect.query("ListRechargeCards", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class ListRechargeCardsRechargeCards {
  final String id;
  final int tokenValue;
  final String status;
  final Timestamp? redeemedAt;
  final ListRechargeCardsRechargeCardsRedeemedBy? redeemedBy;
  ListRechargeCardsRechargeCards.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  tokenValue = nativeFromJson<int>(json['tokenValue']),
  status = nativeFromJson<String>(json['status']),
  redeemedAt = json['redeemedAt'] == null ? null : Timestamp.fromJson(json['redeemedAt']),
  redeemedBy = json['redeemedBy'] == null ? null : ListRechargeCardsRechargeCardsRedeemedBy.fromJson(json['redeemedBy']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListRechargeCardsRechargeCards otherTyped = other as ListRechargeCardsRechargeCards;
    return id == otherTyped.id && 
    tokenValue == otherTyped.tokenValue && 
    status == otherTyped.status && 
    redeemedAt == otherTyped.redeemedAt && 
    redeemedBy == otherTyped.redeemedBy;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, tokenValue.hashCode, status.hashCode, redeemedAt.hashCode, redeemedBy.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['tokenValue'] = nativeToJson<int>(tokenValue);
    json['status'] = nativeToJson<String>(status);
    if (redeemedAt != null) {
      json['redeemedAt'] = redeemedAt!.toJson();
    }
    if (redeemedBy != null) {
      json['redeemedBy'] = redeemedBy!.toJson();
    }
    return json;
  }

  ListRechargeCardsRechargeCards({
    required this.id,
    required this.tokenValue,
    required this.status,
    this.redeemedAt,
    this.redeemedBy,
  });
}

@immutable
class ListRechargeCardsRechargeCardsRedeemedBy {
  final String id;
  final String email;
  ListRechargeCardsRechargeCardsRedeemedBy.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  email = nativeFromJson<String>(json['email']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListRechargeCardsRechargeCardsRedeemedBy otherTyped = other as ListRechargeCardsRechargeCardsRedeemedBy;
    return id == otherTyped.id && 
    email == otherTyped.email;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, email.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['email'] = nativeToJson<String>(email);
    return json;
  }

  ListRechargeCardsRechargeCardsRedeemedBy({
    required this.id,
    required this.email,
  });
}

@immutable
class ListRechargeCardsData {
  final List<ListRechargeCardsRechargeCards> rechargeCards;
  ListRechargeCardsData.fromJson(dynamic json):
  
  rechargeCards = (json['rechargeCards'] as List<dynamic>)
        .map((e) => ListRechargeCardsRechargeCards.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListRechargeCardsData otherTyped = other as ListRechargeCardsData;
    return rechargeCards == otherTyped.rechargeCards;
    
  }
  @override
  int get hashCode => rechargeCards.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['rechargeCards'] = rechargeCards.map((e) => e.toJson()).toList();
    return json;
  }

  ListRechargeCardsData({
    required this.rechargeCards,
  });
}

