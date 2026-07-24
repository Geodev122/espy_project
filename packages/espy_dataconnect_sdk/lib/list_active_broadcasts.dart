part of 'espy.dart';

class ListActiveBroadcastsVariablesBuilder {
  Optional<String> _country = Optional.optional(nativeFromJson, nativeToJson);
  Optional<UserRole> _role = Optional.optional((data) => UserRole.values.byName(data), enumSerializer);

  final FirebaseDataConnect _dataConnect;
  ListActiveBroadcastsVariablesBuilder country(String? t) {
   _country.value = t;
   return this;
  }
  ListActiveBroadcastsVariablesBuilder role(UserRole? t) {
   _role.value = t;
   return this;
  }

  ListActiveBroadcastsVariablesBuilder(this._dataConnect, );
  Deserializer<ListActiveBroadcastsData> dataDeserializer = (dynamic json)  => ListActiveBroadcastsData.fromJson(jsonDecode(json));
  Serializer<ListActiveBroadcastsVariables> varsSerializer = (ListActiveBroadcastsVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<ListActiveBroadcastsData, ListActiveBroadcastsVariables>> execute() {
    return ref().execute();
  }

  QueryRef<ListActiveBroadcastsData, ListActiveBroadcastsVariables> ref() {
    ListActiveBroadcastsVariables vars= ListActiveBroadcastsVariables(country: _country,role: _role,);
    return _dataConnect.query("ListActiveBroadcasts", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ListActiveBroadcastsBroadcasts {
  final String id;
  final String title;
  final String message;
  final String? targetCountry;
  final String? targetRegion;
  final String? targetCity;
  final EnumValue<UserRole>? targetRole;
  final Timestamp createdAt;
  ListActiveBroadcastsBroadcasts.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  title = nativeFromJson<String>(json['title']),
  message = nativeFromJson<String>(json['message']),
  targetCountry = json['targetCountry'] == null ? null : nativeFromJson<String>(json['targetCountry']),
  targetRegion = json['targetRegion'] == null ? null : nativeFromJson<String>(json['targetRegion']),
  targetCity = json['targetCity'] == null ? null : nativeFromJson<String>(json['targetCity']),
  targetRole = json['targetRole'] == null ? null : userRoleDeserializer(json['targetRole']),
  createdAt = Timestamp.fromJson(json['createdAt']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListActiveBroadcastsBroadcasts otherTyped = other as ListActiveBroadcastsBroadcasts;
    return id == otherTyped.id && 
    title == otherTyped.title && 
    message == otherTyped.message && 
    targetCountry == otherTyped.targetCountry && 
    targetRegion == otherTyped.targetRegion && 
    targetCity == otherTyped.targetCity && 
    targetRole == otherTyped.targetRole && 
    createdAt == otherTyped.createdAt;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, title.hashCode, message.hashCode, targetCountry.hashCode, targetRegion.hashCode, targetCity.hashCode, targetRole.hashCode, createdAt.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['title'] = nativeToJson<String>(title);
    json['message'] = nativeToJson<String>(message);
    if (targetCountry != null) {
      json['targetCountry'] = nativeToJson<String?>(targetCountry);
    }
    if (targetRegion != null) {
      json['targetRegion'] = nativeToJson<String?>(targetRegion);
    }
    if (targetCity != null) {
      json['targetCity'] = nativeToJson<String?>(targetCity);
    }
    if (targetRole != null) {
      json['targetRole'] = 
    userRoleSerializer(targetRole!)
    ;
    }
    json['createdAt'] = createdAt.toJson();
    return json;
  }

  ListActiveBroadcastsBroadcasts({
    required this.id,
    required this.title,
    required this.message,
    this.targetCountry,
    this.targetRegion,
    this.targetCity,
    this.targetRole,
    required this.createdAt,
  });
}

@immutable
class ListActiveBroadcastsData {
  final List<ListActiveBroadcastsBroadcasts> broadcasts;
  ListActiveBroadcastsData.fromJson(dynamic json):
  
  broadcasts = (json['broadcasts'] as List<dynamic>)
        .map((e) => ListActiveBroadcastsBroadcasts.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListActiveBroadcastsData otherTyped = other as ListActiveBroadcastsData;
    return broadcasts == otherTyped.broadcasts;
    
  }
  @override
  int get hashCode => broadcasts.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['broadcasts'] = broadcasts.map((e) => e.toJson()).toList();
    return json;
  }

  ListActiveBroadcastsData({
    required this.broadcasts,
  });
}

@immutable
class ListActiveBroadcastsVariables {
  late final Optional<String>country;
  late final Optional<UserRole>role;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ListActiveBroadcastsVariables.fromJson(Map<String, dynamic> json) {
  
  
    country = Optional.optional(nativeFromJson, nativeToJson);
    country.value = json['country'] == null ? null : nativeFromJson<String>(json['country']);
  
  
    role = Optional.optional((data) => UserRole.values.byName(data), enumSerializer);
    role.value = json['role'] == null ? null : UserRole.values.byName(json['role']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListActiveBroadcastsVariables otherTyped = other as ListActiveBroadcastsVariables;
    return country == otherTyped.country && 
    role == otherTyped.role;
    
  }
  @override
  int get hashCode => Object.hashAll([country.hashCode, role.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if(country.state == OptionalState.set) {
      json['country'] = country.toJson();
    }
    if(role.state == OptionalState.set) {
      json['role'] = role.toJson();
    }
    return json;
  }

  ListActiveBroadcastsVariables({
    required this.country,
    required this.role,
  });
}

