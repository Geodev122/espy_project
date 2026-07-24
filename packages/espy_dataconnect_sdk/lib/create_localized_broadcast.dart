part of 'espy.dart';

class CreateLocalizedBroadcastVariablesBuilder {
  String title;
  String message;
  Optional<String> _country = Optional.optional(nativeFromJson, nativeToJson);
  Optional<String> _region = Optional.optional(nativeFromJson, nativeToJson);
  Optional<String> _city = Optional.optional(nativeFromJson, nativeToJson);
  Optional<ModerationStatus> _status = Optional.optional((data) => ModerationStatus.values.byName(data), enumSerializer);

  final FirebaseDataConnect _dataConnect;  CreateLocalizedBroadcastVariablesBuilder country(String? t) {
   _country.value = t;
   return this;
  }
  CreateLocalizedBroadcastVariablesBuilder region(String? t) {
   _region.value = t;
   return this;
  }
  CreateLocalizedBroadcastVariablesBuilder city(String? t) {
   _city.value = t;
   return this;
  }
  CreateLocalizedBroadcastVariablesBuilder status(ModerationStatus? t) {
   _status.value = t;
   return this;
  }

  CreateLocalizedBroadcastVariablesBuilder(this._dataConnect, {required  this.title,required  this.message,});
  Deserializer<CreateLocalizedBroadcastData> dataDeserializer = (dynamic json)  => CreateLocalizedBroadcastData.fromJson(jsonDecode(json));
  Serializer<CreateLocalizedBroadcastVariables> varsSerializer = (CreateLocalizedBroadcastVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreateLocalizedBroadcastData, CreateLocalizedBroadcastVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CreateLocalizedBroadcastData, CreateLocalizedBroadcastVariables> ref() {
    CreateLocalizedBroadcastVariables vars= CreateLocalizedBroadcastVariables(title: title,message: message,country: _country,region: _region,city: _city,status: _status,);
    return _dataConnect.mutation("CreateLocalizedBroadcast", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CreateLocalizedBroadcastBroadcastInsert {
  final String id;
  CreateLocalizedBroadcastBroadcastInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateLocalizedBroadcastBroadcastInsert otherTyped = other as CreateLocalizedBroadcastBroadcastInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateLocalizedBroadcastBroadcastInsert({
    required this.id,
  });
}

@immutable
class CreateLocalizedBroadcastData {
  final CreateLocalizedBroadcastBroadcastInsert broadcast_insert;
  CreateLocalizedBroadcastData.fromJson(dynamic json):
  
  broadcast_insert = CreateLocalizedBroadcastBroadcastInsert.fromJson(json['broadcast_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateLocalizedBroadcastData otherTyped = other as CreateLocalizedBroadcastData;
    return broadcast_insert == otherTyped.broadcast_insert;
    
  }
  @override
  int get hashCode => broadcast_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['broadcast_insert'] = broadcast_insert.toJson();
    return json;
  }

  CreateLocalizedBroadcastData({
    required this.broadcast_insert,
  });
}

@immutable
class CreateLocalizedBroadcastVariables {
  final String title;
  final String message;
  late final Optional<String>country;
  late final Optional<String>region;
  late final Optional<String>city;
  late final Optional<ModerationStatus>status;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CreateLocalizedBroadcastVariables.fromJson(Map<String, dynamic> json):
  
  title = nativeFromJson<String>(json['title']),
  message = nativeFromJson<String>(json['message']) {
  
  
  
  
    country = Optional.optional(nativeFromJson, nativeToJson);
    country.value = json['country'] == null ? null : nativeFromJson<String>(json['country']);
  
  
    region = Optional.optional(nativeFromJson, nativeToJson);
    region.value = json['region'] == null ? null : nativeFromJson<String>(json['region']);
  
  
    city = Optional.optional(nativeFromJson, nativeToJson);
    city.value = json['city'] == null ? null : nativeFromJson<String>(json['city']);
  
  
    status = Optional.optional((data) => ModerationStatus.values.byName(data), enumSerializer);
    status.value = json['status'] == null ? null : ModerationStatus.values.byName(json['status']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateLocalizedBroadcastVariables otherTyped = other as CreateLocalizedBroadcastVariables;
    return title == otherTyped.title && 
    message == otherTyped.message && 
    country == otherTyped.country && 
    region == otherTyped.region && 
    city == otherTyped.city && 
    status == otherTyped.status;
    
  }
  @override
  int get hashCode => Object.hashAll([title.hashCode, message.hashCode, country.hashCode, region.hashCode, city.hashCode, status.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['title'] = nativeToJson<String>(title);
    json['message'] = nativeToJson<String>(message);
    if(country.state == OptionalState.set) {
      json['country'] = country.toJson();
    }
    if(region.state == OptionalState.set) {
      json['region'] = region.toJson();
    }
    if(city.state == OptionalState.set) {
      json['city'] = city.toJson();
    }
    if(status.state == OptionalState.set) {
      json['status'] = status.toJson();
    }
    return json;
  }

  CreateLocalizedBroadcastVariables({
    required this.title,
    required this.message,
    required this.country,
    required this.region,
    required this.city,
    required this.status,
  });
}

