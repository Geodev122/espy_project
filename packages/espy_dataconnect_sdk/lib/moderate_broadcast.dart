part of 'espy.dart';

class ModerateBroadcastVariablesBuilder {
  String id;
  ModerationStatus status;
  Optional<String> _reason = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;  ModerateBroadcastVariablesBuilder reason(String? t) {
   _reason.value = t;
   return this;
  }

  ModerateBroadcastVariablesBuilder(this._dataConnect, {required  this.id,required  this.status,});
  Deserializer<ModerateBroadcastData> dataDeserializer = (dynamic json)  => ModerateBroadcastData.fromJson(jsonDecode(json));
  Serializer<ModerateBroadcastVariables> varsSerializer = (ModerateBroadcastVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<ModerateBroadcastData, ModerateBroadcastVariables>> execute() {
    return ref().execute();
  }

  MutationRef<ModerateBroadcastData, ModerateBroadcastVariables> ref() {
    ModerateBroadcastVariables vars= ModerateBroadcastVariables(id: id,status: status,reason: _reason,);
    return _dataConnect.mutation("ModerateBroadcast", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ModerateBroadcastBroadcastUpdate {
  final String id;
  ModerateBroadcastBroadcastUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ModerateBroadcastBroadcastUpdate otherTyped = other as ModerateBroadcastBroadcastUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  ModerateBroadcastBroadcastUpdate({
    required this.id,
  });
}

@immutable
class ModerateBroadcastData {
  final ModerateBroadcastBroadcastUpdate? broadcast_update;
  ModerateBroadcastData.fromJson(dynamic json):
  
  broadcast_update = json['broadcast_update'] == null ? null : ModerateBroadcastBroadcastUpdate.fromJson(json['broadcast_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ModerateBroadcastData otherTyped = other as ModerateBroadcastData;
    return broadcast_update == otherTyped.broadcast_update;
    
  }
  @override
  int get hashCode => broadcast_update.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (broadcast_update != null) {
      json['broadcast_update'] = broadcast_update!.toJson();
    }
    return json;
  }

  ModerateBroadcastData({
    this.broadcast_update,
  });
}

@immutable
class ModerateBroadcastVariables {
  final String id;
  final ModerationStatus status;
  late final Optional<String>reason;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ModerateBroadcastVariables.fromJson(Map<String, dynamic> json):
  
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

    final ModerateBroadcastVariables otherTyped = other as ModerateBroadcastVariables;
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

  ModerateBroadcastVariables({
    required this.id,
    required this.status,
    required this.reason,
  });
}

