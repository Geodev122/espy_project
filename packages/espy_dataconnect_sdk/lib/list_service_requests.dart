part of 'espy.dart';

class ListServiceRequestsVariablesBuilder {
  Optional<String> _sectorId = Optional.optional(nativeFromJson, nativeToJson);
  Optional<CommunityRequestStatus> _status = Optional.optional((data) => CommunityRequestStatus.values.byName(data), enumSerializer);

  final FirebaseDataConnect _dataConnect;
  ListServiceRequestsVariablesBuilder sectorId(String? t) {
   _sectorId.value = t;
   return this;
  }
  ListServiceRequestsVariablesBuilder status(CommunityRequestStatus? t) {
   _status.value = t;
   return this;
  }

  ListServiceRequestsVariablesBuilder(this._dataConnect, );
  Deserializer<ListServiceRequestsData> dataDeserializer = (dynamic json)  => ListServiceRequestsData.fromJson(jsonDecode(json));
  Serializer<ListServiceRequestsVariables> varsSerializer = (ListServiceRequestsVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<ListServiceRequestsData, ListServiceRequestsVariables>> execute() {
    return ref().execute();
  }

  QueryRef<ListServiceRequestsData, ListServiceRequestsVariables> ref() {
    ListServiceRequestsVariables vars= ListServiceRequestsVariables(sectorId: _sectorId,status: _status,);
    return _dataConnect.query("ListServiceRequests", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ListServiceRequestsServiceRequests {
  final String id;
  final String descriptionEn;
  final String? descriptionAr;
  final EnumValue<UrgencyLevel>? urgency;
  final EnumValue<DeliveryMode>? preferredMode;
  final EnumValue<CommunityRequestStatus> status;
  final Timestamp createdAt;
  final ListServiceRequestsServiceRequestsUser user;
  final ListServiceRequestsServiceRequestsSector sector;
  final List<ListServiceRequestsServiceRequestsServiceRequestTagsOnRequest> serviceRequestTags_on_request;
  ListServiceRequestsServiceRequests.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  descriptionEn = nativeFromJson<String>(json['descriptionEn']),
  descriptionAr = json['descriptionAr'] == null ? null : nativeFromJson<String>(json['descriptionAr']),
  urgency = json['urgency'] == null ? null : urgencyLevelDeserializer(json['urgency']),
  preferredMode = json['preferredMode'] == null ? null : deliveryModeDeserializer(json['preferredMode']),
  status = communityRequestStatusDeserializer(json['status']),
  createdAt = Timestamp.fromJson(json['createdAt']),
  user = ListServiceRequestsServiceRequestsUser.fromJson(json['user']),
  sector = ListServiceRequestsServiceRequestsSector.fromJson(json['sector']),
  serviceRequestTags_on_request = (json['serviceRequestTags_on_request'] as List<dynamic>)
        .map((e) => ListServiceRequestsServiceRequestsServiceRequestTagsOnRequest.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListServiceRequestsServiceRequests otherTyped = other as ListServiceRequestsServiceRequests;
    return id == otherTyped.id && 
    descriptionEn == otherTyped.descriptionEn && 
    descriptionAr == otherTyped.descriptionAr && 
    urgency == otherTyped.urgency && 
    preferredMode == otherTyped.preferredMode && 
    status == otherTyped.status && 
    createdAt == otherTyped.createdAt && 
    user == otherTyped.user && 
    sector == otherTyped.sector && 
    serviceRequestTags_on_request == otherTyped.serviceRequestTags_on_request;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, descriptionEn.hashCode, descriptionAr.hashCode, urgency.hashCode, preferredMode.hashCode, status.hashCode, createdAt.hashCode, user.hashCode, sector.hashCode, serviceRequestTags_on_request.hashCode]);
  

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
    json['createdAt'] = createdAt.toJson();
    json['user'] = user.toJson();
    json['sector'] = sector.toJson();
    json['serviceRequestTags_on_request'] = serviceRequestTags_on_request.map((e) => e.toJson()).toList();
    return json;
  }

  ListServiceRequestsServiceRequests({
    required this.id,
    required this.descriptionEn,
    this.descriptionAr,
    this.urgency,
    this.preferredMode,
    required this.status,
    required this.createdAt,
    required this.user,
    required this.sector,
    required this.serviceRequestTags_on_request,
  });
}

@immutable
class ListServiceRequestsServiceRequestsUser {
  final String? name;
  ListServiceRequestsServiceRequestsUser.fromJson(dynamic json):
  
  name = json['name'] == null ? null : nativeFromJson<String>(json['name']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListServiceRequestsServiceRequestsUser otherTyped = other as ListServiceRequestsServiceRequestsUser;
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

  ListServiceRequestsServiceRequestsUser({
    this.name,
  });
}

@immutable
class ListServiceRequestsServiceRequestsSector {
  final ListServiceRequestsServiceRequestsSectorTemplate? template;
  ListServiceRequestsServiceRequestsSector.fromJson(dynamic json):
  
  template = json['template'] == null ? null : ListServiceRequestsServiceRequestsSectorTemplate.fromJson(json['template']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListServiceRequestsServiceRequestsSector otherTyped = other as ListServiceRequestsServiceRequestsSector;
    return template == otherTyped.template;
    
  }
  @override
  int get hashCode => template.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (template != null) {
      json['template'] = template!.toJson();
    }
    return json;
  }

  ListServiceRequestsServiceRequestsSector({
    this.template,
  });
}

@immutable
class ListServiceRequestsServiceRequestsSectorTemplate {
  final String? accentColor;
  final String? iconName;
  final List<String>? visibleFields;
  ListServiceRequestsServiceRequestsSectorTemplate.fromJson(dynamic json):
  
  accentColor = json['accentColor'] == null ? null : nativeFromJson<String>(json['accentColor']),
  iconName = json['iconName'] == null ? null : nativeFromJson<String>(json['iconName']),
  visibleFields = json['visibleFields'] == null ? null : (json['visibleFields'] as List<dynamic>)
        .map((e) => nativeFromJson<String>(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListServiceRequestsServiceRequestsSectorTemplate otherTyped = other as ListServiceRequestsServiceRequestsSectorTemplate;
    return accentColor == otherTyped.accentColor && 
    iconName == otherTyped.iconName && 
    visibleFields == otherTyped.visibleFields;
    
  }
  @override
  int get hashCode => Object.hashAll([accentColor.hashCode, iconName.hashCode, visibleFields.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (accentColor != null) {
      json['accentColor'] = nativeToJson<String?>(accentColor);
    }
    if (iconName != null) {
      json['iconName'] = nativeToJson<String?>(iconName);
    }
    if (visibleFields != null) {
      json['visibleFields'] = visibleFields?.map((e) => nativeToJson<String>(e)).toList();
    }
    return json;
  }

  ListServiceRequestsServiceRequestsSectorTemplate({
    this.accentColor,
    this.iconName,
    this.visibleFields,
  });
}

@immutable
class ListServiceRequestsServiceRequestsServiceRequestTagsOnRequest {
  final ListServiceRequestsServiceRequestsServiceRequestTagsOnRequestTag tag;
  ListServiceRequestsServiceRequestsServiceRequestTagsOnRequest.fromJson(dynamic json):
  
  tag = ListServiceRequestsServiceRequestsServiceRequestTagsOnRequestTag.fromJson(json['tag']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListServiceRequestsServiceRequestsServiceRequestTagsOnRequest otherTyped = other as ListServiceRequestsServiceRequestsServiceRequestTagsOnRequest;
    return tag == otherTyped.tag;
    
  }
  @override
  int get hashCode => tag.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['tag'] = tag.toJson();
    return json;
  }

  ListServiceRequestsServiceRequestsServiceRequestTagsOnRequest({
    required this.tag,
  });
}

@immutable
class ListServiceRequestsServiceRequestsServiceRequestTagsOnRequestTag {
  final String nameEn;
  final String? nameAr;
  ListServiceRequestsServiceRequestsServiceRequestTagsOnRequestTag.fromJson(dynamic json):
  
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

    final ListServiceRequestsServiceRequestsServiceRequestTagsOnRequestTag otherTyped = other as ListServiceRequestsServiceRequestsServiceRequestTagsOnRequestTag;
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

  ListServiceRequestsServiceRequestsServiceRequestTagsOnRequestTag({
    required this.nameEn,
    this.nameAr,
  });
}

@immutable
class ListServiceRequestsData {
  final List<ListServiceRequestsServiceRequests> serviceRequests;
  ListServiceRequestsData.fromJson(dynamic json):
  
  serviceRequests = (json['serviceRequests'] as List<dynamic>)
        .map((e) => ListServiceRequestsServiceRequests.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListServiceRequestsData otherTyped = other as ListServiceRequestsData;
    return serviceRequests == otherTyped.serviceRequests;
    
  }
  @override
  int get hashCode => serviceRequests.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['serviceRequests'] = serviceRequests.map((e) => e.toJson()).toList();
    return json;
  }

  ListServiceRequestsData({
    required this.serviceRequests,
  });
}

@immutable
class ListServiceRequestsVariables {
  late final Optional<String>sectorId;
  late final Optional<CommunityRequestStatus>status;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ListServiceRequestsVariables.fromJson(Map<String, dynamic> json) {
  
  
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

    final ListServiceRequestsVariables otherTyped = other as ListServiceRequestsVariables;
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

  ListServiceRequestsVariables({
    required this.sectorId,
    required this.status,
  });
}

