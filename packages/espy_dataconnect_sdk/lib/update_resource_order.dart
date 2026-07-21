part of 'espy.dart';

class UpdateResourceOrderVariablesBuilder {
  String id;
  int pins;
  int slots;
  int broadcasts;
  int total;

  final FirebaseDataConnect _dataConnect;
  UpdateResourceOrderVariablesBuilder(this._dataConnect, {required  this.id,required  this.pins,required  this.slots,required  this.broadcasts,required  this.total,});
  Deserializer<UpdateResourceOrderData> dataDeserializer = (dynamic json)  => UpdateResourceOrderData.fromJson(jsonDecode(json));
  Serializer<UpdateResourceOrderVariables> varsSerializer = (UpdateResourceOrderVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpdateResourceOrderData, UpdateResourceOrderVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpdateResourceOrderData, UpdateResourceOrderVariables> ref() {
    UpdateResourceOrderVariables vars= UpdateResourceOrderVariables(id: id,pins: pins,slots: slots,broadcasts: broadcasts,total: total,);
    return _dataConnect.mutation("UpdateResourceOrder", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpdateResourceOrderResourceOrderUpdate {
  final String id;
  UpdateResourceOrderResourceOrderUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateResourceOrderResourceOrderUpdate otherTyped = other as UpdateResourceOrderResourceOrderUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpdateResourceOrderResourceOrderUpdate({
    required this.id,
  });
}

@immutable
class UpdateResourceOrderData {
  final UpdateResourceOrderResourceOrderUpdate? resourceOrder_update;
  UpdateResourceOrderData.fromJson(dynamic json):
  
  resourceOrder_update = json['resourceOrder_update'] == null ? null : UpdateResourceOrderResourceOrderUpdate.fromJson(json['resourceOrder_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateResourceOrderData otherTyped = other as UpdateResourceOrderData;
    return resourceOrder_update == otherTyped.resourceOrder_update;
    
  }
  @override
  int get hashCode => resourceOrder_update.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (resourceOrder_update != null) {
      json['resourceOrder_update'] = resourceOrder_update!.toJson();
    }
    return json;
  }

  UpdateResourceOrderData({
    this.resourceOrder_update,
  });
}

@immutable
class UpdateResourceOrderVariables {
  final String id;
  final int pins;
  final int slots;
  final int broadcasts;
  final int total;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpdateResourceOrderVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']),
  pins = nativeFromJson<int>(json['pins']),
  slots = nativeFromJson<int>(json['slots']),
  broadcasts = nativeFromJson<int>(json['broadcasts']),
  total = nativeFromJson<int>(json['total']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateResourceOrderVariables otherTyped = other as UpdateResourceOrderVariables;
    return id == otherTyped.id && 
    pins == otherTyped.pins && 
    slots == otherTyped.slots && 
    broadcasts == otherTyped.broadcasts && 
    total == otherTyped.total;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, pins.hashCode, slots.hashCode, broadcasts.hashCode, total.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['pins'] = nativeToJson<int>(pins);
    json['slots'] = nativeToJson<int>(slots);
    json['broadcasts'] = nativeToJson<int>(broadcasts);
    json['total'] = nativeToJson<int>(total);
    return json;
  }

  UpdateResourceOrderVariables({
    required this.id,
    required this.pins,
    required this.slots,
    required this.broadcasts,
    required this.total,
  });
}

