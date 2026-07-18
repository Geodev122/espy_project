part of 'espy.dart';

class PostCommunityRequestVariablesBuilder {
  String sectorId;
  String title;
  String description;

  final FirebaseDataConnect _dataConnect;
  PostCommunityRequestVariablesBuilder(this._dataConnect, {required  this.sectorId,required  this.title,required  this.description,});
  Deserializer<PostCommunityRequestData> dataDeserializer = (dynamic json)  => PostCommunityRequestData.fromJson(jsonDecode(json));
  Serializer<PostCommunityRequestVariables> varsSerializer = (PostCommunityRequestVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<PostCommunityRequestData, PostCommunityRequestVariables>> execute() {
    return ref().execute();
  }

  MutationRef<PostCommunityRequestData, PostCommunityRequestVariables> ref() {
    PostCommunityRequestVariables vars= PostCommunityRequestVariables(sectorId: sectorId,title: title,description: description,);
    return _dataConnect.mutation("PostCommunityRequest", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class PostCommunityRequestCommunityRequestInsert {
  final String id;
  PostCommunityRequestCommunityRequestInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final PostCommunityRequestCommunityRequestInsert otherTyped = other as PostCommunityRequestCommunityRequestInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  PostCommunityRequestCommunityRequestInsert({
    required this.id,
  });
}

@immutable
class PostCommunityRequestData {
  final PostCommunityRequestCommunityRequestInsert communityRequest_insert;
  PostCommunityRequestData.fromJson(dynamic json):
  
  communityRequest_insert = PostCommunityRequestCommunityRequestInsert.fromJson(json['communityRequest_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final PostCommunityRequestData otherTyped = other as PostCommunityRequestData;
    return communityRequest_insert == otherTyped.communityRequest_insert;
    
  }
  @override
  int get hashCode => communityRequest_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['communityRequest_insert'] = communityRequest_insert.toJson();
    return json;
  }

  PostCommunityRequestData({
    required this.communityRequest_insert,
  });
}

@immutable
class PostCommunityRequestVariables {
  final String sectorId;
  final String title;
  final String description;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  PostCommunityRequestVariables.fromJson(Map<String, dynamic> json):
  
  sectorId = nativeFromJson<String>(json['sectorId']),
  title = nativeFromJson<String>(json['title']),
  description = nativeFromJson<String>(json['description']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final PostCommunityRequestVariables otherTyped = other as PostCommunityRequestVariables;
    return sectorId == otherTyped.sectorId && 
    title == otherTyped.title && 
    description == otherTyped.description;
    
  }
  @override
  int get hashCode => Object.hashAll([sectorId.hashCode, title.hashCode, description.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['sectorId'] = nativeToJson<String>(sectorId);
    json['title'] = nativeToJson<String>(title);
    json['description'] = nativeToJson<String>(description);
    return json;
  }

  PostCommunityRequestVariables({
    required this.sectorId,
    required this.title,
    required this.description,
  });
}

