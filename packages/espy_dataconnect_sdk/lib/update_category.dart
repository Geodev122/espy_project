part of 'espy.dart';

class UpdateCategoryVariablesBuilder {
  String id;
  String sectorId;
  String nameEn;
  String nameAr;
  UserRole targetRole;

  final FirebaseDataConnect _dataConnect;
  UpdateCategoryVariablesBuilder(this._dataConnect, {required  this.id,required  this.sectorId,required  this.nameEn,required  this.nameAr,required  this.targetRole,});
  Deserializer<UpdateCategoryData> dataDeserializer = (dynamic json)  => UpdateCategoryData.fromJson(jsonDecode(json));
  Serializer<UpdateCategoryVariables> varsSerializer = (UpdateCategoryVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpdateCategoryData, UpdateCategoryVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpdateCategoryData, UpdateCategoryVariables> ref() {
    UpdateCategoryVariables vars= UpdateCategoryVariables(id: id,sectorId: sectorId,nameEn: nameEn,nameAr: nameAr,targetRole: targetRole,);
    return _dataConnect.mutation("UpdateCategory", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpdateCategoryCategoryUpdate {
  final String id;
  UpdateCategoryCategoryUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateCategoryCategoryUpdate otherTyped = other as UpdateCategoryCategoryUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpdateCategoryCategoryUpdate({
    required this.id,
  });
}

@immutable
class UpdateCategoryData {
  final UpdateCategoryCategoryUpdate? category_update;
  UpdateCategoryData.fromJson(dynamic json):
  
  category_update = json['category_update'] == null ? null : UpdateCategoryCategoryUpdate.fromJson(json['category_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateCategoryData otherTyped = other as UpdateCategoryData;
    return category_update == otherTyped.category_update;
    
  }
  @override
  int get hashCode => category_update.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (category_update != null) {
      json['category_update'] = category_update!.toJson();
    }
    return json;
  }

  UpdateCategoryData({
    this.category_update,
  });
}

@immutable
class UpdateCategoryVariables {
  final String id;
  final String sectorId;
  final String nameEn;
  final String nameAr;
  final UserRole targetRole;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpdateCategoryVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']),
  sectorId = nativeFromJson<String>(json['sectorId']),
  nameEn = nativeFromJson<String>(json['nameEn']),
  nameAr = nativeFromJson<String>(json['nameAr']),
  targetRole = UserRole.values.byName(json['targetRole']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateCategoryVariables otherTyped = other as UpdateCategoryVariables;
    return id == otherTyped.id && 
    sectorId == otherTyped.sectorId && 
    nameEn == otherTyped.nameEn && 
    nameAr == otherTyped.nameAr && 
    targetRole == otherTyped.targetRole;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, sectorId.hashCode, nameEn.hashCode, nameAr.hashCode, targetRole.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['sectorId'] = nativeToJson<String>(sectorId);
    json['nameEn'] = nativeToJson<String>(nameEn);
    json['nameAr'] = nativeToJson<String>(nameAr);
    json['targetRole'] = 
    targetRole.name
    ;
    return json;
  }

  UpdateCategoryVariables({
    required this.id,
    required this.sectorId,
    required this.nameEn,
    required this.nameAr,
    required this.targetRole,
  });
}

