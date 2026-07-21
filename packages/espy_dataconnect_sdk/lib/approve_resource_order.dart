part of 'espy.dart';

class ApproveResourceOrderVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  ApproveResourceOrderVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<ApproveResourceOrderData> dataDeserializer = (dynamic json)  => ApproveResourceOrderData.fromJson(jsonDecode(json));
  Serializer<ApproveResourceOrderVariables> varsSerializer = (ApproveResourceOrderVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<ApproveResourceOrderData, ApproveResourceOrderVariables>> execute() {
    return ref().execute();
  }

  MutationRef<ApproveResourceOrderData, ApproveResourceOrderVariables> ref() {
    ApproveResourceOrderVariables vars= ApproveResourceOrderVariables(id: id,);
    return _dataConnect.mutation("ApproveResourceOrder", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ApproveResourceOrderResourceOrderUpdate {
  final String id;
  ApproveResourceOrderResourceOrderUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ApproveResourceOrderResourceOrderUpdate otherTyped = other as ApproveResourceOrderResourceOrderUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  ApproveResourceOrderResourceOrderUpdate({
    required this.id,
  });
}

@immutable
class ApproveResourceOrderData {
  final ApproveResourceOrderResourceOrderUpdate? resourceOrder_update;
  ApproveResourceOrderData.fromJson(dynamic json):
  
  resourceOrder_update = json['resourceOrder_update'] == null ? null : ApproveResourceOrderResourceOrderUpdate.fromJson(json['resourceOrder_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ApproveResourceOrderData otherTyped = other as ApproveResourceOrderData;
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

  ApproveResourceOrderData({
    this.resourceOrder_update,
  });
}

@immutable
class ApproveResourceOrderVariables {
  final String id;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ApproveResourceOrderVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ApproveResourceOrderVariables otherTyped = other as ApproveResourceOrderVariables;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  ApproveResourceOrderVariables({
    required this.id,
  });
}

