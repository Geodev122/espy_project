part of 'espy.dart';

class PostServiceRequestVariablesBuilder {
  String sectorId;
  String descriptionEn;
  Optional<UrgencyLevel> _urgency = Optional.optional((data) => UrgencyLevel.values.byName(data), enumSerializer);
  Optional<DeliveryMode> _preferredMode = Optional.optional((data) => DeliveryMode.values.byName(data), enumSerializer);

  final FirebaseDataConnect _dataConnect;  PostServiceRequestVariablesBuilder urgency(UrgencyLevel? t) {
   _urgency.value = t;
   return this;
  }
  PostServiceRequestVariablesBuilder preferredMode(DeliveryMode? t) {
   _preferredMode.value = t;
   return this;
  }

  PostServiceRequestVariablesBuilder(this._dataConnect, {required  this.sectorId,required  this.descriptionEn,});
  Deserializer<PostServiceRequestData> dataDeserializer = (dynamic json)  => PostServiceRequestData.fromJson(jsonDecode(json));
  Serializer<PostServiceRequestVariables> varsSerializer = (PostServiceRequestVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<PostServiceRequestData, PostServiceRequestVariables>> execute() {
    return ref().execute();
  }

  MutationRef<PostServiceRequestData, PostServiceRequestVariables> ref() {
    PostServiceRequestVariables vars= PostServiceRequestVariables(sectorId: sectorId,descriptionEn: descriptionEn,urgency: _urgency,preferredMode: _preferredMode,);
    return _dataConnect.mutation("PostServiceRequest", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class PostServiceRequestServiceRequestInsert {
  final String id;
  PostServiceRequestServiceRequestInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final PostServiceRequestServiceRequestInsert otherTyped = other as PostServiceRequestServiceRequestInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  PostServiceRequestServiceRequestInsert({
    required this.id,
  });
}

@immutable
class PostServiceRequestData {
  final PostServiceRequestServiceRequestInsert serviceRequest_insert;
  PostServiceRequestData.fromJson(dynamic json):
  
  serviceRequest_insert = PostServiceRequestServiceRequestInsert.fromJson(json['serviceRequest_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final PostServiceRequestData otherTyped = other as PostServiceRequestData;
    return serviceRequest_insert == otherTyped.serviceRequest_insert;
    
  }
  @override
  int get hashCode => serviceRequest_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['serviceRequest_insert'] = serviceRequest_insert.toJson();
    return json;
  }

  PostServiceRequestData({
    required this.serviceRequest_insert,
  });
}

@immutable
class PostServiceRequestVariables {
  final String sectorId;
  final String descriptionEn;
  late final Optional<UrgencyLevel>urgency;
  late final Optional<DeliveryMode>preferredMode;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  PostServiceRequestVariables.fromJson(Map<String, dynamic> json):
  
  sectorId = nativeFromJson<String>(json['sectorId']),
  descriptionEn = nativeFromJson<String>(json['descriptionEn']) {
  
  
  
  
    urgency = Optional.optional((data) => UrgencyLevel.values.byName(data), enumSerializer);
    urgency.value = json['urgency'] == null ? null : UrgencyLevel.values.byName(json['urgency']);
  
  
    preferredMode = Optional.optional((data) => DeliveryMode.values.byName(data), enumSerializer);
    preferredMode.value = json['preferredMode'] == null ? null : DeliveryMode.values.byName(json['preferredMode']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final PostServiceRequestVariables otherTyped = other as PostServiceRequestVariables;
    return sectorId == otherTyped.sectorId && 
    descriptionEn == otherTyped.descriptionEn && 
    urgency == otherTyped.urgency && 
    preferredMode == otherTyped.preferredMode;
    
  }
  @override
  int get hashCode => Object.hashAll([sectorId.hashCode, descriptionEn.hashCode, urgency.hashCode, preferredMode.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['sectorId'] = nativeToJson<String>(sectorId);
    json['descriptionEn'] = nativeToJson<String>(descriptionEn);
    if(urgency.state == OptionalState.set) {
      json['urgency'] = urgency.toJson();
    }
    if(preferredMode.state == OptionalState.set) {
      json['preferredMode'] = preferredMode.toJson();
    }
    return json;
  }

  PostServiceRequestVariables({
    required this.sectorId,
    required this.descriptionEn,
    required this.urgency,
    required this.preferredMode,
  });
}

