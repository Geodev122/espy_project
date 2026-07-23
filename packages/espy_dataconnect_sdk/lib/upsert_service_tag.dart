part of 'espy.dart';

class UpsertServiceTagVariablesBuilder {
  String id;
  String nameEn;
  String nameAr;

  final FirebaseDataConnect _dataConnect;
  UpsertServiceTagVariablesBuilder(this._dataConnect, {required  this.id,required  this.nameEn,required  this.nameAr,});
  Deserializer<UpsertServiceTagData> dataDeserializer = (dynamic json)  => UpsertServiceTagData.fromJson(jsonDecode(json));
  Serializer<UpsertServiceTagVariables> varsSerializer = (UpsertServiceTagVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpsertServiceTagData, UpsertServiceTagVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpsertServiceTagData, UpsertServiceTagVariables> ref() {
    UpsertServiceTagVariables vars= UpsertServiceTagVariables(id: id,nameEn: nameEn,nameAr: nameAr,);
    return _dataConnect.mutation("UpsertServiceTag", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpsertServiceTagServiceTagUpsert {
  final String id;
  UpsertServiceTagServiceTagUpsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertServiceTagServiceTagUpsert otherTyped = other as UpsertServiceTagServiceTagUpsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpsertServiceTagServiceTagUpsert({
    required this.id,
  });
}

@immutable
class UpsertServiceTagData {
  final UpsertServiceTagServiceTagUpsert serviceTag_upsert;
  UpsertServiceTagData.fromJson(dynamic json):
  
  serviceTag_upsert = UpsertServiceTagServiceTagUpsert.fromJson(json['serviceTag_upsert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertServiceTagData otherTyped = other as UpsertServiceTagData;
    return serviceTag_upsert == otherTyped.serviceTag_upsert;
    
  }
  @override
  int get hashCode => serviceTag_upsert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['serviceTag_upsert'] = serviceTag_upsert.toJson();
    return json;
  }

  UpsertServiceTagData({
    required this.serviceTag_upsert,
  });
}

@immutable
class UpsertServiceTagVariables {
  final String id;
  final String nameEn;
  final String nameAr;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpsertServiceTagVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']),
  nameEn = nativeFromJson<String>(json['nameEn']),
  nameAr = nativeFromJson<String>(json['nameAr']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertServiceTagVariables otherTyped = other as UpsertServiceTagVariables;
    return id == otherTyped.id && 
    nameEn == otherTyped.nameEn && 
    nameAr == otherTyped.nameAr;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, nameEn.hashCode, nameAr.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['nameEn'] = nativeToJson<String>(nameEn);
    json['nameAr'] = nativeToJson<String>(nameAr);
    return json;
  }

  UpsertServiceTagVariables({
    required this.id,
    required this.nameEn,
    required this.nameAr,
  });
}

