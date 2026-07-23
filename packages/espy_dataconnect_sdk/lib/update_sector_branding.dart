part of 'espy.dart';

class UpdateSectorBrandingVariablesBuilder {
  String id;
  Optional<String> _iconName = Optional.optional(nativeFromJson, nativeToJson);
  Optional<String> _colorHex = Optional.optional(nativeFromJson, nativeToJson);
  Optional<String> _nameEn = Optional.optional(nativeFromJson, nativeToJson);
  Optional<String> _nameAr = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;  UpdateSectorBrandingVariablesBuilder iconName(String? t) {
   _iconName.value = t;
   return this;
  }
  UpdateSectorBrandingVariablesBuilder colorHex(String? t) {
   _colorHex.value = t;
   return this;
  }
  UpdateSectorBrandingVariablesBuilder nameEn(String? t) {
   _nameEn.value = t;
   return this;
  }
  UpdateSectorBrandingVariablesBuilder nameAr(String? t) {
   _nameAr.value = t;
   return this;
  }

  UpdateSectorBrandingVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<UpdateSectorBrandingData> dataDeserializer = (dynamic json)  => UpdateSectorBrandingData.fromJson(jsonDecode(json));
  Serializer<UpdateSectorBrandingVariables> varsSerializer = (UpdateSectorBrandingVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpdateSectorBrandingData, UpdateSectorBrandingVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpdateSectorBrandingData, UpdateSectorBrandingVariables> ref() {
    UpdateSectorBrandingVariables vars= UpdateSectorBrandingVariables(id: id,iconName: _iconName,colorHex: _colorHex,nameEn: _nameEn,nameAr: _nameAr,);
    return _dataConnect.mutation("UpdateSectorBranding", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpdateSectorBrandingSectorUpdate {
  final String id;
  UpdateSectorBrandingSectorUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateSectorBrandingSectorUpdate otherTyped = other as UpdateSectorBrandingSectorUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpdateSectorBrandingSectorUpdate({
    required this.id,
  });
}

@immutable
class UpdateSectorBrandingData {
  final UpdateSectorBrandingSectorUpdate? sector_update;
  UpdateSectorBrandingData.fromJson(dynamic json):
  
  sector_update = json['sector_update'] == null ? null : UpdateSectorBrandingSectorUpdate.fromJson(json['sector_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateSectorBrandingData otherTyped = other as UpdateSectorBrandingData;
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

  UpdateSectorBrandingData({
    this.sector_update,
  });
}

@immutable
class UpdateSectorBrandingVariables {
  final String id;
  late final Optional<String>iconName;
  late final Optional<String>colorHex;
  late final Optional<String>nameEn;
  late final Optional<String>nameAr;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpdateSectorBrandingVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']) {
  
  
  
    iconName = Optional.optional(nativeFromJson, nativeToJson);
    iconName.value = json['iconName'] == null ? null : nativeFromJson<String>(json['iconName']);
  
  
    colorHex = Optional.optional(nativeFromJson, nativeToJson);
    colorHex.value = json['colorHex'] == null ? null : nativeFromJson<String>(json['colorHex']);
  
  
    nameEn = Optional.optional(nativeFromJson, nativeToJson);
    nameEn.value = json['nameEn'] == null ? null : nativeFromJson<String>(json['nameEn']);
  
  
    nameAr = Optional.optional(nativeFromJson, nativeToJson);
    nameAr.value = json['nameAr'] == null ? null : nativeFromJson<String>(json['nameAr']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateSectorBrandingVariables otherTyped = other as UpdateSectorBrandingVariables;
    return id == otherTyped.id && 
    iconName == otherTyped.iconName && 
    colorHex == otherTyped.colorHex && 
    nameEn == otherTyped.nameEn && 
    nameAr == otherTyped.nameAr;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, iconName.hashCode, colorHex.hashCode, nameEn.hashCode, nameAr.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    if(iconName.state == OptionalState.set) {
      json['iconName'] = iconName.toJson();
    }
    if(colorHex.state == OptionalState.set) {
      json['colorHex'] = colorHex.toJson();
    }
    if(nameEn.state == OptionalState.set) {
      json['nameEn'] = nameEn.toJson();
    }
    if(nameAr.state == OptionalState.set) {
      json['nameAr'] = nameAr.toJson();
    }
    return json;
  }

  UpdateSectorBrandingVariables({
    required this.id,
    required this.iconName,
    required this.colorHex,
    required this.nameEn,
    required this.nameAr,
  });
}

