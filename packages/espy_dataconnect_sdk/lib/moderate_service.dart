part of 'espy.dart';

class ModerateServiceVariablesBuilder {
  String id;
  ModerationStatus status;
  Optional<String> _reason = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;  ModerateServiceVariablesBuilder reason(String? t) {
   _reason.value = t;
   return this;
  }

  ModerateServiceVariablesBuilder(this._dataConnect, {required  this.id,required  this.status,});
  Deserializer<ModerateServiceData> dataDeserializer = (dynamic json)  => ModerateServiceData.fromJson(jsonDecode(json));
  Serializer<ModerateServiceVariables> varsSerializer = (ModerateServiceVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<ModerateServiceData, ModerateServiceVariables>> execute() {
    return ref().execute();
  }

  MutationRef<ModerateServiceData, ModerateServiceVariables> ref() {
    ModerateServiceVariables vars= ModerateServiceVariables(id: id,status: status,reason: _reason,);
    return _dataConnect.mutation("ModerateService", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ModerateServiceServiceUpdate {
  final String id;
  ModerateServiceServiceUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ModerateServiceServiceUpdate otherTyped = other as ModerateServiceServiceUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  ModerateServiceServiceUpdate({
    required this.id,
  });
}

@immutable
class ModerateServiceData {
  final ModerateServiceServiceUpdate? service_update;
  ModerateServiceData.fromJson(dynamic json):
  
  service_update = json['service_update'] == null ? null : ModerateServiceServiceUpdate.fromJson(json['service_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ModerateServiceData otherTyped = other as ModerateServiceData;
    return service_update == otherTyped.service_update;
    
  }
  @override
  int get hashCode => service_update.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (service_update != null) {
      json['service_update'] = service_update!.toJson();
    }
    return json;
  }

  ModerateServiceData({
    this.service_update,
  });
}

@immutable
class ModerateServiceVariables {
  final String id;
  final ModerationStatus status;
  late final Optional<String>reason;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ModerateServiceVariables.fromJson(Map<String, dynamic> json):
  
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

    final ModerateServiceVariables otherTyped = other as ModerateServiceVariables;
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

  ModerateServiceVariables({
    required this.id,
    required this.status,
    required this.reason,
  });
}

