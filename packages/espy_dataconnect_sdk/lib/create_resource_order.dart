part of 'espy.dart';

class CreateResourceOrderVariablesBuilder {
  int pins;
  int slots;
  int broadcasts;
  int total;

  final FirebaseDataConnect _dataConnect;
  CreateResourceOrderVariablesBuilder(this._dataConnect, {required  this.pins,required  this.slots,required  this.broadcasts,required  this.total,});
  Deserializer<CreateResourceOrderData> dataDeserializer = (dynamic json)  => CreateResourceOrderData.fromJson(jsonDecode(json));
  Serializer<CreateResourceOrderVariables> varsSerializer = (CreateResourceOrderVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreateResourceOrderData, CreateResourceOrderVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CreateResourceOrderData, CreateResourceOrderVariables> ref() {
    CreateResourceOrderVariables vars= CreateResourceOrderVariables(pins: pins,slots: slots,broadcasts: broadcasts,total: total,);
    return _dataConnect.mutation("CreateResourceOrder", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CreateResourceOrderResourceOrderInsert {
  final String id;
  CreateResourceOrderResourceOrderInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateResourceOrderResourceOrderInsert otherTyped = other as CreateResourceOrderResourceOrderInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateResourceOrderResourceOrderInsert({
    required this.id,
  });
}

@immutable
class CreateResourceOrderData {
  final CreateResourceOrderResourceOrderInsert resourceOrder_insert;
  CreateResourceOrderData.fromJson(dynamic json):
  
  resourceOrder_insert = CreateResourceOrderResourceOrderInsert.fromJson(json['resourceOrder_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateResourceOrderData otherTyped = other as CreateResourceOrderData;
    return resourceOrder_insert == otherTyped.resourceOrder_insert;
    
  }
  @override
  int get hashCode => resourceOrder_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['resourceOrder_insert'] = resourceOrder_insert.toJson();
    return json;
  }

  CreateResourceOrderData({
    required this.resourceOrder_insert,
  });
}

@immutable
class CreateResourceOrderVariables {
  final int pins;
  final int slots;
  final int broadcasts;
  final int total;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CreateResourceOrderVariables.fromJson(Map<String, dynamic> json):
  
  pins = nativeFromJson<int>(json['pins']),
  slots = nativeFromJson<int>(json['slots']),
  broadcasts = nativeFromJson<int>(json['broadcasts']),
  total = nativeFromJson<int>(json['total']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateResourceOrderVariables otherTyped = other as CreateResourceOrderVariables;
    return pins == otherTyped.pins && 
    slots == otherTyped.slots && 
    broadcasts == otherTyped.broadcasts && 
    total == otherTyped.total;
    
  }
  @override
  int get hashCode => Object.hashAll([pins.hashCode, slots.hashCode, broadcasts.hashCode, total.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['pins'] = nativeToJson<int>(pins);
    json['slots'] = nativeToJson<int>(slots);
    json['broadcasts'] = nativeToJson<int>(broadcasts);
    json['total'] = nativeToJson<int>(total);
    return json;
  }

  CreateResourceOrderVariables({
    required this.pins,
    required this.slots,
    required this.broadcasts,
    required this.total,
  });
}

