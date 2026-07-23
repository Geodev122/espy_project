part of 'espy.dart';

class ModerateRequestVariablesBuilder {
  String id;
  ModerationStatus status;
  Optional<String> _reason = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;  ModerateRequestVariablesBuilder reason(String? t) {
   _reason.value = t;
   return this;
  }

  ModerateRequestVariablesBuilder(this._dataConnect, {required  this.id,required  this.status,});
  Deserializer<ModerateRequestData> dataDeserializer = (dynamic json)  => ModerateRequestData.fromJson(jsonDecode(json));
  Serializer<ModerateRequestVariables> varsSerializer = (ModerateRequestVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<ModerateRequestData, ModerateRequestVariables>> execute() {
    return ref().execute();
  }

  MutationRef<ModerateRequestData, ModerateRequestVariables> ref() {
    ModerateRequestVariables vars= ModerateRequestVariables(id: id,status: status,reason: _reason,);
    return _dataConnect.mutation("ModerateRequest", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ModerateRequestServiceRequestUpdate {
  final String id;
  ModerateRequestServiceRequestUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ModerateRequestServiceRequestUpdate otherTyped = other as ModerateRequestServiceRequestUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  ModerateRequestServiceRequestUpdate({
    required this.id,
  });
}

@immutable
class ModerateRequestData {
  final ModerateRequestServiceRequestUpdate? serviceRequest_update;
  ModerateRequestData.fromJson(dynamic json):
  
  serviceRequest_update = json['serviceRequest_update'] == null ? null : ModerateRequestServiceRequestUpdate.fromJson(json['serviceRequest_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ModerateRequestData otherTyped = other as ModerateRequestData;
    return serviceRequest_update == otherTyped.serviceRequest_update;
    
  }
  @override
  int get hashCode => serviceRequest_update.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (serviceRequest_update != null) {
      json['serviceRequest_update'] = serviceRequest_update!.toJson();
    }
    return json;
  }

  ModerateRequestData({
    this.serviceRequest_update,
  });
}

@immutable
class ModerateRequestVariables {
  final String id;
  final ModerationStatus status;
  late final Optional<String>reason;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ModerateRequestVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']),
  status = ModerationStatus.values.byName(json['status']) {
  
  
  
  
    reason = Optional.optional(nativeFromJson, nativeToJson);
    reason.value = json['reason'] == null ? null : nativeFromJson<String>(json['reason']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ModerateRequestVariables otherTyped = other as ModerateRequestVariables;
    return id == otherTyped.id && 
    status == otherTyped.status && 
    reason == otherTyped.reason;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, status.hashCode, reason.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['status'] = 
    status.name
    ;
    if(reason.state == OptionalState.set) {
      json['reason'] = reason.toJson();
    }
    return json;
  }

  ModerateRequestVariables({
    required this.id,
    required this.status,
    required this.reason,
  });
}

