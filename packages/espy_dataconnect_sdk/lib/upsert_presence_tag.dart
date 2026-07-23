part of 'espy.dart';

class UpsertPresenceTagVariablesBuilder {
  String id;
  String nameEn;
  String nameAr;

  final FirebaseDataConnect _dataConnect;
  UpsertPresenceTagVariablesBuilder(this._dataConnect, {required  this.id,required  this.nameEn,required  this.nameAr,});
  Deserializer<UpsertPresenceTagData> dataDeserializer = (dynamic json)  => UpsertPresenceTagData.fromJson(jsonDecode(json));
  Serializer<UpsertPresenceTagVariables> varsSerializer = (UpsertPresenceTagVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpsertPresenceTagData, UpsertPresenceTagVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpsertPresenceTagData, UpsertPresenceTagVariables> ref() {
    UpsertPresenceTagVariables vars= UpsertPresenceTagVariables(id: id,nameEn: nameEn,nameAr: nameAr,);
    return _dataConnect.mutation("UpsertPresenceTag", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpsertPresenceTagPresenceTagUpsert {
  final String id;
  UpsertPresenceTagPresenceTagUpsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertPresenceTagPresenceTagUpsert otherTyped = other as UpsertPresenceTagPresenceTagUpsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpsertPresenceTagPresenceTagUpsert({
    required this.id,
  });
}

@immutable
class UpsertPresenceTagData {
  final UpsertPresenceTagPresenceTagUpsert presenceTag_upsert;
  UpsertPresenceTagData.fromJson(dynamic json):
  
  presenceTag_upsert = UpsertPresenceTagPresenceTagUpsert.fromJson(json['presenceTag_upsert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertPresenceTagData otherTyped = other as UpsertPresenceTagData;
    return presenceTag_upsert == otherTyped.presenceTag_upsert;
    
  }
  @override
  int get hashCode => presenceTag_upsert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['presenceTag_upsert'] = presenceTag_upsert.toJson();
    return json;
  }

  UpsertPresenceTagData({
    required this.presenceTag_upsert,
  });
}

@immutable
class UpsertPresenceTagVariables {
  final String id;
  final String nameEn;
  final String nameAr;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpsertPresenceTagVariables.fromJson(Map<String, dynamic> json):
  
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

    final UpsertPresenceTagVariables otherTyped = other as UpsertPresenceTagVariables;
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

  UpsertPresenceTagVariables({
    required this.id,
    required this.nameEn,
    required this.nameAr,
  });
}

