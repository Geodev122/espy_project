part of 'espy.dart';

class VerifyUserInstitutionVariablesBuilder {
  String id;
  bool isApproved;

  final FirebaseDataConnect _dataConnect;
  VerifyUserInstitutionVariablesBuilder(this._dataConnect, {required  this.id,required  this.isApproved,});
  Deserializer<VerifyUserInstitutionData> dataDeserializer = (dynamic json)  => VerifyUserInstitutionData.fromJson(jsonDecode(json));
  Serializer<VerifyUserInstitutionVariables> varsSerializer = (VerifyUserInstitutionVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<VerifyUserInstitutionData, VerifyUserInstitutionVariables>> execute() {
    return ref().execute();
  }

  MutationRef<VerifyUserInstitutionData, VerifyUserInstitutionVariables> ref() {
    VerifyUserInstitutionVariables vars= VerifyUserInstitutionVariables(id: id,isApproved: isApproved,);
    return _dataConnect.mutation("VerifyUserInstitution", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class VerifyUserInstitutionInstitutionProfileUpdate {
  final String id;
  VerifyUserInstitutionInstitutionProfileUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final VerifyUserInstitutionInstitutionProfileUpdate otherTyped = other as VerifyUserInstitutionInstitutionProfileUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  VerifyUserInstitutionInstitutionProfileUpdate({
    required this.id,
  });
}

@immutable
class VerifyUserInstitutionData {
  final VerifyUserInstitutionInstitutionProfileUpdate? institutionProfile_update;
  VerifyUserInstitutionData.fromJson(dynamic json):
  
  institutionProfile_update = json['institutionProfile_update'] == null ? null : VerifyUserInstitutionInstitutionProfileUpdate.fromJson(json['institutionProfile_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final VerifyUserInstitutionData otherTyped = other as VerifyUserInstitutionData;
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

  VerifyUserInstitutionData({
    this.institutionProfile_update,
  });
}

@immutable
class VerifyUserInstitutionVariables {
  final String id;
  final bool isApproved;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  VerifyUserInstitutionVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']),
  isApproved = nativeFromJson<bool>(json['isApproved']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final VerifyUserInstitutionVariables otherTyped = other as VerifyUserInstitutionVariables;
    return id == otherTyped.id && 
    isApproved == otherTyped.isApproved;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, isApproved.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['isApproved'] = nativeToJson<bool>(isApproved);
    return json;
  }

  VerifyUserInstitutionVariables({
    required this.id,
    required this.isApproved,
  });
}

