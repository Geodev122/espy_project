part of 'espy.dart';

class UpsertSosNumberVariablesBuilder {
  Optional<String> _id = Optional.optional(nativeFromJson, nativeToJson);
  String countryId;
  Optional<String> _sectorId = Optional.optional(nativeFromJson, nativeToJson);
  Optional<String> _categoryId = Optional.optional(nativeFromJson, nativeToJson);
  String labelEn;
  Optional<String> _labelAr = Optional.optional(nativeFromJson, nativeToJson);
  String number;
  bool isActive;

  final FirebaseDataConnect _dataConnect;
  UpsertSosNumberVariablesBuilder id(String? t) {
   _id.value = t;
   return this;
  }
  UpsertSosNumberVariablesBuilder sectorId(String? t) {
   _sectorId.value = t;
   return this;
  }
  UpsertSosNumberVariablesBuilder categoryId(String? t) {
   _categoryId.value = t;
   return this;
  }
  UpsertSosNumberVariablesBuilder labelAr(String? t) {
   _labelAr.value = t;
   return this;
  }

  UpsertSosNumberVariablesBuilder(this._dataConnect, {required  this.countryId,required  this.labelEn,required  this.number,required  this.isActive,});
  Deserializer<UpsertSosNumberData> dataDeserializer = (dynamic json)  => UpsertSosNumberData.fromJson(jsonDecode(json));
  Serializer<UpsertSosNumberVariables> varsSerializer = (UpsertSosNumberVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpsertSosNumberData, UpsertSosNumberVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpsertSosNumberData, UpsertSosNumberVariables> ref() {
    UpsertSosNumberVariables vars= UpsertSosNumberVariables(id: _id,countryId: countryId,sectorId: _sectorId,categoryId: _categoryId,labelEn: labelEn,labelAr: _labelAr,number: number,isActive: isActive,);
    return _dataConnect.mutation("UpsertSosNumber", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpsertSosNumberSosNumberUpsert {
  final String id;
  UpsertSosNumberSosNumberUpsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertSosNumberSosNumberUpsert otherTyped = other as UpsertSosNumberSosNumberUpsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpsertSosNumberSosNumberUpsert({
    required this.id,
  });
}

@immutable
class UpsertSosNumberData {
  final UpsertSosNumberSosNumberUpsert sosNumber_upsert;
  UpsertSosNumberData.fromJson(dynamic json):
  
  sosNumber_upsert = UpsertSosNumberSosNumberUpsert.fromJson(json['sosNumber_upsert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertSosNumberData otherTyped = other as UpsertSosNumberData;
    return sosNumber_upsert == otherTyped.sosNumber_upsert;
    
  }
  @override
  int get hashCode => sosNumber_upsert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['sosNumber_upsert'] = sosNumber_upsert.toJson();
    return json;
  }

  UpsertSosNumberData({
    required this.sosNumber_upsert,
  });
}

@immutable
class UpsertSosNumberVariables {
  late final Optional<String>id;
  final String countryId;
  late final Optional<String>sectorId;
  late final Optional<String>categoryId;
  final String labelEn;
  late final Optional<String>labelAr;
  final String number;
  final bool isActive;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpsertSosNumberVariables.fromJson(Map<String, dynamic> json):
  
  countryId = nativeFromJson<String>(json['countryId']),
  labelEn = nativeFromJson<String>(json['labelEn']),
  number = nativeFromJson<String>(json['number']),
  isActive = nativeFromJson<bool>(json['isActive']) {
  
  
    id = Optional.optional(nativeFromJson, nativeToJson);
    id.value = json['id'] == null ? null : nativeFromJson<String>(json['id']);
  
  
  
    sectorId = Optional.optional(nativeFromJson, nativeToJson);
    sectorId.value = json['sectorId'] == null ? null : nativeFromJson<String>(json['sectorId']);
  
  
    categoryId = Optional.optional(nativeFromJson, nativeToJson);
    categoryId.value = json['categoryId'] == null ? null : nativeFromJson<String>(json['categoryId']);
  
  
  
    labelAr = Optional.optional(nativeFromJson, nativeToJson);
    labelAr.value = json['labelAr'] == null ? null : nativeFromJson<String>(json['labelAr']);
  
  
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertSosNumberVariables otherTyped = other as UpsertSosNumberVariables;
    return id == otherTyped.id && 
    countryId == otherTyped.countryId && 
    sectorId == otherTyped.sectorId && 
    categoryId == otherTyped.categoryId && 
    labelEn == otherTyped.labelEn && 
    labelAr == otherTyped.labelAr && 
    number == otherTyped.number && 
    isActive == otherTyped.isActive;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, countryId.hashCode, sectorId.hashCode, categoryId.hashCode, labelEn.hashCode, labelAr.hashCode, number.hashCode, isActive.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if(id.state == OptionalState.set) {
      json['id'] = id.toJson();
    }
    json['countryId'] = nativeToJson<String>(countryId);
    if(sectorId.state == OptionalState.set) {
      json['sectorId'] = sectorId.toJson();
    }
    if(categoryId.state == OptionalState.set) {
      json['categoryId'] = categoryId.toJson();
    }
    json['labelEn'] = nativeToJson<String>(labelEn);
    if(labelAr.state == OptionalState.set) {
      json['labelAr'] = labelAr.toJson();
    }
    json['number'] = nativeToJson<String>(number);
    json['isActive'] = nativeToJson<bool>(isActive);
    return json;
  }

  UpsertSosNumberVariables({
    required this.id,
    required this.countryId,
    required this.sectorId,
    required this.categoryId,
    required this.labelEn,
    required this.labelAr,
    required this.number,
    required this.isActive,
  });
}

