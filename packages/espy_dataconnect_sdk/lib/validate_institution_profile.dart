part of 'espy.dart';

class ValidateInstitutionProfileVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  ValidateInstitutionProfileVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<ValidateInstitutionProfileData> dataDeserializer = (dynamic json)  => ValidateInstitutionProfileData.fromJson(jsonDecode(json));
  Serializer<ValidateInstitutionProfileVariables> varsSerializer = (ValidateInstitutionProfileVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<ValidateInstitutionProfileData, ValidateInstitutionProfileVariables>> execute() {
    return ref().execute();
  }

  MutationRef<ValidateInstitutionProfileData, ValidateInstitutionProfileVariables> ref() {
    ValidateInstitutionProfileVariables vars= ValidateInstitutionProfileVariables(id: id,);
    return _dataConnect.mutation("ValidateInstitutionProfile", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ValidateInstitutionProfileInstitutionProfileUpdate {
  final String id;
  ValidateInstitutionProfileInstitutionProfileUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ValidateInstitutionProfileInstitutionProfileUpdate otherTyped = other as ValidateInstitutionProfileInstitutionProfileUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  ValidateInstitutionProfileInstitutionProfileUpdate({
    required this.id,
  });
}

@immutable
class ValidateInstitutionProfileData {
  final ValidateInstitutionProfileInstitutionProfileUpdate? institutionProfile_update;
  ValidateInstitutionProfileData.fromJson(dynamic json):
  
  institutionProfile_update = json['institutionProfile_update'] == null ? null : ValidateInstitutionProfileInstitutionProfileUpdate.fromJson(json['institutionProfile_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ValidateInstitutionProfileData otherTyped = other as ValidateInstitutionProfileData;
    return institutionProfile_update == otherTyped.institutionProfile_update;
    
  }
  @override
  int get hashCode => institutionProfile_update.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (institutionProfile_update != null) {
      json['institutionProfile_update'] = institutionProfile_update!.toJson();
    }
    return json;
  }

  ValidateInstitutionProfileData({
    this.institutionProfile_update,
  });
}

@immutable
class ValidateInstitutionProfileVariables {
  final String id;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ValidateInstitutionProfileVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ValidateInstitutionProfileVariables otherTyped = other as ValidateInstitutionProfileVariables;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  ValidateInstitutionProfileVariables({
    required this.id,
  });
}

