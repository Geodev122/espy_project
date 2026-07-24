part of 'espy.dart';

class IncrementServiceMetricVariablesBuilder {
  String serviceId;
  Optional<int> _views = Optional.optional(nativeFromJson, nativeToJson);
  Optional<int> _contacts = Optional.optional(nativeFromJson, nativeToJson);
  Optional<int> _shares = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;  IncrementServiceMetricVariablesBuilder views(int? t) {
   _views.value = t;
   return this;
  }
  IncrementServiceMetricVariablesBuilder contacts(int? t) {
   _contacts.value = t;
   return this;
  }
  IncrementServiceMetricVariablesBuilder shares(int? t) {
   _shares.value = t;
   return this;
  }

  IncrementServiceMetricVariablesBuilder(this._dataConnect, {required  this.serviceId,});
  Deserializer<IncrementServiceMetricData> dataDeserializer = (dynamic json)  => IncrementServiceMetricData.fromJson(jsonDecode(json));
  Serializer<IncrementServiceMetricVariables> varsSerializer = (IncrementServiceMetricVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<IncrementServiceMetricData, IncrementServiceMetricVariables>> execute() {
    return ref().execute();
  }

  MutationRef<IncrementServiceMetricData, IncrementServiceMetricVariables> ref() {
    IncrementServiceMetricVariables vars= IncrementServiceMetricVariables(serviceId: serviceId,views: _views,contacts: _contacts,shares: _shares,);
    return _dataConnect.mutation("IncrementServiceMetric", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class IncrementServiceMetricServiceMetricUpdate {
  final String serviceId;
  IncrementServiceMetricServiceMetricUpdate.fromJson(dynamic json):
  
  serviceId = nativeFromJson<String>(json['serviceId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final IncrementServiceMetricServiceMetricUpdate otherTyped = other as IncrementServiceMetricServiceMetricUpdate;
    return serviceId == otherTyped.serviceId;
    
  }
  @override
  int get hashCode => serviceId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['serviceId'] = nativeToJson<String>(serviceId);
    return json;
  }

  IncrementServiceMetricServiceMetricUpdate({
    required this.serviceId,
  });
}

@immutable
class IncrementServiceMetricData {
  final IncrementServiceMetricServiceMetricUpdate? serviceMetric_update;
  IncrementServiceMetricData.fromJson(dynamic json):
  
  serviceMetric_update = json['serviceMetric_update'] == null ? null : IncrementServiceMetricServiceMetricUpdate.fromJson(json['serviceMetric_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final IncrementServiceMetricData otherTyped = other as IncrementServiceMetricData;
    return serviceMetric_update == otherTyped.serviceMetric_update;
    
  }
  @override
  int get hashCode => serviceMetric_update.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (serviceMetric_update != null) {
      json['serviceMetric_update'] = serviceMetric_update!.toJson();
    }
    return json;
  }

  IncrementServiceMetricData({
    this.serviceMetric_update,
  });
}

@immutable
class IncrementServiceMetricVariables {
  final String serviceId;
  late final Optional<int>views;
  late final Optional<int>contacts;
  late final Optional<int>shares;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  IncrementServiceMetricVariables.fromJson(Map<String, dynamic> json):
  
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

    final IncrementServiceMetricVariables otherTyped = other as IncrementServiceMetricVariables;
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

  IncrementServiceMetricVariables({
    required this.serviceId,
    required this.views,
    required this.contacts,
    required this.shares,
  });
}

