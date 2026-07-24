part of 'espy.dart';

class GetAnalyticsSnapshotsVariablesBuilder {
  Optional<DateTime> _start = Optional.optional(nativeFromJson, nativeToJson);
  Optional<DateTime> _end = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;
  GetAnalyticsSnapshotsVariablesBuilder start(DateTime? t) {
   _start.value = t;
   return this;
  }
  GetAnalyticsSnapshotsVariablesBuilder end(DateTime? t) {
   _end.value = t;
   return this;
  }

  GetAnalyticsSnapshotsVariablesBuilder(this._dataConnect, );
  Deserializer<GetAnalyticsSnapshotsData> dataDeserializer = (dynamic json)  => GetAnalyticsSnapshotsData.fromJson(jsonDecode(json));
  Serializer<GetAnalyticsSnapshotsVariables> varsSerializer = (GetAnalyticsSnapshotsVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetAnalyticsSnapshotsData, GetAnalyticsSnapshotsVariables>> execute() {
    return ref().execute();
  }

  QueryRef<GetAnalyticsSnapshotsData, GetAnalyticsSnapshotsVariables> ref() {
    GetAnalyticsSnapshotsVariables vars= GetAnalyticsSnapshotsVariables(start: _start,end: _end,);
    return _dataConnect.query("GetAnalyticsSnapshots", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetAnalyticsSnapshotsAnalyticsSnapshots {
  final String id;
  final DateTime date;
  final int totalUsers;
  final double totalRevenue;
  final int tokensBurned;
  final int activeRequests;
  final String? topSectorId;
  GetAnalyticsSnapshotsAnalyticsSnapshots.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  date = nativeFromJson<DateTime>(json['date']),
  totalUsers = nativeFromJson<int>(json['totalUsers']),
  totalRevenue = nativeFromJson<double>(json['totalRevenue']),
  tokensBurned = nativeFromJson<int>(json['tokensBurned']),
  activeRequests = nativeFromJson<int>(json['activeRequests']),
  topSectorId = json['topSectorId'] == null ? null : nativeFromJson<String>(json['topSectorId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetAnalyticsSnapshotsAnalyticsSnapshots otherTyped = other as GetAnalyticsSnapshotsAnalyticsSnapshots;
    return id == otherTyped.id && 
    date == otherTyped.date && 
    totalUsers == otherTyped.totalUsers && 
    totalRevenue == otherTyped.totalRevenue && 
    tokensBurned == otherTyped.tokensBurned && 
    activeRequests == otherTyped.activeRequests && 
    topSectorId == otherTyped.topSectorId;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, date.hashCode, totalUsers.hashCode, totalRevenue.hashCode, tokensBurned.hashCode, activeRequests.hashCode, topSectorId.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['date'] = nativeToJson<DateTime>(date);
    json['totalUsers'] = nativeToJson<int>(totalUsers);
    json['totalRevenue'] = nativeToJson<double>(totalRevenue);
    json['tokensBurned'] = nativeToJson<int>(tokensBurned);
    json['activeRequests'] = nativeToJson<int>(activeRequests);
    if (topSectorId != null) {
      json['topSectorId'] = nativeToJson<String?>(topSectorId);
    }
    return json;
  }

  GetAnalyticsSnapshotsAnalyticsSnapshots({
    required this.id,
    required this.date,
    required this.totalUsers,
    required this.totalRevenue,
    required this.tokensBurned,
    required this.activeRequests,
    this.topSectorId,
  });
}

@immutable
class GetAnalyticsSnapshotsData {
  final List<GetAnalyticsSnapshotsAnalyticsSnapshots> analyticsSnapshots;
  GetAnalyticsSnapshotsData.fromJson(dynamic json):
  
  analyticsSnapshots = (json['analyticsSnapshots'] as List<dynamic>)
        .map((e) => GetAnalyticsSnapshotsAnalyticsSnapshots.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetAnalyticsSnapshotsData otherTyped = other as GetAnalyticsSnapshotsData;
    return analyticsSnapshots == otherTyped.analyticsSnapshots;
    
  }
  @override
  int get hashCode => analyticsSnapshots.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['analyticsSnapshots'] = analyticsSnapshots.map((e) => e.toJson()).toList();
    return json;
  }

  GetAnalyticsSnapshotsData({
    required this.analyticsSnapshots,
  });
}

@immutable
class GetAnalyticsSnapshotsVariables {
  late final Optional<DateTime>start;
  late final Optional<DateTime>end;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetAnalyticsSnapshotsVariables.fromJson(Map<String, dynamic> json) {
  
  
    start = Optional.optional(nativeFromJson, nativeToJson);
    start.value = json['start'] == null ? null : nativeFromJson<DateTime>(json['start']);
  
  
    end = Optional.optional(nativeFromJson, nativeToJson);
    end.value = json['end'] == null ? null : nativeFromJson<DateTime>(json['end']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetAnalyticsSnapshotsVariables otherTyped = other as GetAnalyticsSnapshotsVariables;
    return start == otherTyped.start && 
    end == otherTyped.end;
    
  }
  @override
  int get hashCode => Object.hashAll([start.hashCode, end.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if(start.state == OptionalState.set) {
      json['start'] = start.toJson();
    }
    if(end.state == OptionalState.set) {
      json['end'] = end.toJson();
    }
    return json;
  }

  GetAnalyticsSnapshotsVariables({
    required this.start,
    required this.end,
  });
}

