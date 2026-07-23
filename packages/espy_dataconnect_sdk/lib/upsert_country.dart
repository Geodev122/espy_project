part of 'espy.dart';

class UpsertCountryVariablesBuilder {
  String id;
  String nameEn;
  String nameAr;
  Optional<String> _isoCode = Optional.optional(nativeFromJson, nativeToJson);
  Optional<String> _currency = Optional.optional(nativeFromJson, nativeToJson);
  Optional<String> _flagEmoji = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;  UpsertCountryVariablesBuilder isoCode(String? t) {
   _isoCode.value = t;
   return this;
  }
  UpsertCountryVariablesBuilder currency(String? t) {
   _currency.value = t;
   return this;
  }
  UpsertCountryVariablesBuilder flagEmoji(String? t) {
   _flagEmoji.value = t;
   return this;
  }

  UpsertCountryVariablesBuilder(this._dataConnect, {required  this.id,required  this.nameEn,required  this.nameAr,});
  Deserializer<UpsertCountryData> dataDeserializer = (dynamic json)  => UpsertCountryData.fromJson(jsonDecode(json));
  Serializer<UpsertCountryVariables> varsSerializer = (UpsertCountryVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpsertCountryData, UpsertCountryVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpsertCountryData, UpsertCountryVariables> ref() {
    UpsertCountryVariables vars= UpsertCountryVariables(id: id,nameEn: nameEn,nameAr: nameAr,isoCode: _isoCode,currency: _currency,flagEmoji: _flagEmoji,);
    return _dataConnect.mutation("UpsertCountry", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpsertCountryCountryUpsert {
  final String id;
  UpsertCountryCountryUpsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertCountryCountryUpsert otherTyped = other as UpsertCountryCountryUpsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpsertCountryCountryUpsert({
    required this.id,
  });
}

@immutable
class UpsertCountryData {
  final UpsertCountryCountryUpsert country_upsert;
  UpsertCountryData.fromJson(dynamic json):
  
  country_upsert = UpsertCountryCountryUpsert.fromJson(json['country_upsert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertCountryData otherTyped = other as UpsertCountryData;
    return country_upsert == otherTyped.country_upsert;
    
  }
  @override
  int get hashCode => country_upsert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['country_upsert'] = country_upsert.toJson();
    return json;
  }

  UpsertCountryData({
    required this.country_upsert,
  });
}

@immutable
class UpsertCountryVariables {
  final String id;
  final String nameEn;
  final String nameAr;
  late final Optional<String>isoCode;
  late final Optional<String>currency;
  late final Optional<String>flagEmoji;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpsertCountryVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']),
  nameEn = nativeFromJson<String>(json['nameEn']),
  nameAr = nativeFromJson<String>(json['nameAr']) {
  
  
  
  
  
    isoCode = Optional.optional(nativeFromJson, nativeToJson);
    isoCode.value = json['isoCode'] == null ? null : nativeFromJson<String>(json['isoCode']);
  
  
    currency = Optional.optional(nativeFromJson, nativeToJson);
    currency.value = json['currency'] == null ? null : nativeFromJson<String>(json['currency']);
  
  
    flagEmoji = Optional.optional(nativeFromJson, nativeToJson);
    flagEmoji.value = json['flagEmoji'] == null ? null : nativeFromJson<String>(json['flagEmoji']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertCountryVariables otherTyped = other as UpsertCountryVariables;
    return id == otherTyped.id && 
    nameEn == otherTyped.nameEn && 
    nameAr == otherTyped.nameAr && 
    isoCode == otherTyped.isoCode && 
    currency == otherTyped.currency && 
    flagEmoji == otherTyped.flagEmoji;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, nameEn.hashCode, nameAr.hashCode, isoCode.hashCode, currency.hashCode, flagEmoji.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['nameEn'] = nativeToJson<String>(nameEn);
    json['nameAr'] = nativeToJson<String>(nameAr);
    if(isoCode.state == OptionalState.set) {
      json['isoCode'] = isoCode.toJson();
    }
    if(currency.state == OptionalState.set) {
      json['currency'] = currency.toJson();
    }
    if(flagEmoji.state == OptionalState.set) {
      json['flagEmoji'] = flagEmoji.toJson();
    }
    return json;
  }

  UpsertCountryVariables({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.isoCode,
    required this.currency,
    required this.flagEmoji,
  });
}

