part of 'espy.dart';

class ListRequestModerationQueueVariablesBuilder {
  Optional<ModerationStatus> _status = Optional.optional((data) => ModerationStatus.values.byName(data), enumSerializer);

  final FirebaseDataConnect _dataConnect;
  ListRequestModerationQueueVariablesBuilder status(ModerationStatus? t) {
   _status.value = t;
   return this;
  }

  ListRequestModerationQueueVariablesBuilder(this._dataConnect, );
  Deserializer<ListRequestModerationQueueData> dataDeserializer = (dynamic json)  => ListRequestModerationQueueData.fromJson(jsonDecode(json));
  Serializer<ListRequestModerationQueueVariables> varsSerializer = (ListRequestModerationQueueVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<ListRequestModerationQueueData, ListRequestModerationQueueVariables>> execute() {
    return ref().execute();
  }

  QueryRef<ListRequestModerationQueueData, ListRequestModerationQueueVariables> ref() {
    ListRequestModerationQueueVariables vars= ListRequestModerationQueueVariables(status: _status,);
    return _dataConnect.query("ListRequestModerationQueue", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ListRequestModerationQueueServiceRequests {
  final String id;
  final String descriptionEn;
  final String? descriptionAr;
  final EnumValue<UrgencyLevel>? urgency;
  final EnumValue<DeliveryMode>? preferredMode;
  final EnumValue<CommunityRequestStatus> status;
  final EnumValue<ModerationStatus> moderationStatus;
  final String? flagReason;
  final Timestamp createdAt;
  final ListRequestModerationQueueServiceRequestsSector sector;
  final ListRequestModerationQueueServiceRequestsUser user;
  ListRequestModerationQueueServiceRequests.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  descriptionEn = nativeFromJson<String>(json['descriptionEn']),
  descriptionAr = json['descriptionAr'] == null ? null : nativeFromJson<String>(json['descriptionAr']),
  urgency = json['urgency'] == null ? null : urgencyLevelDeserializer(json['urgency']),
  preferredMode = json['preferredMode'] == null ? null : deliveryModeDeserializer(json['preferredMode']),
  status = communityRequestStatusDeserializer(json['status']),
  moderationStatus = moderationStatusDeserializer(json['moderationStatus']),
  flagReason = json['flagReason'] == null ? null : nativeFromJson<String>(json['flagReason']),
  createdAt = Timestamp.fromJson(json['createdAt']),
  sector = ListRequestModerationQueueServiceRequestsSector.fromJson(json['sector']),
  user = ListRequestModerationQueueServiceRequestsUser.fromJson(json['user']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListRequestModerationQueueServiceRequests otherTyped = other as ListRequestModerationQueueServiceRequests;
    return id == otherTyped.id && 
    descriptionEn == otherTyped.descriptionEn && 
    descriptionAr == otherTyped.descriptionAr && 
    urgency == otherTyped.urgency && 
    preferredMode == otherTyped.preferredMode && 
    status == otherTyped.status && 
    moderationStatus == otherTyped.moderationStatus && 
    flagReason == otherTyped.flagReason && 
    createdAt == otherTyped.createdAt && 
    sector == otherTyped.sector && 
    user == otherTyped.user;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, descriptionEn.hashCode, descriptionAr.hashCode, urgency.hashCode, preferredMode.hashCode, status.hashCode, moderationStatus.hashCode, flagReason.hashCode, createdAt.hashCode, sector.hashCode, user.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['descriptionEn'] = nativeToJson<String>(descriptionEn);
    if (descriptionAr != null) {
      json['descriptionAr'] = nativeToJson<String?>(descriptionAr);
    }
    if (urgency != null) {
      json['urgency'] = 
    urgencyLevelSerializer(urgency!)
    ;
    }
    if (preferredMode != null) {
      json['preferredMode'] = 
    deliveryModeSerializer(preferredMode!)
    ;
    }
    json['status'] = 
    communityRequestStatusSerializer(status)
    ;
    json['moderationStatus'] = 
    moderationStatusSerializer(moderationStatus)
    ;
    if (flagReason != null) {
      json['flagReason'] = nativeToJson<String?>(flagReason);
    }
    json['createdAt'] = createdAt.toJson();
    json['sector'] = sector.toJson();
    json['user'] = user.toJson();
    return json;
  }

  ListRequestModerationQueueServiceRequests({
    required this.id,
    required this.descriptionEn,
    this.descriptionAr,
    this.urgency,
    this.preferredMode,
    required this.status,
    required this.moderationStatus,
    this.flagReason,
    required this.createdAt,
    required this.sector,
    required this.user,
  });
}

@immutable
class ListRequestModerationQueueServiceRequestsSector {
  final String nameEn;
  final String? nameAr;
  ListRequestModerationQueueServiceRequestsSector.fromJson(dynamic json):
  
  nameEn = nativeFromJson<String>(json['nameEn']),
  nameAr = json['nameAr'] == null ? null : nativeFromJson<String>(json['nameAr']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListRequestModerationQueueServiceRequestsSector otherTyped = other as ListRequestModerationQueueServiceRequestsSector;
    return nameEn == otherTyped.nameEn && 
    nameAr == otherTyped.nameAr;
    
  }
  @override
  int get hashCode => Object.hashAll([nameEn.hashCode, nameAr.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['nameEn'] = nativeToJson<String>(nameEn);
    if (nameAr != null) {
      json['nameAr'] = nativeToJson<String?>(nameAr);
    }
    return json;
  }

  ListRequestModerationQueueServiceRequestsSector({
    required this.nameEn,
    this.nameAr,
  });
}

@immutable
class ListRequestModerationQueueServiceRequestsUser {
  final String id;
  final String? name;
  final String email;
  ListRequestModerationQueueServiceRequestsUser.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  name = json['name'] == null ? null : nativeFromJson<String>(json['name']),
  email = nativeFromJson<String>(json['email']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListRequestModerationQueueServiceRequestsUser otherTyped = other as ListRequestModerationQueueServiceRequestsUser;
    return id == otherTyped.id && 
    name == otherTyped.name && 
    email == otherTyped.email;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, name.hashCode, email.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    if (name != null) {
      json['name'] = nativeToJson<String?>(name);
    }
    json['email'] = nativeToJson<String>(email);
    return json;
  }

  ListRequestModerationQueueServiceRequestsUser({
    required this.id,
    this.name,
    required this.email,
  });
}

@immutable
class ListRequestModerationQueueData {
  final List<ListRequestModerationQueueServiceRequests> serviceRequests;
  ListRequestModerationQueueData.fromJson(dynamic json):
  
  serviceRequests = (json['serviceRequests'] as List<dynamic>)
        .map((e) => ListRequestModerationQueueServiceRequests.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListRequestModerationQueueData otherTyped = other as ListRequestModerationQueueData;
    return serviceRequests == otherTyped.serviceRequests;
    
  }
  @override
  int get hashCode => serviceRequests.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['serviceRequests'] = serviceRequests.map((e) => e.toJson()).toList();
    return json;
  }

  ListRequestModerationQueueData({
    required this.serviceRequests,
  });
}

@immutable
class ListRequestModerationQueueVariables {
  late final Optional<ModerationStatus>status;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ListRequestModerationQueueVariables.fromJson(Map<String, dynamic> json) {
  
  
    status = Optional.optional((data) => ModerationStatus.values.byName(data), enumSerializer);
    status.value = json['status'] == null ? null : ModerationStatus.values.byName(json['status']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListRequestModerationQueueVariables otherTyped = other as ListRequestModerationQueueVariables;
    return status == otherTyped.status;
    
  }
  @override
  int get hashCode => status.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if(status.state == OptionalState.set) {
      json['status'] = status.toJson();
    }
    return json;
  }

  ListRequestModerationQueueVariables({
    required this.status,
  });
}

