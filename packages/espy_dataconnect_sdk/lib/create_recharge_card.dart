part of 'espy.dart';

class CreateRechargeCardVariablesBuilder {
  String code;
  int value;
  int pins;
  int slots;

  final FirebaseDataConnect _dataConnect;
  CreateRechargeCardVariablesBuilder(this._dataConnect, {required  this.code,required  this.value,required  this.pins,required  this.slots,});
  Deserializer<CreateRechargeCardData> dataDeserializer = (dynamic json)  => CreateRechargeCardData.fromJson(jsonDecode(json));
  Serializer<CreateRechargeCardVariables> varsSerializer = (CreateRechargeCardVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreateRechargeCardData, CreateRechargeCardVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CreateRechargeCardData, CreateRechargeCardVariables> ref() {
    CreateRechargeCardVariables vars= CreateRechargeCardVariables(code: code,value: value,pins: pins,slots: slots,);
    return _dataConnect.mutation("CreateRechargeCard", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CreateRechargeCardRechargeCardInsert {
  final String id;
  CreateRechargeCardRechargeCardInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateRechargeCardRechargeCardInsert otherTyped = other as CreateRechargeCardRechargeCardInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateRechargeCardRechargeCardInsert({
    required this.id,
  });
}

@immutable
class CreateRechargeCardData {
  final CreateRechargeCardRechargeCardInsert rechargeCard_insert;
  CreateRechargeCardData.fromJson(dynamic json):
  
  rechargeCard_insert = CreateRechargeCardRechargeCardInsert.fromJson(json['rechargeCard_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateRechargeCardData otherTyped = other as CreateRechargeCardData;
    return rechargeCard_insert == otherTyped.rechargeCard_insert;
    
  }
  @override
  int get hashCode => rechargeCard_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['rechargeCard_insert'] = rechargeCard_insert.toJson();
    return json;
  }

  CreateRechargeCardData({
    required this.rechargeCard_insert,
  });
}

@immutable
class CreateRechargeCardVariables {
  final String code;
  final int value;
  final int pins;
  final int slots;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CreateRechargeCardVariables.fromJson(Map<String, dynamic> json):
  
  code = nativeFromJson<String>(json['code']),
  value = nativeFromJson<int>(json['value']),
  pins = nativeFromJson<int>(json['pins']),
  slots = nativeFromJson<int>(json['slots']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateRechargeCardVariables otherTyped = other as CreateRechargeCardVariables;
    return code == otherTyped.code && 
    value == otherTyped.value && 
    pins == otherTyped.pins && 
    slots == otherTyped.slots;
    
  }
  @override
  int get hashCode => Object.hashAll([code.hashCode, value.hashCode, pins.hashCode, slots.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['code'] = nativeToJson<String>(code);
    json['value'] = nativeToJson<int>(value);
    json['pins'] = nativeToJson<int>(pins);
    json['slots'] = nativeToJson<int>(slots);
    return json;
  }

  CreateRechargeCardVariables({
    required this.code,
    required this.value,
    required this.pins,
    required this.slots,
  });
}

