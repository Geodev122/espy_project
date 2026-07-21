part of 'espy.dart';

class UpdateSectorVariablesBuilder {
  String id;
  Optional<String> _nameEn = Optional.optional(nativeFromJson, nativeToJson);
  Optional<int> _displayOrder = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;  UpdateSectorVariablesBuilder nameEn(String? t) {
   _nameEn.value = t;
   return this;
  }
  UpdateSectorVariablesBuilder displayOrder(int? t) {
   _displayOrder.value = t;
   return this;
  }

  UpdateSectorVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<UpdateSectorData> dataDeserializer = (dynamic json)  => UpdateSectorData.fromJson(jsonDecode(json));
  Serializer<UpdateSectorVariables> varsSerializer = (UpdateSectorVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpdateSectorData, UpdateSectorVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpdateSectorData, UpdateSectorVariables> ref() {
    UpdateSectorVariables vars= UpdateSectorVariables(id: id,nameEn: _nameEn,displayOrder: _displayOrder,);
    return _dataConnect.mutation("UpdateSector", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpdateSectorSectorUpdate {
  final String id;
  UpdateSectorSectorUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateSectorSectorUpdate otherTyped = other as UpdateSectorSectorUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpdateSectorSectorUpdate({
    required this.id,
  });
}

@immutable
class UpdateSectorData {
  final UpdateSectorSectorUpdate? sector_update;
  UpdateSectorData.fromJson(dynamic json):
  
  sector_update = json['sector_update'] == null ? null : UpdateSectorSectorUpdate.fromJson(json['sector_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateSectorData otherTyped = other as UpdateSectorData;
    return sector_update == otherTyped.sector_update;
    
  }
  @override
  int get hashCode => sector_update.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (sector_update != null) {
      json['sector_update'] = sector_update!.toJson();
    }
    return json;
  }

  UpdateSectorData({
    this.sector_update,
  });
}

@immutable
class UpdateSectorVariables {
  final String id;
  late final Optional<String>nameEn;
  late final Optional<int>displayOrder;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpdateSectorVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']) {
  
  
  
    nameEn = Optional.optional(nativeFromJson, nativeToJson);
    nameEn.value = json['nameEn'] == null ? null : nativeFromJson<String>(json['nameEn']);
  
  
    displayOrder = Optional.optional(nativeFromJson, nativeToJson);
    displayOrder.value = json['displayOrder'] == null ? null : nativeFromJson<int>(json['displayOrder']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateSectorVariables otherTyped = other as UpdateSectorVariables;
    return id == otherTyped.id && 
    nameEn == otherTyped.nameEn && 
    displayOrder == otherTyped.displayOrder;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, nameEn.hashCode, displayOrder.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    if(nameEn.state == OptionalState.set) {
      json['nameEn'] = nameEn.toJson();
    }
    if(displayOrder.state == OptionalState.set) {
      json['displayOrder'] = displayOrder.toJson();
    }
    return json;
  }

  UpdateSectorVariables({
    required this.id,
    required this.nameEn,
    required this.displayOrder,
  });
}

