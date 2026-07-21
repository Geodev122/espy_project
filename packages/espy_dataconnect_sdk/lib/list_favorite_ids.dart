part of 'espy.dart';

class ListFavoriteIdsVariablesBuilder {
  String actorId;

  final FirebaseDataConnect _dataConnect;
  ListFavoriteIdsVariablesBuilder(this._dataConnect, {required  this.actorId,});
  Deserializer<ListFavoriteIdsData> dataDeserializer = (dynamic json)  => ListFavoriteIdsData.fromJson(jsonDecode(json));
  Serializer<ListFavoriteIdsVariables> varsSerializer = (ListFavoriteIdsVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<ListFavoriteIdsData, ListFavoriteIdsVariables>> execute() {
    return ref().execute();
  }

  QueryRef<ListFavoriteIdsData, ListFavoriteIdsVariables> ref() {
    ListFavoriteIdsVariables vars= ListFavoriteIdsVariables(actorId: actorId,);
    return _dataConnect.query("ListFavoriteIds", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ListFavoriteIdsInteractions {
  final String targetId;
  ListFavoriteIdsInteractions.fromJson(dynamic json):
  
  targetId = nativeFromJson<String>(json['targetId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListFavoriteIdsInteractions otherTyped = other as ListFavoriteIdsInteractions;
    return targetId == otherTyped.targetId;
    
  }
  @override
  int get hashCode => targetId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['targetId'] = nativeToJson<String>(targetId);
    return json;
  }

  ListFavoriteIdsInteractions({
    required this.targetId,
  });
}

@immutable
class ListFavoriteIdsData {
  final List<ListFavoriteIdsInteractions> interactions;
  ListFavoriteIdsData.fromJson(dynamic json):
  
  interactions = (json['interactions'] as List<dynamic>)
        .map((e) => ListFavoriteIdsInteractions.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListFavoriteIdsData otherTyped = other as ListFavoriteIdsData;
    return interactions == otherTyped.interactions;
    
  }
  @override
  int get hashCode => interactions.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['interactions'] = interactions.map((e) => e.toJson()).toList();
    return json;
  }

  ListFavoriteIdsData({
    required this.interactions,
  });
}

@immutable
class ListFavoriteIdsVariables {
  final String actorId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ListFavoriteIdsVariables.fromJson(Map<String, dynamic> json):
  
  actorId = nativeFromJson<String>(json['actorId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListFavoriteIdsVariables otherTyped = other as ListFavoriteIdsVariables;
    return actorId == otherTyped.actorId;
    
  }
  @override
  int get hashCode => actorId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['actorId'] = nativeToJson<String>(actorId);
    return json;
  }

  ListFavoriteIdsVariables({
    required this.actorId,
  });
}

