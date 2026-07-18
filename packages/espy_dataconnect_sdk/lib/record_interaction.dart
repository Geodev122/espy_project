part of 'espy.dart';

class RecordInteractionVariablesBuilder {
  String targetId;
  InteractionType type;

  final FirebaseDataConnect _dataConnect;
  RecordInteractionVariablesBuilder(this._dataConnect, {required  this.targetId,required  this.type,});
  Deserializer<RecordInteractionData> dataDeserializer = (dynamic json)  => RecordInteractionData.fromJson(jsonDecode(json));
  Serializer<RecordInteractionVariables> varsSerializer = (RecordInteractionVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<RecordInteractionData, RecordInteractionVariables>> execute() {
    return ref().execute();
  }

  MutationRef<RecordInteractionData, RecordInteractionVariables> ref() {
    RecordInteractionVariables vars= RecordInteractionVariables(targetId: targetId,type: type,);
    return _dataConnect.mutation("RecordInteraction", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class RecordInteractionInteractionInsert {
  final String id;
  RecordInteractionInteractionInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final RecordInteractionInteractionInsert otherTyped = other as RecordInteractionInteractionInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  RecordInteractionInteractionInsert({
    required this.id,
  });
}

@immutable
class RecordInteractionData {
  final RecordInteractionInteractionInsert interaction_insert;
  RecordInteractionData.fromJson(dynamic json):
  
  interaction_insert = RecordInteractionInteractionInsert.fromJson(json['interaction_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final RecordInteractionData otherTyped = other as RecordInteractionData;
    return interaction_insert == otherTyped.interaction_insert;
    
  }
  @override
  int get hashCode => interaction_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['interaction_insert'] = interaction_insert.toJson();
    return json;
  }

  RecordInteractionData({
    required this.interaction_insert,
  });
}

@immutable
class RecordInteractionVariables {
  final String targetId;
  final InteractionType type;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  RecordInteractionVariables.fromJson(Map<String, dynamic> json):
  
  targetId = nativeFromJson<String>(json['targetId']),
  type = InteractionType.values.byName(json['type']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final RecordInteractionVariables otherTyped = other as RecordInteractionVariables;
    return targetId == otherTyped.targetId && 
    type == otherTyped.type;
    
  }
  @override
  int get hashCode => Object.hashAll([targetId.hashCode, type.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['targetId'] = nativeToJson<String>(targetId);
    json['type'] = 
    type.name
    ;
    return json;
  }

  RecordInteractionVariables({
    required this.targetId,
    required this.type,
  });
}

