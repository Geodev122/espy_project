part of 'espy.dart';

class ListServiceMetricsVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  ListServiceMetricsVariablesBuilder(this._dataConnect, );
  Deserializer<ListServiceMetricsData> dataDeserializer = (dynamic json)  => ListServiceMetricsData.fromJson(jsonDecode(json));
  
  Future<QueryResult<ListServiceMetricsData, void>> execute() {
    return ref().execute();
  }

  QueryRef<ListServiceMetricsData, void> ref() {
    
    return _dataConnect.query("ListServiceMetrics", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class ListServiceMetricsServiceMetrics {
  final String serviceId;
  final int? views;
  final int? contacts;
  final int? shares;
  final Timestamp? updatedAt;
  final ListServiceMetricsServiceMetricsService service;
  ListServiceMetricsServiceMetrics.fromJson(dynamic json):
  
  serviceId = nativeFromJson<String>(json['serviceId']),
  views = json['views'] == null ? null : nativeFromJson<int>(json['views']),
  contacts = json['contacts'] == null ? null : nativeFromJson<int>(json['contacts']),
  shares = json['shares'] == null ? null : nativeFromJson<int>(json['shares']),
  updatedAt = json['updatedAt'] == null ? null : Timestamp.fromJson(json['updatedAt']),
  service = ListServiceMetricsServiceMetricsService.fromJson(json['service']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListServiceMetricsServiceMetrics otherTyped = other as ListServiceMetricsServiceMetrics;
    return serviceId == otherTyped.serviceId && 
    views == otherTyped.views && 
    contacts == otherTyped.contacts && 
    shares == otherTyped.shares && 
    updatedAt == otherTyped.updatedAt && 
    service == otherTyped.service;
    
  }
  @override
  int get hashCode => Object.hashAll([serviceId.hashCode, views.hashCode, contacts.hashCode, shares.hashCode, updatedAt.hashCode, service.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['serviceId'] = nativeToJson<String>(serviceId);
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
    json['service'] = service.toJson();
    return json;
  }

  ListServiceMetricsServiceMetrics({
    required this.serviceId,
    this.views,
    this.contacts,
    this.shares,
    this.updatedAt,
    required this.service,
  });
}

@immutable
class ListServiceMetricsServiceMetricsService {
  final String titleEn;
  final ListServiceMetricsServiceMetricsServiceProvider provider;
  ListServiceMetricsServiceMetricsService.fromJson(dynamic json):
  
  titleEn = nativeFromJson<String>(json['titleEn']),
  provider = ListServiceMetricsServiceMetricsServiceProvider.fromJson(json['provider']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListServiceMetricsServiceMetricsService otherTyped = other as ListServiceMetricsServiceMetricsService;
    return titleEn == otherTyped.titleEn && 
    provider == otherTyped.provider;
    
  }
  @override
  int get hashCode => Object.hashAll([titleEn.hashCode, provider.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['titleEn'] = nativeToJson<String>(titleEn);
    json['provider'] = provider.toJson();
    return json;
  }

  ListServiceMetricsServiceMetricsService({
    required this.titleEn,
    required this.provider,
  });
}

@immutable
class ListServiceMetricsServiceMetricsServiceProvider {
  final String? name;
  ListServiceMetricsServiceMetricsServiceProvider.fromJson(dynamic json):
  
  name = json['name'] == null ? null : nativeFromJson<String>(json['name']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListServiceMetricsServiceMetricsServiceProvider otherTyped = other as ListServiceMetricsServiceMetricsServiceProvider;
    return name == otherTyped.name;
    
  }
  @override
  int get hashCode => name.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (name != null) {
      json['name'] = nativeToJson<String?>(name);
    }
    return json;
  }

  ListServiceMetricsServiceMetricsServiceProvider({
    this.name,
  });
}

@immutable
class ListServiceMetricsData {
  final List<ListServiceMetricsServiceMetrics> serviceMetrics;
  ListServiceMetricsData.fromJson(dynamic json):
  
  serviceMetrics = (json['serviceMetrics'] as List<dynamic>)
        .map((e) => ListServiceMetricsServiceMetrics.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListServiceMetricsData otherTyped = other as ListServiceMetricsData;
    return serviceMetrics == otherTyped.serviceMetrics;
    
  }
  @override
  int get hashCode => serviceMetrics.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['serviceMetrics'] = serviceMetrics.map((e) => e.toJson()).toList();
    return json;
  }

  ListServiceMetricsData({
    required this.serviceMetrics,
  });
}

