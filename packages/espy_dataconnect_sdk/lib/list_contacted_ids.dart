part of 'espy.dart';

class ListContactedIdsVariablesBuilder {
  String actorId;

  final FirebaseDataConnect _dataConnect;
  ListContactedIdsVariablesBuilder(this._dataConnect, {required  this.actorId,});
  Deserializer<ListContactedIdsData> dataDeserializer = (dynamic json)  => ListContactedIdsData.fromJson(jsonDecode(json));
  Serializer<ListContactedIdsVariables> varsSerializer = (ListContactedIdsVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<ListContactedIdsData, ListContactedIdsVariables>> execute() {
    return ref().execute();
  }

  QueryRef<ListContactedIdsData, ListContactedIdsVariables> ref() {
    ListContactedIdsVariables vars= ListContactedIdsVariables(actorId: actorId,);
    return _dataConnect.query("ListContactedIds", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ListContactedIdsInteractions {
  final String targetId;
  ListContactedIdsInteractions.fromJson(dynamic json):
  
  targetId = nativeFromJson<String>(json['targetId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListContactedIdsInteractions otherTyped = other as ListContactedIdsInteractions;
    return targetId == otherTyped.targetId;
    
  }
  @override
  int get hashCode => targetId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['targetId'] = nativeToJson<String>(targetId);
    return json;
  }

  ListContactedIdsInteractions({
    required this.targetId,
  });
}

@immutable
class ListContactedIdsData {
  final List<ListContactedIdsInteractions> interactions;
  ListContactedIdsData.fromJson(dynamic json):
  
  interactions = (json['interactions'] as List<dynamic>)
        .map((e) => ListContactedIdsInteractions.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListContactedIdsData otherTyped = other as ListContactedIdsData;
    return interactions == otherTyped.interactions;
    
  }
  @override
  int get hashCode => interactions.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['interactions'] = interactions.map((e) => e.toJson()).toList();
    return json;
  }

  ListContactedIdsData({
    required this.interactions,
  });
}

@immutable
class ListContactedIdsVariables {
  final String actorId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ListContactedIdsVariables.fromJson(Map<String, dynamic> json):
  
  actorId = nativeFromJson<String>(json['actorId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListContactedIdsVariables otherTyped = other as ListContactedIdsVariables;
    return actorId == otherTyped.actorId;
    
  }
  @override
  int get hashCode => actorId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['actorId'] = nativeToJson<String>(actorId);
    return json;
  }

  ListContactedIdsVariables({
    required this.actorId,
  });
}

