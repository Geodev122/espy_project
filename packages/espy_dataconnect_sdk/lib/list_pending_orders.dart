part of 'espy.dart';

class ListPendingOrdersVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  ListPendingOrdersVariablesBuilder(this._dataConnect, );
  Deserializer<ListPendingOrdersData> dataDeserializer = (dynamic json)  => ListPendingOrdersData.fromJson(jsonDecode(json));
  
  Future<QueryResult<ListPendingOrdersData, void>> execute() {
    return ref().execute();
  }

  QueryRef<ListPendingOrdersData, void> ref() {
    
    return _dataConnect.query("ListPendingOrders", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class ListPendingOrdersResourceOrders {
  final String id;
  final int pinsCount;
  final int slotsCount;
  final int broadcastsCount;
  final int totalCost;
  final EnumValue<OrderStatus> status;
  final ListPendingOrdersResourceOrdersUser user;
  ListPendingOrdersResourceOrders.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  pinsCount = nativeFromJson<int>(json['pinsCount']),
  slotsCount = nativeFromJson<int>(json['slotsCount']),
  broadcastsCount = nativeFromJson<int>(json['broadcastsCount']),
  totalCost = nativeFromJson<int>(json['totalCost']),
  status = orderStatusDeserializer(json['status']),
  user = ListPendingOrdersResourceOrdersUser.fromJson(json['user']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListPendingOrdersResourceOrders otherTyped = other as ListPendingOrdersResourceOrders;
    return id == otherTyped.id && 
    pinsCount == otherTyped.pinsCount && 
    slotsCount == otherTyped.slotsCount && 
    broadcastsCount == otherTyped.broadcastsCount && 
    totalCost == otherTyped.totalCost && 
    status == otherTyped.status && 
    user == otherTyped.user;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, pinsCount.hashCode, slotsCount.hashCode, broadcastsCount.hashCode, totalCost.hashCode, status.hashCode, user.hashCode]);
  

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
    json['user'] = user.toJson();
    return json;
  }

  ListPendingOrdersResourceOrders({
    required this.id,
    required this.pinsCount,
    required this.slotsCount,
    required this.broadcastsCount,
    required this.totalCost,
    required this.status,
    required this.user,
  });
}

@immutable
class ListPendingOrdersResourceOrdersUser {
  final String id;
  final String email;
  final String? name;
  ListPendingOrdersResourceOrdersUser.fromJson(dynamic json):
  
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

    final ListPendingOrdersResourceOrdersUser otherTyped = other as ListPendingOrdersResourceOrdersUser;
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

  ListPendingOrdersResourceOrdersUser({
    required this.id,
    required this.email,
    this.name,
  });
}

@immutable
class ListPendingOrdersData {
  final List<ListPendingOrdersResourceOrders> resourceOrders;
  ListPendingOrdersData.fromJson(dynamic json):
  
  resourceOrders = (json['resourceOrders'] as List<dynamic>)
        .map((e) => ListPendingOrdersResourceOrders.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListPendingOrdersData otherTyped = other as ListPendingOrdersData;
    return resourceOrders == otherTyped.resourceOrders;
    
  }
  @override
  int get hashCode => resourceOrders.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['resourceOrders'] = resourceOrders.map((e) => e.toJson()).toList();
    return json;
  }

  ListPendingOrdersData({
    required this.resourceOrders,
  });
}

