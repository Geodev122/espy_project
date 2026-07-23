part of 'espy.dart';

class ApproveProfessionalVariablesBuilder {
  String id;
  bool isApproved;

  final FirebaseDataConnect _dataConnect;
  ApproveProfessionalVariablesBuilder(this._dataConnect, {required  this.id,required  this.isApproved,});
  Deserializer<ApproveProfessionalData> dataDeserializer = (dynamic json)  => ApproveProfessionalData.fromJson(jsonDecode(json));
  Serializer<ApproveProfessionalVariables> varsSerializer = (ApproveProfessionalVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<ApproveProfessionalData, ApproveProfessionalVariables>> execute() {
    return ref().execute();
  }

  MutationRef<ApproveProfessionalData, ApproveProfessionalVariables> ref() {
    ApproveProfessionalVariables vars= ApproveProfessionalVariables(id: id,isApproved: isApproved,);
    return _dataConnect.mutation("ApproveProfessional", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ApproveProfessionalProfessionalProfileUpdate {
  final String id;
  ApproveProfessionalProfessionalProfileUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ApproveProfessionalProfessionalProfileUpdate otherTyped = other as ApproveProfessionalProfessionalProfileUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  ApproveProfessionalProfessionalProfileUpdate({
    required this.id,
  });
}

@immutable
class ApproveProfessionalData {
  final ApproveProfessionalProfessionalProfileUpdate? professionalProfile_update;
  ApproveProfessionalData.fromJson(dynamic json):
  
  professionalProfile_update = json['professionalProfile_update'] == null ? null : ApproveProfessionalProfessionalProfileUpdate.fromJson(json['professionalProfile_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ApproveProfessionalData otherTyped = other as ApproveProfessionalData;
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

  ApproveProfessionalData({
    this.professionalProfile_update,
  });
}

@immutable
class ApproveProfessionalVariables {
  final String id;
  final bool isApproved;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ApproveProfessionalVariables.fromJson(Map<String, dynamic> json):
  
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

    final ApproveProfessionalVariables otherTyped = other as ApproveProfessionalVariables;
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

  ApproveProfessionalVariables({
    required this.id,
    required this.isApproved,
  });
}

