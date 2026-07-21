part of 'espy.dart';

class ValidateProfileVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  ValidateProfileVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<ValidateProfileData> dataDeserializer = (dynamic json)  => ValidateProfileData.fromJson(jsonDecode(json));
  Serializer<ValidateProfileVariables> varsSerializer = (ValidateProfileVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<ValidateProfileData, ValidateProfileVariables>> execute() {
    return ref().execute();
  }

  MutationRef<ValidateProfileData, ValidateProfileVariables> ref() {
    ValidateProfileVariables vars= ValidateProfileVariables(id: id,);
    return _dataConnect.mutation("ValidateProfile", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ValidateProfileProfessionalProfileUpdate {
  final String id;
  ValidateProfileProfessionalProfileUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ValidateProfileProfessionalProfileUpdate otherTyped = other as ValidateProfileProfessionalProfileUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  ValidateProfileProfessionalProfileUpdate({
    required this.id,
  });
}

@immutable
class ValidateProfileData {
  final ValidateProfileProfessionalProfileUpdate? professionalProfile_update;
  ValidateProfileData.fromJson(dynamic json):
  
  professionalProfile_update = json['professionalProfile_update'] == null ? null : ValidateProfileProfessionalProfileUpdate.fromJson(json['professionalProfile_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ValidateProfileData otherTyped = other as ValidateProfileData;
    return professionalProfile_update == otherTyped.professionalProfile_update;
    
  }
  @override
  int get hashCode => professionalProfile_update.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (professionalProfile_update != null) {
      json['professionalProfile_update'] = professionalProfile_update!.toJson();
    }
    return json;
  }

  ValidateProfileData({
    this.professionalProfile_update,
  });
}

@immutable
class ValidateProfileVariables {
  final String id;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ValidateProfileVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ValidateProfileVariables otherTyped = other as ValidateProfileVariables;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  ValidateProfileVariables({
    required this.id,
  });
}

