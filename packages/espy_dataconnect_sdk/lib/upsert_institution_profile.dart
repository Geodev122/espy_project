part of 'espy.dart';

class UpsertInstitutionProfileVariablesBuilder {
  String id;
  Optional<String> _nameAr = Optional.optional(nativeFromJson, nativeToJson);
  Optional<String> _bioEn = Optional.optional(nativeFromJson, nativeToJson);
  Optional<String> _bioAr = Optional.optional(nativeFromJson, nativeToJson);
  Optional<String> _registrationNumber = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;  UpsertInstitutionProfileVariablesBuilder nameAr(String? t) {
   _nameAr.value = t;
   return this;
  }
  UpsertInstitutionProfileVariablesBuilder bioEn(String? t) {
   _bioEn.value = t;
   return this;
  }
  UpsertInstitutionProfileVariablesBuilder bioAr(String? t) {
   _bioAr.value = t;
   return this;
  }
  UpsertInstitutionProfileVariablesBuilder registrationNumber(String? t) {
   _registrationNumber.value = t;
   return this;
  }

  UpsertInstitutionProfileVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<UpsertInstitutionProfileData> dataDeserializer = (dynamic json)  => UpsertInstitutionProfileData.fromJson(jsonDecode(json));
  Serializer<UpsertInstitutionProfileVariables> varsSerializer = (UpsertInstitutionProfileVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpsertInstitutionProfileData, UpsertInstitutionProfileVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpsertInstitutionProfileData, UpsertInstitutionProfileVariables> ref() {
    UpsertInstitutionProfileVariables vars= UpsertInstitutionProfileVariables(id: id,nameAr: _nameAr,bioEn: _bioEn,bioAr: _bioAr,registrationNumber: _registrationNumber,);
    return _dataConnect.mutation("UpsertInstitutionProfile", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpsertInstitutionProfileInstitutionProfileUpsert {
  final String id;
  UpsertInstitutionProfileInstitutionProfileUpsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertInstitutionProfileInstitutionProfileUpsert otherTyped = other as UpsertInstitutionProfileInstitutionProfileUpsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpsertInstitutionProfileInstitutionProfileUpsert({
    required this.id,
  });
}

@immutable
class UpsertInstitutionProfileData {
  final UpsertInstitutionProfileInstitutionProfileUpsert institutionProfile_upsert;
  UpsertInstitutionProfileData.fromJson(dynamic json):
  
  institutionProfile_upsert = UpsertInstitutionProfileInstitutionProfileUpsert.fromJson(json['institutionProfile_upsert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertInstitutionProfileData otherTyped = other as UpsertInstitutionProfileData;
    return institutionProfile_upsert == otherTyped.institutionProfile_upsert;
    
  }
  @override
  int get hashCode => institutionProfile_upsert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['institutionProfile_upsert'] = institutionProfile_upsert.toJson();
    return json;
  }

  UpsertInstitutionProfileData({
    required this.institutionProfile_upsert,
  });
}

@immutable
class UpsertInstitutionProfileVariables {
  final String id;
  late final Optional<String>nameAr;
  late final Optional<String>bioEn;
  late final Optional<String>bioAr;
  late final Optional<String>registrationNumber;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpsertInstitutionProfileVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']) {
  
  
  
    nameAr = Optional.optional(nativeFromJson, nativeToJson);
    nameAr.value = json['nameAr'] == null ? null : nativeFromJson<String>(json['nameAr']);
  
  
    bioEn = Optional.optional(nativeFromJson, nativeToJson);
    bioEn.value = json['bioEn'] == null ? null : nativeFromJson<String>(json['bioEn']);
  
  
    bioAr = Optional.optional(nativeFromJson, nativeToJson);
    bioAr.value = json['bioAr'] == null ? null : nativeFromJson<String>(json['bioAr']);
  
  
    registrationNumber = Optional.optional(nativeFromJson, nativeToJson);
    registrationNumber.value = json['registrationNumber'] == null ? null : nativeFromJson<String>(json['registrationNumber']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertInstitutionProfileVariables otherTyped = other as UpsertInstitutionProfileVariables;
    return id == otherTyped.id && 
    nameAr == otherTyped.nameAr && 
    bioEn == otherTyped.bioEn && 
    bioAr == otherTyped.bioAr && 
    registrationNumber == otherTyped.registrationNumber;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, nameAr.hashCode, bioEn.hashCode, bioAr.hashCode, registrationNumber.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    if(nameAr.state == OptionalState.set) {
      json['nameAr'] = nameAr.toJson();
    }
    if(bioEn.state == OptionalState.set) {
      json['bioEn'] = bioEn.toJson();
    }
    if(bioAr.state == OptionalState.set) {
      json['bioAr'] = bioAr.toJson();
    }
    if(registrationNumber.state == OptionalState.set) {
      json['registrationNumber'] = registrationNumber.toJson();
    }
    return json;
  }

  UpsertInstitutionProfileVariables({
    required this.id,
    required this.nameAr,
    required this.bioEn,
    required this.bioAr,
    required this.registrationNumber,
  });
}

