part of 'espy.dart';

class GetServiceMetricVariablesBuilder {
  String serviceId;

  final FirebaseDataConnect _dataConnect;
  GetServiceMetricVariablesBuilder(this._dataConnect, {required  this.serviceId,});
  Deserializer<GetServiceMetricData> dataDeserializer = (dynamic json)  => GetServiceMetricData.fromJson(jsonDecode(json));
  Serializer<GetServiceMetricVariables> varsSerializer = (GetServiceMetricVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetServiceMetricData, GetServiceMetricVariables>> execute() {
    return ref().execute();
  }

  QueryRef<GetServiceMetricData, GetServiceMetricVariables> ref() {
    GetServiceMetricVariables vars= GetServiceMetricVariables(serviceId: serviceId,);
    return _dataConnect.query("GetServiceMetric", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetServiceMetricServiceMetric {
  final int? views;
  final int? contacts;
  final int? shares;
  final Timestamp? updatedAt;
  GetServiceMetricServiceMetric.fromJson(dynamic json):
  
  views = json['views'] == null ? null : nativeFromJson<int>(json['views']),
  contacts = json['contacts'] == null ? null : nativeFromJson<int>(json['contacts']),
  shares = json['shares'] == null ? null : nativeFromJson<int>(json['shares']),
  updatedAt = json['updatedAt'] == null ? null : Timestamp.fromJson(json['updatedAt']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetServiceMetricServiceMetric otherTyped = other as GetServiceMetricServiceMetric;
    return views == otherTyped.views && 
    contacts == otherTyped.contacts && 
    shares == otherTyped.shares && 
    updatedAt == otherTyped.updatedAt;
    
  }
  @override
  int get hashCode => Object.hashAll([views.hashCode, contacts.hashCode, shares.hashCode, updatedAt.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (views != null) {
      json['views'] = nativeToJson<int?>(views);
    }
    if (contacts != null) {
      json['contacts'] = nativeToJson<int?>(contacts);
    }
    if (shares != null) {
      json['shares'] = nativeToJson<int?>(shares);
    }
    if (updatedAt != null) {
      json['updatedAt'] = updatedAt!.toJson();
    }
    return json;
  }

  GetServiceMetricServiceMetric({
    this.views,
    this.contacts,
    this.shares,
    this.updatedAt,
  });
}

@immutable
class GetServiceMetricData {
  final GetServiceMetricServiceMetric? serviceMetric;
  GetServiceMetricData.fromJson(dynamic json):
  
  serviceMetric = json['serviceMetric'] == null ? null : GetServiceMetricServiceMetric.fromJson(json['serviceMetric']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetServiceMetricData otherTyped = other as GetServiceMetricData;
    return serviceMetric == otherTyped.serviceMetric;
    
  }
  @override
  int get hashCode => serviceMetric.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (serviceMetric != null) {
      json['serviceMetric'] = serviceMetric!.toJson();
    }
    return json;
  }

  GetServiceMetricData({
    this.serviceMetric,
  });
}

@immutable
class GetServiceMetricVariables {
  final String serviceId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetServiceMetricVariables.fromJson(Map<String, dynamic> json):
  
  serviceId = nativeFromJson<String>(json['serviceId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetServiceMetricVariables otherTyped = other as GetServiceMetricVariables;
    return serviceId == otherTyped.serviceId;
    
  }
  @override
  int get hashCode => serviceId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['serviceId'] = nativeToJson<String>(serviceId);
    return json;
  }

  GetServiceMetricVariables({
    required this.serviceId,
  });
}

