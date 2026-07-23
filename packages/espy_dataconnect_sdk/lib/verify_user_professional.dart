part of 'espy.dart';

class VerifyUserProfessionalVariablesBuilder {
  String id;
  bool isApproved;

  final FirebaseDataConnect _dataConnect;
  VerifyUserProfessionalVariablesBuilder(this._dataConnect, {required  this.id,required  this.isApproved,});
  Deserializer<VerifyUserProfessionalData> dataDeserializer = (dynamic json)  => VerifyUserProfessionalData.fromJson(jsonDecode(json));
  Serializer<VerifyUserProfessionalVariables> varsSerializer = (VerifyUserProfessionalVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<VerifyUserProfessionalData, VerifyUserProfessionalVariables>> execute() {
    return ref().execute();
  }

  MutationRef<VerifyUserProfessionalData, VerifyUserProfessionalVariables> ref() {
    VerifyUserProfessionalVariables vars= VerifyUserProfessionalVariables(id: id,isApproved: isApproved,);
    return _dataConnect.mutation("VerifyUserProfessional", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class VerifyUserProfessionalProfessionalProfileUpdate {
  final String id;
  VerifyUserProfessionalProfessionalProfileUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final VerifyUserProfessionalProfessionalProfileUpdate otherTyped = other as VerifyUserProfessionalProfessionalProfileUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  VerifyUserProfessionalProfessionalProfileUpdate({
    required this.id,
  });
}

@immutable
class VerifyUserProfessionalData {
  final VerifyUserProfessionalProfessionalProfileUpdate? professionalProfile_update;
  VerifyUserProfessionalData.fromJson(dynamic json):
  
  professionalProfile_update = json['professionalProfile_update'] == null ? null : VerifyUserProfessionalProfessionalProfileUpdate.fromJson(json['professionalProfile_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final VerifyUserProfessionalData otherTyped = other as VerifyUserProfessionalData;
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

  VerifyUserProfessionalData({
    this.professionalProfile_update,
  });
}

@immutable
class VerifyUserProfessionalVariables {
  final String id;
  final bool isApproved;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  VerifyUserProfessionalVariables.fromJson(Map<String, dynamic> json):
  
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

    final VerifyUserProfessionalVariables otherTyped = other as VerifyUserProfessionalVariables;
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

  VerifyUserProfessionalVariables({
    required this.id,
    required this.isApproved,
  });
}

