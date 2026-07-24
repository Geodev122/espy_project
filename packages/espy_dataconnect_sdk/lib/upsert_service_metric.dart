part of 'espy.dart';

class UpsertServiceMetricVariablesBuilder {
  String serviceId;
  Optional<int> _views = Optional.optional(nativeFromJson, nativeToJson);
  Optional<int> _contacts = Optional.optional(nativeFromJson, nativeToJson);
  Optional<int> _shares = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;  UpsertServiceMetricVariablesBuilder views(int? t) {
   _views.value = t;
   return this;
  }
  UpsertServiceMetricVariablesBuilder contacts(int? t) {
   _contacts.value = t;
   return this;
  }
  UpsertServiceMetricVariablesBuilder shares(int? t) {
   _shares.value = t;
   return this;
  }

  UpsertServiceMetricVariablesBuilder(this._dataConnect, {required  this.serviceId,});
  Deserializer<UpsertServiceMetricData> dataDeserializer = (dynamic json)  => UpsertServiceMetricData.fromJson(jsonDecode(json));
  Serializer<UpsertServiceMetricVariables> varsSerializer = (UpsertServiceMetricVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpsertServiceMetricData, UpsertServiceMetricVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpsertServiceMetricData, UpsertServiceMetricVariables> ref() {
    UpsertServiceMetricVariables vars= UpsertServiceMetricVariables(serviceId: serviceId,views: _views,contacts: _contacts,shares: _shares,);
    return _dataConnect.mutation("UpsertServiceMetric", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpsertServiceMetricServiceMetricUpsert {
  final String serviceId;
  UpsertServiceMetricServiceMetricUpsert.fromJson(dynamic json):
  
  serviceId = nativeFromJson<String>(json['serviceId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertServiceMetricServiceMetricUpsert otherTyped = other as UpsertServiceMetricServiceMetricUpsert;
    return serviceId == otherTyped.serviceId;
    
  }
  @override
  int get hashCode => serviceId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['serviceId'] = nativeToJson<String>(serviceId);
    return json;
  }

  UpsertServiceMetricServiceMetricUpsert({
    required this.serviceId,
  });
}

@immutable
class UpsertServiceMetricData {
  final UpsertServiceMetricServiceMetricUpsert serviceMetric_upsert;
  UpsertServiceMetricData.fromJson(dynamic json):
  
  serviceMetric_upsert = UpsertServiceMetricServiceMetricUpsert.fromJson(json['serviceMetric_upsert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertServiceMetricData otherTyped = other as UpsertServiceMetricData;
    return serviceMetric_upsert == otherTyped.serviceMetric_upsert;
    
  }
  @override
  int get hashCode => serviceMetric_upsert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['serviceMetric_upsert'] = serviceMetric_upsert.toJson();
    return json;
  }

  UpsertServiceMetricData({
    required this.serviceMetric_upsert,
  });
}

@immutable
class UpsertServiceMetricVariables {
  final String serviceId;
  late final Optional<int>views;
  late final Optional<int>contacts;
  late final Optional<int>shares;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpsertServiceMetricVariables.fromJson(Map<String, dynamic> json):
  
  serviceId = nativeFromJson<String>(json['serviceId']) {
  
  
  
    views = Optional.optional(nativeFromJson, nativeToJson);
    views.value = json['views'] == null ? null : nativeFromJson<int>(json['views']);
  
  
    contacts = Optional.optional(nativeFromJson, nativeToJson);
    contacts.value = json['contacts'] == null ? null : nativeFromJson<int>(json['contacts']);
  
  
    shares = Optional.optional(nativeFromJson, nativeToJson);
    shares.value = json['shares'] == null ? null : nativeFromJson<int>(json['shares']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertServiceMetricVariables otherTyped = other as UpsertServiceMetricVariables;
    return serviceId == otherTyped.serviceId && 
    views == otherTyped.views && 
    contacts == otherTyped.contacts && 
    shares == otherTyped.shares;
    
  }
  @override
  int get hashCode => Object.hashAll([serviceId.hashCode, views.hashCode, contacts.hashCode, shares.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['serviceId'] = nativeToJson<String>(serviceId);
    if(views.state == OptionalState.set) {
      json['views'] = views.toJson();
    }
    if(contacts.state == OptionalState.set) {
      json['contacts'] = contacts.toJson();
    }
    if(shares.state == OptionalState.set) {
      json['shares'] = shares.toJson();
    }
    return json;
  }

  UpsertServiceMetricVariables({
    required this.serviceId,
    required this.views,
    required this.contacts,
    required this.shares,
  });
}

