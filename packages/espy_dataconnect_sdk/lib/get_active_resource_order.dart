part of 'espy.dart';

class GetActiveResourceOrderVariablesBuilder {
  String userId;

  final FirebaseDataConnect _dataConnect;
  GetActiveResourceOrderVariablesBuilder(this._dataConnect, {required  this.userId,});
  Deserializer<GetActiveResourceOrderData> dataDeserializer = (dynamic json)  => GetActiveResourceOrderData.fromJson(jsonDecode(json));
  Serializer<GetActiveResourceOrderVariables> varsSerializer = (GetActiveResourceOrderVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetActiveResourceOrderData, GetActiveResourceOrderVariables>> execute() {
    return ref().execute();
  }

  QueryRef<GetActiveResourceOrderData, GetActiveResourceOrderVariables> ref() {
    GetActiveResourceOrderVariables vars= GetActiveResourceOrderVariables(userId: userId,);
    return _dataConnect.query("GetActiveResourceOrder", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetActiveResourceOrderResourceOrders {
  final String id;
  final int pinsCount;
  final int slotsCount;
  final int broadcastsCount;
  final int totalCost;
  final EnumValue<OrderStatus> status;
  final Timestamp createdAt;
  final GetActiveResourceOrderResourceOrdersUser user;
  GetActiveResourceOrderResourceOrders.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  pinsCount = nativeFromJson<int>(json['pinsCount']),
  slotsCount = nativeFromJson<int>(json['slotsCount']),
  broadcastsCount = nativeFromJson<int>(json['broadcastsCount']),
  totalCost = nativeFromJson<int>(json['totalCost']),
  status = orderStatusDeserializer(json['status']),
  createdAt = Timestamp.fromJson(json['createdAt']),
  user = GetActiveResourceOrderResourceOrdersUser.fromJson(json['user']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetActiveResourceOrderResourceOrders otherTyped = other as GetActiveResourceOrderResourceOrders;
    return id == otherTyped.id && 
    pinsCount == otherTyped.pinsCount && 
    slotsCount == otherTyped.slotsCount && 
    broadcastsCount == otherTyped.broadcastsCount && 
    totalCost == otherTyped.totalCost && 
    status == otherTyped.status && 
    createdAt == otherTyped.createdAt && 
    user == otherTyped.user;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, pinsCount.hashCode, slotsCount.hashCode, broadcastsCount.hashCode, totalCost.hashCode, status.hashCode, createdAt.hashCode, user.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['pinsCount'] = nativeToJson<int>(pinsCount);
    json['slotsCount'] = nativeToJson<int>(slotsCount);
    json['broadcastsCount'] = nativeToJson<int>(broadcastsCount);
    json['totalCost'] = nativeToJson<int>(totalCost);
    json['status'] = 
    orderStatusSerializer(status)
    ;
    json['createdAt'] = createdAt.toJson();
    json['user'] = user.toJson();
    return json;
  }

  GetActiveResourceOrderResourceOrders({
    required this.id,
    required this.pinsCount,
    required this.slotsCount,
    required this.broadcastsCount,
    required this.totalCost,
    required this.status,
    required this.createdAt,
    required this.user,
  });
}

@immutable
class GetActiveResourceOrderResourceOrdersUser {
  final String id;
  GetActiveResourceOrderResourceOrdersUser.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetActiveResourceOrderResourceOrdersUser otherTyped = other as GetActiveResourceOrderResourceOrdersUser;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  GetActiveResourceOrderResourceOrdersUser({
    required this.id,
  });
}

@immutable
class GetActiveResourceOrderData {
  final List<GetActiveResourceOrderResourceOrders> resourceOrders;
  GetActiveResourceOrderData.fromJson(dynamic json):
  
  resourceOrders = (json['resourceOrders'] as List<dynamic>)
        .map((e) => GetActiveResourceOrderResourceOrders.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetActiveResourceOrderData otherTyped = other as GetActiveResourceOrderData;
    return resourceOrders == otherTyped.resourceOrders;
    
  }
  @override
  int get hashCode => resourceOrders.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['resourceOrders'] = resourceOrders.map((e) => e.toJson()).toList();
    return json;
  }

  GetActiveResourceOrderData({
    required this.resourceOrders,
  });
}

@immutable
class GetActiveResourceOrderVariables {
  final String userId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetActiveResourceOrderVariables.fromJson(Map<String, dynamic> json):
  
  userId = nativeFromJson<String>(json['userId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetActiveResourceOrderVariables otherTyped = other as GetActiveResourceOrderVariables;
    return userId == otherTyped.userId;
    
  }
  @override
  int get hashCode => userId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['userId'] = nativeToJson<String>(userId);
    return json;
  }

  GetActiveResourceOrderVariables({
    required this.userId,
  });
}

