part of 'espy.dart';

class UpdateServiceVariablesBuilder {
  String id;
  Optional<bool> _isActive = Optional.optional(nativeFromJson, nativeToJson);
  Optional<bool> _isAllocated = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;  UpdateServiceVariablesBuilder isActive(bool? t) {
   _isActive.value = t;
   return this;
  }
  UpdateServiceVariablesBuilder isAllocated(bool? t) {
   _isAllocated.value = t;
   return this;
  }

  UpdateServiceVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<UpdateServiceData> dataDeserializer = (dynamic json)  => UpdateServiceData.fromJson(jsonDecode(json));
  Serializer<UpdateServiceVariables> varsSerializer = (UpdateServiceVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpdateServiceData, UpdateServiceVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpdateServiceData, UpdateServiceVariables> ref() {
    UpdateServiceVariables vars= UpdateServiceVariables(id: id,isActive: _isActive,isAllocated: _isAllocated,);
    return _dataConnect.mutation("UpdateService", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpdateServiceServiceUpdate {
  final String id;
  UpdateServiceServiceUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateServiceServiceUpdate otherTyped = other as UpdateServiceServiceUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpdateServiceServiceUpdate({
    required this.id,
  });
}

@immutable
class UpdateServiceData {
  final UpdateServiceServiceUpdate? service_update;
  UpdateServiceData.fromJson(dynamic json):
  
  service_update = json['service_update'] == null ? null : UpdateServiceServiceUpdate.fromJson(json['service_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateServiceData otherTyped = other as UpdateServiceData;
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

  UpdateServiceData({
    this.service_update,
  });
}

@immutable
class UpdateServiceVariables {
  final String id;
  late final Optional<bool>isActive;
  late final Optional<bool>isAllocated;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpdateServiceVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']) {
  
  
  
    isActive = Optional.optional(nativeFromJson, nativeToJson);
    isActive.value = json['isActive'] == null ? null : nativeFromJson<bool>(json['isActive']);
  
  
    isAllocated = Optional.optional(nativeFromJson, nativeToJson);
    isAllocated.value = json['isAllocated'] == null ? null : nativeFromJson<bool>(json['isAllocated']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateServiceVariables otherTyped = other as UpdateServiceVariables;
    return id == otherTyped.id && 
    isActive == otherTyped.isActive && 
    isAllocated == otherTyped.isAllocated;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, isActive.hashCode, isAllocated.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    if(isActive.state == OptionalState.set) {
      json['isActive'] = isActive.toJson();
    }
    if(isAllocated.state == OptionalState.set) {
      json['isAllocated'] = isAllocated.toJson();
    }
    return json;
  }

  UpdateServiceVariables({
    required this.id,
    required this.isActive,
    required this.isAllocated,
  });
}

