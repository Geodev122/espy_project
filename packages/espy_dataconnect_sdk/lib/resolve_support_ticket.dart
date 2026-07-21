part of 'espy.dart';

class ResolveSupportTicketVariablesBuilder {
  String id;
  Optional<String> _adminNote = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;  ResolveSupportTicketVariablesBuilder adminNote(String? t) {
   _adminNote.value = t;
   return this;
  }

  ResolveSupportTicketVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<ResolveSupportTicketData> dataDeserializer = (dynamic json)  => ResolveSupportTicketData.fromJson(jsonDecode(json));
  Serializer<ResolveSupportTicketVariables> varsSerializer = (ResolveSupportTicketVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<ResolveSupportTicketData, ResolveSupportTicketVariables>> execute() {
    return ref().execute();
  }

  MutationRef<ResolveSupportTicketData, ResolveSupportTicketVariables> ref() {
    ResolveSupportTicketVariables vars= ResolveSupportTicketVariables(id: id,adminNote: _adminNote,);
    return _dataConnect.mutation("ResolveSupportTicket", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ResolveSupportTicketSupportTicketUpdate {
  final String id;
  ResolveSupportTicketSupportTicketUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ResolveSupportTicketSupportTicketUpdate otherTyped = other as ResolveSupportTicketSupportTicketUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  ResolveSupportTicketSupportTicketUpdate({
    required this.id,
  });
}

@immutable
class ResolveSupportTicketData {
  final ResolveSupportTicketSupportTicketUpdate? supportTicket_update;
  ResolveSupportTicketData.fromJson(dynamic json):
  
  supportTicket_update = json['supportTicket_update'] == null ? null : ResolveSupportTicketSupportTicketUpdate.fromJson(json['supportTicket_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ResolveSupportTicketData otherTyped = other as ResolveSupportTicketData;
    return supportTicket_update == otherTyped.supportTicket_update;
    
  }
  @override
  int get hashCode => supportTicket_update.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (supportTicket_update != null) {
      json['supportTicket_update'] = supportTicket_update!.toJson();
    }
    return json;
  }

  ResolveSupportTicketData({
    this.supportTicket_update,
  });
}

@immutable
class ResolveSupportTicketVariables {
  final String id;
  late final Optional<String>adminNote;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ResolveSupportTicketVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']) {
  
  
  
    adminNote = Optional.optional(nativeFromJson, nativeToJson);
    adminNote.value = json['adminNote'] == null ? null : nativeFromJson<String>(json['adminNote']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ResolveSupportTicketVariables otherTyped = other as ResolveSupportTicketVariables;
    return id == otherTyped.id && 
    adminNote == otherTyped.adminNote;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, adminNote.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    if(adminNote.state == OptionalState.set) {
      json['adminNote'] = adminNote.toJson();
    }
    return json;
  }

  ResolveSupportTicketVariables({
    required this.id,
    required this.adminNote,
  });
}

