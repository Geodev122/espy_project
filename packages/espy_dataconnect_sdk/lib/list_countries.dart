part of 'espy.dart';

class ListCountriesVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  ListCountriesVariablesBuilder(this._dataConnect, );
  Deserializer<ListCountriesData> dataDeserializer = (dynamic json)  => ListCountriesData.fromJson(jsonDecode(json));
  
  Future<QueryResult<ListCountriesData, void>> execute() {
    return ref().execute();
  }

  QueryRef<ListCountriesData, void> ref() {
    
    return _dataConnect.query("ListCountries", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class ListCountriesCountries {
  final String id;
  final String nameEn;
  final String? nameAr;
  final String? flagEmoji;
  ListCountriesCountries.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  nameEn = nativeFromJson<String>(json['nameEn']),
  nameAr = json['nameAr'] == null ? null : nativeFromJson<String>(json['nameAr']),
  flagEmoji = json['flagEmoji'] == null ? null : nativeFromJson<String>(json['flagEmoji']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListCountriesCountries otherTyped = other as ListCountriesCountries;
    return id == otherTyped.id && 
    nameEn == otherTyped.nameEn && 
    nameAr == otherTyped.nameAr && 
    flagEmoji == otherTyped.flagEmoji;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, nameEn.hashCode, nameAr.hashCode, flagEmoji.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['nameEn'] = nativeToJson<String>(nameEn);
    if (nameAr != null) {
      json['nameAr'] = nativeToJson<String?>(nameAr);
    }
    if (flagEmoji != null) {
      json['flagEmoji'] = nativeToJson<String?>(flagEmoji);
    }
    return json;
  }

  ListCountriesCountries({
    required this.id,
    required this.nameEn,
    this.nameAr,
    this.flagEmoji,
  });
}

@immutable
class ListCountriesData {
  final List<ListCountriesCountries> countries;
  ListCountriesData.fromJson(dynamic json):
  
  countries = (json['countries'] as List<dynamic>)
        .map((e) => ListCountriesCountries.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListCountriesData otherTyped = other as ListCountriesData;
    return countries == otherTyped.countries;
    
  }
  @override
  int get hashCode => countries.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['countries'] = countries.map((e) => e.toJson()).toList();
    return json;
  }

  ListCountriesData({
    required this.countries,
  });
}

