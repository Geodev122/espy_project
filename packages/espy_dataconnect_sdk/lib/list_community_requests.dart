part of 'espy.dart';

class ListCommunityRequestsVariablesBuilder {
  Optional<String> _sectorId = Optional.optional(nativeFromJson, nativeToJson);
  Optional<CommunityRequestStatus> _status = Optional.optional((data) => CommunityRequestStatus.values.byName(data), enumSerializer);

  final FirebaseDataConnect _dataConnect;
  ListCommunityRequestsVariablesBuilder sectorId(String? t) {
   _sectorId.value = t;
   return this;
  }
  ListCommunityRequestsVariablesBuilder status(CommunityRequestStatus? t) {
   _status.value = t;
   return this;
  }

  ListCommunityRequestsVariablesBuilder(this._dataConnect, );
  Deserializer<ListCommunityRequestsData> dataDeserializer = (dynamic json)  => ListCommunityRequestsData.fromJson(jsonDecode(json));
  Serializer<ListCommunityRequestsVariables> varsSerializer = (ListCommunityRequestsVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<ListCommunityRequestsData, ListCommunityRequestsVariables>> execute() {
    return ref().execute();
  }

  QueryRef<ListCommunityRequestsData, ListCommunityRequestsVariables> ref() {
    ListCommunityRequestsVariables vars= ListCommunityRequestsVariables(sectorId: _sectorId,status: _status,);
    return _dataConnect.query("ListCommunityRequests", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ListCommunityRequestsCommunityRequests {
  final String id;
  final String title;
  final String description;
  final String? locationLabel;
  final EnumValue<CommunityRequestStatus> status;
  final Timestamp createdAt;
  final ListCommunityRequestsCommunityRequestsUser user;
  ListCommunityRequestsCommunityRequests.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  title = nativeFromJson<String>(json['title']),
  description = nativeFromJson<String>(json['description']),
  locationLabel = json['locationLabel'] == null ? null : nativeFromJson<String>(json['locationLabel']),
  status = communityRequestStatusDeserializer(json['status']),
  createdAt = Timestamp.fromJson(json['createdAt']),
  user = ListCommunityRequestsCommunityRequestsUser.fromJson(json['user']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListCommunityRequestsCommunityRequests otherTyped = other as ListCommunityRequestsCommunityRequests;
    return id == otherTyped.id && 
    title == otherTyped.title && 
    description == otherTyped.description && 
    locationLabel == otherTyped.locationLabel && 
    status == otherTyped.status && 
    createdAt == otherTyped.createdAt && 
    user == otherTyped.user;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, title.hashCode, description.hashCode, locationLabel.hashCode, status.hashCode, createdAt.hashCode, user.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['title'] = nativeToJson<String>(title);
    json['description'] = nativeToJson<String>(description);
    if (locationLabel != null) {
      json['locationLabel'] = nativeToJson<String?>(locationLabel);
    }
    json['status'] = 
    communityRequestStatusSerializer(status)
    ;
    json['createdAt'] = createdAt.toJson();
    json['user'] = user.toJson();
    return json;
  }

  ListCommunityRequestsCommunityRequests({
    required this.id,
    required this.title,
    required this.description,
    this.locationLabel,
    required this.status,
    required this.createdAt,
    required this.user,
  });
}

@immutable
class ListCommunityRequestsCommunityRequestsUser {
  final String? name;
  ListCommunityRequestsCommunityRequestsUser.fromJson(dynamic json):
  
  name = json['name'] == null ? null : nativeFromJson<String>(json['name']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListCommunityRequestsCommunityRequestsUser otherTyped = other as ListCommunityRequestsCommunityRequestsUser;
    return name == otherTyped.name;
    
  }
  @override
  int get hashCode => name.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (name != null) {
      json['name'] = nativeToJson<String?>(name);
    }
    return json;
  }

  ListCommunityRequestsCommunityRequestsUser({
    this.name,
  });
}

@immutable
class ListCommunityRequestsData {
  final List<ListCommunityRequestsCommunityRequests> communityRequests;
  ListCommunityRequestsData.fromJson(dynamic json):
  
  communityRequests = (json['communityRequests'] as List<dynamic>)
        .map((e) => ListCommunityRequestsCommunityRequests.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListCommunityRequestsData otherTyped = other as ListCommunityRequestsData;
    return communityRequests == otherTyped.communityRequests;
    
  }
  @override
  int get hashCode => communityRequests.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['communityRequests'] = communityRequests.map((e) => e.toJson()).toList();
    return json;
  }

  ListCommunityRequestsData({
    required this.communityRequests,
  });
}

@immutable
class ListCommunityRequestsVariables {
  late final Optional<String>sectorId;
  late final Optional<CommunityRequestStatus>status;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ListCommunityRequestsVariables.fromJson(Map<String, dynamic> json) {
  
  
    sectorId = Optional.optional(nativeFromJson, nativeToJson);
    sectorId.value = json['sectorId'] == null ? null : nativeFromJson<String>(json['sectorId']);
  
  
    status = Optional.optional((data) => CommunityRequestStatus.values.byName(data), enumSerializer);
    status.value = json['status'] == null ? null : CommunityRequestStatus.values.byName(json['status']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListCommunityRequestsVariables otherTyped = other as ListCommunityRequestsVariables;
    return sectorId == otherTyped.sectorId && 
    status == otherTyped.status;
    
  }
  @override
  int get hashCode => Object.hashAll([sectorId.hashCode, status.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if(sectorId.state == OptionalState.set) {
      json['sectorId'] = sectorId.toJson();
    }
    if(status.state == OptionalState.set) {
      json['status'] = status.toJson();
    }
    return json;
  }

  ListCommunityRequestsVariables({
    required this.sectorId,
    required this.status,
  });
}

