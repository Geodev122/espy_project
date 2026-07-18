part of 'espy.dart';

class ListInteractionsVariablesBuilder {
  String actorId;
  Optional<InteractionType> _type = Optional.optional((data) => InteractionType.values.byName(data), enumSerializer);

  final FirebaseDataConnect _dataConnect;  ListInteractionsVariablesBuilder type(InteractionType? t) {
   _type.value = t;
   return this;
  }

  ListInteractionsVariablesBuilder(this._dataConnect, {required  this.actorId,});
  Deserializer<ListInteractionsData> dataDeserializer = (dynamic json)  => ListInteractionsData.fromJson(jsonDecode(json));
  Serializer<ListInteractionsVariables> varsSerializer = (ListInteractionsVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<ListInteractionsData, ListInteractionsVariables>> execute() {
    return ref().execute();
  }

  QueryRef<ListInteractionsData, ListInteractionsVariables> ref() {
    ListInteractionsVariables vars= ListInteractionsVariables(actorId: actorId,type: _type,);
    return _dataConnect.query("ListInteractions", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ListInteractionsInteractions {
  final String targetId;
  ListInteractionsInteractions.fromJson(dynamic json):
  
  targetId = nativeFromJson<String>(json['targetId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListInteractionsInteractions otherTyped = other as ListInteractionsInteractions;
    return targetId == otherTyped.targetId;
    
  }
  @override
  int get hashCode => targetId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['targetId'] = nativeToJson<String>(targetId);
    return json;
  }

  ListInteractionsInteractions({
    required this.targetId,
  });
}

@immutable
class ListInteractionsData {
  final List<ListInteractionsInteractions> interactions;
  ListInteractionsData.fromJson(dynamic json):
  
  interactions = (json['interactions'] as List<dynamic>)
        .map((e) => ListInteractionsInteractions.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListInteractionsData otherTyped = other as ListInteractionsData;
    return interactions == otherTyped.interactions;
    
  }
  @override
  int get hashCode => interactions.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['interactions'] = interactions.map((e) => e.toJson()).toList();
    return json;
  }

  ListInteractionsData({
    required this.interactions,
  });
}

@immutable
class ListInteractionsVariables {
  final String actorId;
  late final Optional<InteractionType>type;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ListInteractionsVariables.fromJson(Map<String, dynamic> json):
  
  actorId = nativeFromJson<String>(json['actorId']) {
  
  
  
    type = Optional.optional((data) => InteractionType.values.byName(data), enumSerializer);
    type.value = json['type'] == null ? null : InteractionType.values.byName(json['type']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListInteractionsVariables otherTyped = other as ListInteractionsVariables;
    return actorId == otherTyped.actorId && 
    type == otherTyped.type;
    
  }
  @override
  int get hashCode => Object.hashAll([actorId.hashCode, type.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['actorId'] = nativeToJson<String>(actorId);
    if(type.state == OptionalState.set) {
      json['type'] = type.toJson();
    }
    return json;
  }

  ListInteractionsVariables({
    required this.actorId,
    required this.type,
  });
}

