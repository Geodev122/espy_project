part of 'espy.dart';

class UpsertProfessionalProfileVariablesBuilder {
  String id;
  Optional<String> _fullNameAr = Optional.optional(nativeFromJson, nativeToJson);
  Optional<String> _specialty = Optional.optional(nativeFromJson, nativeToJson);
  Optional<String> _specialtyAr = Optional.optional(nativeFromJson, nativeToJson);
  Optional<String> _bioEn = Optional.optional(nativeFromJson, nativeToJson);
  Optional<String> _bioAr = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;  UpsertProfessionalProfileVariablesBuilder fullNameAr(String? t) {
   _fullNameAr.value = t;
   return this;
  }
  UpsertProfessionalProfileVariablesBuilder specialty(String? t) {
   _specialty.value = t;
   return this;
  }
  UpsertProfessionalProfileVariablesBuilder specialtyAr(String? t) {
   _specialtyAr.value = t;
   return this;
  }
  UpsertProfessionalProfileVariablesBuilder bioEn(String? t) {
   _bioEn.value = t;
   return this;
  }
  UpsertProfessionalProfileVariablesBuilder bioAr(String? t) {
   _bioAr.value = t;
   return this;
  }

  UpsertProfessionalProfileVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<UpsertProfessionalProfileData> dataDeserializer = (dynamic json)  => UpsertProfessionalProfileData.fromJson(jsonDecode(json));
  Serializer<UpsertProfessionalProfileVariables> varsSerializer = (UpsertProfessionalProfileVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpsertProfessionalProfileData, UpsertProfessionalProfileVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpsertProfessionalProfileData, UpsertProfessionalProfileVariables> ref() {
    UpsertProfessionalProfileVariables vars= UpsertProfessionalProfileVariables(id: id,fullNameAr: _fullNameAr,specialty: _specialty,specialtyAr: _specialtyAr,bioEn: _bioEn,bioAr: _bioAr,);
    return _dataConnect.mutation("UpsertProfessionalProfile", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpsertProfessionalProfileProfessionalProfileUpsert {
  final String id;
  UpsertProfessionalProfileProfessionalProfileUpsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertProfessionalProfileProfessionalProfileUpsert otherTyped = other as UpsertProfessionalProfileProfessionalProfileUpsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpsertProfessionalProfileProfessionalProfileUpsert({
    required this.id,
  });
}

@immutable
class UpsertProfessionalProfileData {
  final UpsertProfessionalProfileProfessionalProfileUpsert professionalProfile_upsert;
  UpsertProfessionalProfileData.fromJson(dynamic json):
  
  professionalProfile_upsert = UpsertProfessionalProfileProfessionalProfileUpsert.fromJson(json['professionalProfile_upsert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertProfessionalProfileData otherTyped = other as UpsertProfessionalProfileData;
    return professionalProfile_upsert == otherTyped.professionalProfile_upsert;
    
  }
  @override
  int get hashCode => professionalProfile_upsert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['professionalProfile_upsert'] = professionalProfile_upsert.toJson();
    return json;
  }

  UpsertProfessionalProfileData({
    required this.professionalProfile_upsert,
  });
}

@immutable
class UpsertProfessionalProfileVariables {
  final String id;
  late final Optional<String>fullNameAr;
  late final Optional<String>specialty;
  late final Optional<String>specialtyAr;
  late final Optional<String>bioEn;
  late final Optional<String>bioAr;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpsertProfessionalProfileVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']) {
  
  
  
    fullNameAr = Optional.optional(nativeFromJson, nativeToJson);
    fullNameAr.value = json['fullNameAr'] == null ? null : nativeFromJson<String>(json['fullNameAr']);
  
  
    specialty = Optional.optional(nativeFromJson, nativeToJson);
    specialty.value = json['specialty'] == null ? null : nativeFromJson<String>(json['specialty']);
  
  
    specialtyAr = Optional.optional(nativeFromJson, nativeToJson);
    specialtyAr.value = json['specialtyAr'] == null ? null : nativeFromJson<String>(json['specialtyAr']);
  
  
    bioEn = Optional.optional(nativeFromJson, nativeToJson);
    bioEn.value = json['bioEn'] == null ? null : nativeFromJson<String>(json['bioEn']);
  
  
    bioAr = Optional.optional(nativeFromJson, nativeToJson);
    bioAr.value = json['bioAr'] == null ? null : nativeFromJson<String>(json['bioAr']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertProfessionalProfileVariables otherTyped = other as UpsertProfessionalProfileVariables;
    return id == otherTyped.id && 
    fullNameAr == otherTyped.fullNameAr && 
    specialty == otherTyped.specialty && 
    specialtyAr == otherTyped.specialtyAr && 
    bioEn == otherTyped.bioEn && 
    bioAr == otherTyped.bioAr;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, fullNameAr.hashCode, specialty.hashCode, specialtyAr.hashCode, bioEn.hashCode, bioAr.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    if(fullNameAr.state == OptionalState.set) {
      json['fullNameAr'] = fullNameAr.toJson();
    }
    if(specialty.state == OptionalState.set) {
      json['specialty'] = specialty.toJson();
    }
    if(specialtyAr.state == OptionalState.set) {
      json['specialtyAr'] = specialtyAr.toJson();
    }
    if(bioEn.state == OptionalState.set) {
      json['bioEn'] = bioEn.toJson();
    }
    if(bioAr.state == OptionalState.set) {
      json['bioAr'] = bioAr.toJson();
    }
    return json;
  }

  UpsertProfessionalProfileVariables({
    required this.id,
    required this.fullNameAr,
    required this.specialty,
    required this.specialtyAr,
    required this.bioEn,
    required this.bioAr,
  });
}

