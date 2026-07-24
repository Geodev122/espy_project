part of 'espy.dart';

class ListSupportTicketsVariablesBuilder {
  Optional<SupportTicketStatus> _status = Optional.optional((data) => SupportTicketStatus.values.byName(data), enumSerializer);

  final FirebaseDataConnect _dataConnect;
  ListSupportTicketsVariablesBuilder status(SupportTicketStatus? t) {
   _status.value = t;
   return this;
  }

  ListSupportTicketsVariablesBuilder(this._dataConnect, );
  Deserializer<ListSupportTicketsData> dataDeserializer = (dynamic json)  => ListSupportTicketsData.fromJson(jsonDecode(json));
  Serializer<ListSupportTicketsVariables> varsSerializer = (ListSupportTicketsVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<ListSupportTicketsData, ListSupportTicketsVariables>> execute() {
    return ref().execute();
  }

  QueryRef<ListSupportTicketsData, ListSupportTicketsVariables> ref() {
    ListSupportTicketsVariables vars= ListSupportTicketsVariables(status: _status,);
    return _dataConnect.query("ListSupportTickets", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ListSupportTicketsSupportTickets {
  final String id;
  final String subject;
  final String message;
  final EnumValue<SupportTicketStatus> status;
  final Timestamp createdAt;
  final ListSupportTicketsSupportTicketsUser user;
  ListSupportTicketsSupportTickets.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  subject = nativeFromJson<String>(json['subject']),
  message = nativeFromJson<String>(json['message']),
  status = supportTicketStatusDeserializer(json['status']),
  createdAt = Timestamp.fromJson(json['createdAt']),
  user = ListSupportTicketsSupportTicketsUser.fromJson(json['user']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListSupportTicketsSupportTickets otherTyped = other as ListSupportTicketsSupportTickets;
    return id == otherTyped.id && 
    subject == otherTyped.subject && 
    message == otherTyped.message && 
    status == otherTyped.status && 
    createdAt == otherTyped.createdAt && 
    user == otherTyped.user;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, subject.hashCode, message.hashCode, status.hashCode, createdAt.hashCode, user.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['subject'] = nativeToJson<String>(subject);
    json['message'] = nativeToJson<String>(message);
    json['status'] = 
    supportTicketStatusSerializer(status)
    ;
    json['createdAt'] = createdAt.toJson();
    json['user'] = user.toJson();
    return json;
  }

  ListSupportTicketsSupportTickets({
    required this.id,
    required this.subject,
    required this.message,
    required this.status,
    required this.createdAt,
    required this.user,
  });
}

@immutable
class ListSupportTicketsSupportTicketsUser {
  final String id;
  final String email;
  final String? name;
  ListSupportTicketsSupportTicketsUser.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  email = nativeFromJson<String>(json['email']),
  name = json['name'] == null ? null : nativeFromJson<String>(json['name']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListSupportTicketsSupportTicketsUser otherTyped = other as ListSupportTicketsSupportTicketsUser;
    return id == otherTyped.id && 
    email == otherTyped.email && 
    name == otherTyped.name;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, email.hashCode, name.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['email'] = nativeToJson<String>(email);
    if (name != null) {
      json['name'] = nativeToJson<String?>(name);
    }
    return json;
  }

  ListSupportTicketsSupportTicketsUser({
    required this.id,
    required this.email,
    this.name,
  });
}

@immutable
class ListSupportTicketsData {
  final List<ListSupportTicketsSupportTickets> supportTickets;
  ListSupportTicketsData.fromJson(dynamic json):
  
  supportTickets = (json['supportTickets'] as List<dynamic>)
        .map((e) => ListSupportTicketsSupportTickets.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListSupportTicketsData otherTyped = other as ListSupportTicketsData;
    return supportTickets == otherTyped.supportTickets;
    
  }
  @override
  int get hashCode => supportTickets.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['supportTickets'] = supportTickets.map((e) => e.toJson()).toList();
    return json;
  }

  ListSupportTicketsData({
    required this.supportTickets,
  });
}

@immutable
class ListSupportTicketsVariables {
  late final Optional<SupportTicketStatus>status;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ListSupportTicketsVariables.fromJson(Map<String, dynamic> json) {
  
  
    status = Optional.optional((data) => SupportTicketStatus.values.byName(data), enumSerializer);
    status.value = json['status'] == null ? null : SupportTicketStatus.values.byName(json['status']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListSupportTicketsVariables otherTyped = other as ListSupportTicketsVariables;
    return status == otherTyped.status;
    
  }
  @override
  int get hashCode => status.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if(status.state == OptionalState.set) {
      json['status'] = status.toJson();
    }
    return json;
  }

  ListSupportTicketsVariables({
    required this.status,
  });
}

