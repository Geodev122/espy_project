# espy_dataconnect_sdk SDK

## Installation
```sh
flutter pub get firebase_data_connect
flutterfire configure
```
For more information, see [Flutter for Firebase installation documentation](https://firebase.google.com/docs/data-connect/flutter-sdk#use-core).

## Data Connect instance
Each connector creates a static class, with an instance of the `DataConnect` class that can be used to connect to your Data Connect backend and call operations.

### Connecting to the emulator

```dart
String host = 'localhost'; // or your host name
int port = 9399; // or your port number
EspyConnector.instance.dataConnect.useDataConnectEmulator(host, port);
```

You can also call queries and mutations by using the connector class.
## Queries

### GetUser
#### Required Arguments
```dart
String uid = ...;
EspyConnector.instance.getUser(
  uid: uid,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetUserData, GetUserVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await EspyConnector.instance.getUser(
  uid: uid,
);
GetUserData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String uid = ...;

final ref = EspyConnector.instance.getUser(
  uid: uid,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetProfessionalDetails
#### Required Arguments
```dart
String uid = ...;
EspyConnector.instance.getProfessionalDetails(
  uid: uid,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetProfessionalDetailsData, GetProfessionalDetailsVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await EspyConnector.instance.getProfessionalDetails(
  uid: uid,
);
GetProfessionalDetailsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String uid = ...;

final ref = EspyConnector.instance.getProfessionalDetails(
  uid: uid,
).ref();
ref.execute();

ref.subscribe(...);
```


### ListSectors
#### Required Arguments
```dart
// No required arguments
EspyConnector.instance.listSectors().execute();
```



#### Return Type
`execute()` returns a `QueryResult<ListSectorsData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await EspyConnector.instance.listSectors();
ListSectorsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = EspyConnector.instance.listSectors().ref();
ref.execute();

ref.subscribe(...);
```


### ListCategories
#### Required Arguments
```dart
// No required arguments
EspyConnector.instance.listCategories().execute();
```

#### Optional Arguments
We return a builder for each query. For ListCategories, we created `ListCategoriesBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class ListCategoriesVariablesBuilder {
  ...
 
  ListCategoriesVariablesBuilder sectorId(String? t) {
   _sectorId.value = t;
   return this;
  }

  ...
}
EspyConnector.instance.listCategories()
.sectorId(sectorId)
.execute();
```

#### Return Type
`execute()` returns a `QueryResult<ListCategoriesData, ListCategoriesVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await EspyConnector.instance.listCategories();
ListCategoriesData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = EspyConnector.instance.listCategories().ref();
ref.execute();

ref.subscribe(...);
```


### ListRegions
#### Required Arguments
```dart
String countryId = ...;
EspyConnector.instance.listRegions(
  countryId: countryId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<ListRegionsData, ListRegionsVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await EspyConnector.instance.listRegions(
  countryId: countryId,
);
ListRegionsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String countryId = ...;

final ref = EspyConnector.instance.listRegions(
  countryId: countryId,
).ref();
ref.execute();

ref.subscribe(...);
```


### ListCities
#### Required Arguments
```dart
String regionId = ...;
EspyConnector.instance.listCities(
  regionId: regionId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<ListCitiesData, ListCitiesVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await EspyConnector.instance.listCities(
  regionId: regionId,
);
ListCitiesData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String regionId = ...;

final ref = EspyConnector.instance.listCities(
  regionId: regionId,
).ref();
ref.execute();

ref.subscribe(...);
```


### ListMetadataTags
#### Required Arguments
```dart
// No required arguments
EspyConnector.instance.listMetadataTags().execute();
```



#### Return Type
`execute()` returns a `QueryResult<ListMetadataTagsData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await EspyConnector.instance.listMetadataTags();
ListMetadataTagsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = EspyConnector.instance.listMetadataTags().ref();
ref.execute();

ref.subscribe(...);
```


### ListActiveServices
#### Required Arguments
```dart
// No required arguments
EspyConnector.instance.listActiveServices().execute();
```

#### Optional Arguments
We return a builder for each query. For ListActiveServices, we created `ListActiveServicesBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class ListActiveServicesVariablesBuilder {
  ...
 
  ListActiveServicesVariablesBuilder categoryId(String? t) {
   _categoryId.value = t;
   return this;
  }
  ListActiveServicesVariablesBuilder sectorId(String? t) {
   _sectorId.value = t;
   return this;
  }

  ...
}
EspyConnector.instance.listActiveServices()
.categoryId(categoryId)
.sectorId(sectorId)
.execute();
```

#### Return Type
`execute()` returns a `QueryResult<ListActiveServicesData, ListActiveServicesVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await EspyConnector.instance.listActiveServices();
ListActiveServicesData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = EspyConnector.instance.listActiveServices().ref();
ref.execute();

ref.subscribe(...);
```


### SearchServices
#### Required Arguments
```dart
// No required arguments
EspyConnector.instance.searchServices().execute();
```

#### Optional Arguments
We return a builder for each query. For SearchServices, we created `SearchServicesBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class SearchServicesVariablesBuilder {
  ...
 
  SearchServicesVariablesBuilder query(String? t) {
   _query.value = t;
   return this;
  }
  SearchServicesVariablesBuilder minPrice(int? t) {
   _minPrice.value = t;
   return this;
  }
  SearchServicesVariablesBuilder maxPrice(int? t) {
   _maxPrice.value = t;
   return this;
  }

  ...
}
EspyConnector.instance.searchServices()
.query(query)
.minPrice(minPrice)
.maxPrice(maxPrice)
.execute();
```

#### Return Type
`execute()` returns a `QueryResult<SearchServicesData, SearchServicesVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await EspyConnector.instance.searchServices();
SearchServicesData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = EspyConnector.instance.searchServices().ref();
ref.execute();

ref.subscribe(...);
```


### ListCountries
#### Required Arguments
```dart
// No required arguments
EspyConnector.instance.listCountries().execute();
```



#### Return Type
`execute()` returns a `QueryResult<ListCountriesData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await EspyConnector.instance.listCountries();
ListCountriesData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = EspyConnector.instance.listCountries().ref();
ref.execute();

ref.subscribe(...);
```


### ListLocationNodes
#### Required Arguments
```dart
String userId = ...;
EspyConnector.instance.listLocationNodes(
  userId: userId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<ListLocationNodesData, ListLocationNodesVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await EspyConnector.instance.listLocationNodes(
  userId: userId,
);
ListLocationNodesData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String userId = ...;

final ref = EspyConnector.instance.listLocationNodes(
  userId: userId,
).ref();
ref.execute();

ref.subscribe(...);
```


### ListFavoriteIds
#### Required Arguments
```dart
String actorId = ...;
EspyConnector.instance.listFavoriteIds(
  actorId: actorId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<ListFavoriteIdsData, ListFavoriteIdsVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await EspyConnector.instance.listFavoriteIds(
  actorId: actorId,
);
ListFavoriteIdsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String actorId = ...;

final ref = EspyConnector.instance.listFavoriteIds(
  actorId: actorId,
).ref();
ref.execute();

ref.subscribe(...);
```


### ListContactedIds
#### Required Arguments
```dart
String actorId = ...;
EspyConnector.instance.listContactedIds(
  actorId: actorId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<ListContactedIdsData, ListContactedIdsVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await EspyConnector.instance.listContactedIds(
  actorId: actorId,
);
ListContactedIdsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String actorId = ...;

final ref = EspyConnector.instance.listContactedIds(
  actorId: actorId,
).ref();
ref.execute();

ref.subscribe(...);
```


### ListInteractions
#### Required Arguments
```dart
String actorId = ...;
InteractionType type = ...;
EspyConnector.instance.listInteractions(
  actorId: actorId,
  type: type,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<ListInteractionsData, ListInteractionsVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await EspyConnector.instance.listInteractions(
  actorId: actorId,
  type: type,
);
ListInteractionsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String actorId = ...;
InteractionType type = ...;

final ref = EspyConnector.instance.listInteractions(
  actorId: actorId,
  type: type,
).ref();
ref.execute();

ref.subscribe(...);
```


### ListServiceRequests
#### Required Arguments
```dart
// No required arguments
EspyConnector.instance.listServiceRequests().execute();
```

#### Optional Arguments
We return a builder for each query. For ListServiceRequests, we created `ListServiceRequestsBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class ListServiceRequestsVariablesBuilder {
  ...
 
  ListServiceRequestsVariablesBuilder sectorId(String? t) {
   _sectorId.value = t;
   return this;
  }
  ListServiceRequestsVariablesBuilder status(CommunityRequestStatus? t) {
   _status.value = t;
   return this;
  }

  ...
}
EspyConnector.instance.listServiceRequests()
.sectorId(sectorId)
.status(status)
.execute();
```

#### Return Type
`execute()` returns a `QueryResult<ListServiceRequestsData, ListServiceRequestsVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await EspyConnector.instance.listServiceRequests();
ListServiceRequestsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = EspyConnector.instance.listServiceRequests().ref();
ref.execute();

ref.subscribe(...);
```


### GetWalletTransactions
#### Required Arguments
```dart
String userId = ...;
EspyConnector.instance.getWalletTransactions(
  userId: userId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetWalletTransactionsData, GetWalletTransactionsVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await EspyConnector.instance.getWalletTransactions(
  userId: userId,
);
GetWalletTransactionsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String userId = ...;

final ref = EspyConnector.instance.getWalletTransactions(
  userId: userId,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetActiveResourceOrder
#### Required Arguments
```dart
String userId = ...;
EspyConnector.instance.getActiveResourceOrder(
  userId: userId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetActiveResourceOrderData, GetActiveResourceOrderVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await EspyConnector.instance.getActiveResourceOrder(
  userId: userId,
);
GetActiveResourceOrderData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String userId = ...;

final ref = EspyConnector.instance.getActiveResourceOrder(
  userId: userId,
).ref();
ref.execute();

ref.subscribe(...);
```


### SearchUsersAdmin
#### Required Arguments
```dart
// No required arguments
EspyConnector.instance.searchUsersAdmin().execute();
```

#### Optional Arguments
We return a builder for each query. For SearchUsersAdmin, we created `SearchUsersAdminBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class SearchUsersAdminVariablesBuilder {
  ...
 
  SearchUsersAdminVariablesBuilder query(String? t) {
   _query.value = t;
   return this;
  }
  SearchUsersAdminVariablesBuilder role(UserRole? t) {
   _role.value = t;
   return this;
  }
  SearchUsersAdminVariablesBuilder hasProfile(bool? t) {
   _hasProfile.value = t;
   return this;
  }
  SearchUsersAdminVariablesBuilder isActive(bool? t) {
   _isActive.value = t;
   return this;
  }

  ...
}
EspyConnector.instance.searchUsersAdmin()
.query(query)
.role(role)
.hasProfile(hasProfile)
.isActive(isActive)
.execute();
```

#### Return Type
`execute()` returns a `QueryResult<SearchUsersAdminData, SearchUsersAdminVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await EspyConnector.instance.searchUsersAdmin();
SearchUsersAdminData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = EspyConnector.instance.searchUsersAdmin().ref();
ref.execute();

ref.subscribe(...);
```


### GetAuditDetails
#### Required Arguments
```dart
String id = ...;
EspyConnector.instance.getAuditDetails(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetAuditDetailsData, GetAuditDetailsVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await EspyConnector.instance.getAuditDetails(
  id: id,
);
GetAuditDetailsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = EspyConnector.instance.getAuditDetails(
  id: id,
).ref();
ref.execute();

ref.subscribe(...);
```


### ListRechargeCards
#### Required Arguments
```dart
// No required arguments
EspyConnector.instance.listRechargeCards().execute();
```



#### Return Type
`execute()` returns a `QueryResult<ListRechargeCardsData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await EspyConnector.instance.listRechargeCards();
ListRechargeCardsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = EspyConnector.instance.listRechargeCards().ref();
ref.execute();

ref.subscribe(...);
```


### ListPendingApprovals
#### Required Arguments
```dart
// No required arguments
EspyConnector.instance.listPendingApprovals().execute();
```



#### Return Type
`execute()` returns a `QueryResult<ListPendingApprovalsData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await EspyConnector.instance.listPendingApprovals();
ListPendingApprovalsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = EspyConnector.instance.listPendingApprovals().ref();
ref.execute();

ref.subscribe(...);
```


### ListPendingOrders
#### Required Arguments
```dart
// No required arguments
EspyConnector.instance.listPendingOrders().execute();
```



#### Return Type
`execute()` returns a `QueryResult<ListPendingOrdersData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await EspyConnector.instance.listPendingOrders();
ListPendingOrdersData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = EspyConnector.instance.listPendingOrders().ref();
ref.execute();

ref.subscribe(...);
```


### ListSupportTickets
#### Required Arguments
```dart
// No required arguments
EspyConnector.instance.listSupportTickets().execute();
```

#### Optional Arguments
We return a builder for each query. For ListSupportTickets, we created `ListSupportTicketsBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class ListSupportTicketsVariablesBuilder {
  ...
 
  ListSupportTicketsVariablesBuilder status(SupportTicketStatus? t) {
   _status.value = t;
   return this;
  }

  ...
}
EspyConnector.instance.listSupportTickets()
.status(status)
.execute();
```

#### Return Type
`execute()` returns a `QueryResult<ListSupportTicketsData, ListSupportTicketsVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await EspyConnector.instance.listSupportTickets();
ListSupportTicketsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = EspyConnector.instance.listSupportTickets().ref();
ref.execute();

ref.subscribe(...);
```


### ListServiceModerationQueue
#### Required Arguments
```dart
// No required arguments
EspyConnector.instance.listServiceModerationQueue().execute();
```

#### Optional Arguments
We return a builder for each query. For ListServiceModerationQueue, we created `ListServiceModerationQueueBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class ListServiceModerationQueueVariablesBuilder {
  ...
 
  ListServiceModerationQueueVariablesBuilder status(ModerationStatus? t) {
   _status.value = t;
   return this;
  }

  ...
}
EspyConnector.instance.listServiceModerationQueue()
.status(status)
.execute();
```

#### Return Type
`execute()` returns a `QueryResult<ListServiceModerationQueueData, ListServiceModerationQueueVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await EspyConnector.instance.listServiceModerationQueue();
ListServiceModerationQueueData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = EspyConnector.instance.listServiceModerationQueue().ref();
ref.execute();

ref.subscribe(...);
```


### ListRequestModerationQueue
#### Required Arguments
```dart
// No required arguments
EspyConnector.instance.listRequestModerationQueue().execute();
```

#### Optional Arguments
We return a builder for each query. For ListRequestModerationQueue, we created `ListRequestModerationQueueBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class ListRequestModerationQueueVariablesBuilder {
  ...
 
  ListRequestModerationQueueVariablesBuilder status(ModerationStatus? t) {
   _status.value = t;
   return this;
  }

  ...
}
EspyConnector.instance.listRequestModerationQueue()
.status(status)
.execute();
```

#### Return Type
`execute()` returns a `QueryResult<ListRequestModerationQueueData, ListRequestModerationQueueVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await EspyConnector.instance.listRequestModerationQueue();
ListRequestModerationQueueData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = EspyConnector.instance.listRequestModerationQueue().ref();
ref.execute();

ref.subscribe(...);
```


### ListTemplates
#### Required Arguments
```dart
// No required arguments
EspyConnector.instance.listTemplates().execute();
```



#### Return Type
`execute()` returns a `QueryResult<ListTemplatesData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await EspyConnector.instance.listTemplates();
ListTemplatesData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = EspyConnector.instance.listTemplates().ref();
ref.execute();

ref.subscribe(...);
```

## Mutations

### CreateUser
#### Required Arguments
```dart
String id = ...;
String email = ...;
UserRole role = ...;
EspyConnector.instance.createUser(
  id: id,
  email: email,
  role: role,
).execute();
```

#### Optional Arguments
We return a builder for each query. For CreateUser, we created `CreateUserBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class CreateUserVariablesBuilder {
  ...
   CreateUserVariablesBuilder name(String? t) {
   _name.value = t;
   return this;
  }

  ...
}
EspyConnector.instance.createUser(
  id: id,
  email: email,
  role: role,
)
.name(name)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<CreateUserData, CreateUserVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await EspyConnector.instance.createUser(
  id: id,
  email: email,
  role: role,
);
CreateUserData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
String email = ...;
UserRole role = ...;

final ref = EspyConnector.instance.createUser(
  id: id,
  email: email,
  role: role,
).ref();
ref.execute();
```


### UpsertUser
#### Required Arguments
```dart
String id = ...;
String email = ...;
UserRole role = ...;
EspyConnector.instance.upsertUser(
  id: id,
  email: email,
  role: role,
).execute();
```

#### Optional Arguments
We return a builder for each query. For UpsertUser, we created `UpsertUserBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class UpsertUserVariablesBuilder {
  ...
   UpsertUserVariablesBuilder name(String? t) {
   _name.value = t;
   return this;
  }

  ...
}
EspyConnector.instance.upsertUser(
  id: id,
  email: email,
  role: role,
)
.name(name)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<UpsertUserData, UpsertUserVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await EspyConnector.instance.upsertUser(
  id: id,
  email: email,
  role: role,
);
UpsertUserData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
String email = ...;
UserRole role = ...;

final ref = EspyConnector.instance.upsertUser(
  id: id,
  email: email,
  role: role,
).ref();
ref.execute();
```


### UpdateUserLastActive
#### Required Arguments
```dart
String id = ...;
EspyConnector.instance.updateUserLastActive(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<UpdateUserLastActiveData, UpdateUserLastActiveVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await EspyConnector.instance.updateUserLastActive(
  id: id,
);
UpdateUserLastActiveData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = EspyConnector.instance.updateUserLastActive(
  id: id,
).ref();
ref.execute();
```


### UpdateUserProfile
#### Required Arguments
```dart
String id = ...;
EspyConnector.instance.updateUserProfile(
  id: id,
).execute();
```

#### Optional Arguments
We return a builder for each query. For UpdateUserProfile, we created `UpdateUserProfileBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class UpdateUserProfileVariablesBuilder {
  ...
   UpdateUserProfileVariablesBuilder name(String? t) {
   _name.value = t;
   return this;
  }
  UpdateUserProfileVariablesBuilder photoUrl(String? t) {
   _photoUrl.value = t;
   return this;
  }
  UpdateUserProfileVariablesBuilder phone(String? t) {
   _phone.value = t;
   return this;
  }
  UpdateUserProfileVariablesBuilder whatsapp(String? t) {
   _whatsapp.value = t;
   return this;
  }

  ...
}
EspyConnector.instance.updateUserProfile(
  id: id,
)
.name(name)
.photoUrl(photoUrl)
.phone(phone)
.whatsapp(whatsapp)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<UpdateUserProfileData, UpdateUserProfileVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await EspyConnector.instance.updateUserProfile(
  id: id,
);
UpdateUserProfileData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = EspyConnector.instance.updateUserProfile(
  id: id,
).ref();
ref.execute();
```


### UpsertProfessionalProfile
#### Required Arguments
```dart
String id = ...;
EspyConnector.instance.upsertProfessionalProfile(
  id: id,
).execute();
```

#### Optional Arguments
We return a builder for each query. For UpsertProfessionalProfile, we created `UpsertProfessionalProfileBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class UpsertProfessionalProfileVariablesBuilder {
  ...
   UpsertProfessionalProfileVariablesBuilder fullNameAr(String? t) {
   _fullNameAr.value = t;
   return this;
  }
  UpsertProfessionalProfileVariablesBuilder specialty(String? t) {
   _specialty.value = t;
   return this;
  }
  UpsertProfessionalProfileVariablesBuilder specialtyAr(String? t) {
   _specialtyAr.value = t;
   return this;
  }
  UpsertProfessionalProfileVariablesBuilder bioEn(String? t) {
   _bioEn.value = t;
   return this;
  }
  UpsertProfessionalProfileVariablesBuilder bioAr(String? t) {
   _bioAr.value = t;
   return this;
  }

  ...
}
EspyConnector.instance.upsertProfessionalProfile(
  id: id,
)
.fullNameAr(fullNameAr)
.specialty(specialty)
.specialtyAr(specialtyAr)
.bioEn(bioEn)
.bioAr(bioAr)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<UpsertProfessionalProfileData, UpsertProfessionalProfileVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await EspyConnector.instance.upsertProfessionalProfile(
  id: id,
);
UpsertProfessionalProfileData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = EspyConnector.instance.upsertProfessionalProfile(
  id: id,
).ref();
ref.execute();
```


### UpsertInstitutionProfile
#### Required Arguments
```dart
String id = ...;
EspyConnector.instance.upsertInstitutionProfile(
  id: id,
).execute();
```

#### Optional Arguments
We return a builder for each query. For UpsertInstitutionProfile, we created `UpsertInstitutionProfileBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class UpsertInstitutionProfileVariablesBuilder {
  ...
   UpsertInstitutionProfileVariablesBuilder nameAr(String? t) {
   _nameAr.value = t;
   return this;
  }
  UpsertInstitutionProfileVariablesBuilder bioEn(String? t) {
   _bioEn.value = t;
   return this;
  }
  UpsertInstitutionProfileVariablesBuilder bioAr(String? t) {
   _bioAr.value = t;
   return this;
  }
  UpsertInstitutionProfileVariablesBuilder registrationNumber(String? t) {
   _registrationNumber.value = t;
   return this;
  }

  ...
}
EspyConnector.instance.upsertInstitutionProfile(
  id: id,
)
.nameAr(nameAr)
.bioEn(bioEn)
.bioAr(bioAr)
.registrationNumber(registrationNumber)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<UpsertInstitutionProfileData, UpsertInstitutionProfileVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await EspyConnector.instance.upsertInstitutionProfile(
  id: id,
);
UpsertInstitutionProfileData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = EspyConnector.instance.upsertInstitutionProfile(
  id: id,
).ref();
ref.execute();
```


### CreateService
#### Required Arguments
```dart
String categoryId = ...;
String sectorId = ...;
String titleEn = ...;
int price = ...;
EspyConnector.instance.createService(
  categoryId: categoryId,
  sectorId: sectorId,
  titleEn: titleEn,
  price: price,
).execute();
```

#### Optional Arguments
We return a builder for each query. For CreateService, we created `CreateServiceBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class CreateServiceVariablesBuilder {
  ...
   CreateServiceVariablesBuilder priceTagId(String? t) {
   _priceTagId.value = t;
   return this;
  }

  ...
}
EspyConnector.instance.createService(
  categoryId: categoryId,
  sectorId: sectorId,
  titleEn: titleEn,
  price: price,
)
.priceTagId(priceTagId)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<CreateServiceData, CreateServiceVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await EspyConnector.instance.createService(
  categoryId: categoryId,
  sectorId: sectorId,
  titleEn: titleEn,
  price: price,
);
CreateServiceData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String categoryId = ...;
String sectorId = ...;
String titleEn = ...;
int price = ...;

final ref = EspyConnector.instance.createService(
  categoryId: categoryId,
  sectorId: sectorId,
  titleEn: titleEn,
  price: price,
).ref();
ref.execute();
```


### UpdateService
#### Required Arguments
```dart
String id = ...;
EspyConnector.instance.updateService(
  id: id,
).execute();
```

#### Optional Arguments
We return a builder for each query. For UpdateService, we created `UpdateServiceBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class UpdateServiceVariablesBuilder {
  ...
   UpdateServiceVariablesBuilder isActive(bool? t) {
   _isActive.value = t;
   return this;
  }
  UpdateServiceVariablesBuilder isAllocated(bool? t) {
   _isAllocated.value = t;
   return this;
  }

  ...
}
EspyConnector.instance.updateService(
  id: id,
)
.isActive(isActive)
.isAllocated(isAllocated)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<UpdateServiceData, UpdateServiceVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await EspyConnector.instance.updateService(
  id: id,
);
UpdateServiceData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = EspyConnector.instance.updateService(
  id: id,
).ref();
ref.execute();
```


### CreateLocationNode
#### Required Arguments
```dart
String cityId = ...;
String label = ...;
double lat = ...;
double lng = ...;
bool isMain = ...;
EspyConnector.instance.createLocationNode(
  cityId: cityId,
  label: label,
  lat: lat,
  lng: lng,
  isMain: isMain,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<CreateLocationNodeData, CreateLocationNodeVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await EspyConnector.instance.createLocationNode(
  cityId: cityId,
  label: label,
  lat: lat,
  lng: lng,
  isMain: isMain,
);
CreateLocationNodeData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String cityId = ...;
String label = ...;
double lat = ...;
double lng = ...;
bool isMain = ...;

final ref = EspyConnector.instance.createLocationNode(
  cityId: cityId,
  label: label,
  lat: lat,
  lng: lng,
  isMain: isMain,
).ref();
ref.execute();
```


### CreateResourceOrder
#### Required Arguments
```dart
int pins = ...;
int slots = ...;
int broadcasts = ...;
int total = ...;
EspyConnector.instance.createResourceOrder(
  pins: pins,
  slots: slots,
  broadcasts: broadcasts,
  total: total,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<CreateResourceOrderData, CreateResourceOrderVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await EspyConnector.instance.createResourceOrder(
  pins: pins,
  slots: slots,
  broadcasts: broadcasts,
  total: total,
);
CreateResourceOrderData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
int pins = ...;
int slots = ...;
int broadcasts = ...;
int total = ...;

final ref = EspyConnector.instance.createResourceOrder(
  pins: pins,
  slots: slots,
  broadcasts: broadcasts,
  total: total,
).ref();
ref.execute();
```


### UpdateResourceOrder
#### Required Arguments
```dart
String id = ...;
int pins = ...;
int slots = ...;
int broadcasts = ...;
int total = ...;
EspyConnector.instance.updateResourceOrder(
  id: id,
  pins: pins,
  slots: slots,
  broadcasts: broadcasts,
  total: total,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<UpdateResourceOrderData, UpdateResourceOrderVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await EspyConnector.instance.updateResourceOrder(
  id: id,
  pins: pins,
  slots: slots,
  broadcasts: broadcasts,
  total: total,
);
UpdateResourceOrderData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
int pins = ...;
int slots = ...;
int broadcasts = ...;
int total = ...;

final ref = EspyConnector.instance.updateResourceOrder(
  id: id,
  pins: pins,
  slots: slots,
  broadcasts: broadcasts,
  total: total,
).ref();
ref.execute();
```


### SpendTokens
#### Required Arguments
```dart
String userId = ...;
int cost = ...;
int ledgerAmount = ...;
String description = ...;
EspyConnector.instance.spendTokens(
  userId: userId,
  cost: cost,
  ledgerAmount: ledgerAmount,
  description: description,
).execute();
```

#### Optional Arguments
We return a builder for each query. For SpendTokens, we created `SpendTokensBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class SpendTokensVariablesBuilder {
  ...
   SpendTokensVariablesBuilder type(TransactionType? t) {
   _type.value = t;
   return this;
  }

  ...
}
EspyConnector.instance.spendTokens(
  userId: userId,
  cost: cost,
  ledgerAmount: ledgerAmount,
  description: description,
)
.type(type)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<SpendTokensData, SpendTokensVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await EspyConnector.instance.spendTokens(
  userId: userId,
  cost: cost,
  ledgerAmount: ledgerAmount,
  description: description,
);
SpendTokensData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String userId = ...;
int cost = ...;
int ledgerAmount = ...;
String description = ...;

final ref = EspyConnector.instance.spendTokens(
  userId: userId,
  cost: cost,
  ledgerAmount: ledgerAmount,
  description: description,
).ref();
ref.execute();
```


### PostServiceRequest
#### Required Arguments
```dart
String sectorId = ...;
String descriptionEn = ...;
EspyConnector.instance.postServiceRequest(
  sectorId: sectorId,
  descriptionEn: descriptionEn,
).execute();
```

#### Optional Arguments
We return a builder for each query. For PostServiceRequest, we created `PostServiceRequestBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class PostServiceRequestVariablesBuilder {
  ...
   PostServiceRequestVariablesBuilder urgency(UrgencyLevel? t) {
   _urgency.value = t;
   return this;
  }
  PostServiceRequestVariablesBuilder preferredMode(DeliveryMode? t) {
   _preferredMode.value = t;
   return this;
  }

  ...
}
EspyConnector.instance.postServiceRequest(
  sectorId: sectorId,
  descriptionEn: descriptionEn,
)
.urgency(urgency)
.preferredMode(preferredMode)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<PostServiceRequestData, PostServiceRequestVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await EspyConnector.instance.postServiceRequest(
  sectorId: sectorId,
  descriptionEn: descriptionEn,
);
PostServiceRequestData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String sectorId = ...;
String descriptionEn = ...;

final ref = EspyConnector.instance.postServiceRequest(
  sectorId: sectorId,
  descriptionEn: descriptionEn,
).ref();
ref.execute();
```


### RecordInteraction
#### Required Arguments
```dart
String targetId = ...;
InteractionType type = ...;
EspyConnector.instance.recordInteraction(
  targetId: targetId,
  type: type,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<RecordInteractionData, RecordInteractionVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await EspyConnector.instance.recordInteraction(
  targetId: targetId,
  type: type,
);
RecordInteractionData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String targetId = ...;
InteractionType type = ...;

final ref = EspyConnector.instance.recordInteraction(
  targetId: targetId,
  type: type,
).ref();
ref.execute();
```


### UpdateUserAdmin
#### Required Arguments
```dart
String id = ...;
EspyConnector.instance.updateUserAdmin(
  id: id,
).execute();
```

#### Optional Arguments
We return a builder for each query. For UpdateUserAdmin, we created `UpdateUserAdminBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class UpdateUserAdminVariablesBuilder {
  ...
   UpdateUserAdminVariablesBuilder name(String? t) {
   _name.value = t;
   return this;
  }
  UpdateUserAdminVariablesBuilder role(UserRole? t) {
   _role.value = t;
   return this;
  }
  UpdateUserAdminVariablesBuilder isActive(bool? t) {
   _isActive.value = t;
   return this;
  }
  UpdateUserAdminVariablesBuilder phone(String? t) {
   _phone.value = t;
   return this;
  }
  UpdateUserAdminVariablesBuilder whatsapp(String? t) {
   _whatsapp.value = t;
   return this;
  }
  UpdateUserAdminVariablesBuilder notes(String? t) {
   _notes.value = t;
   return this;
  }
  UpdateUserAdminVariablesBuilder balance(int? t) {
   _balance.value = t;
   return this;
  }

  ...
}
EspyConnector.instance.updateUserAdmin(
  id: id,
)
.name(name)
.role(role)
.isActive(isActive)
.phone(phone)
.whatsapp(whatsapp)
.notes(notes)
.balance(balance)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<UpdateUserAdminData, UpdateUserAdminVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await EspyConnector.instance.updateUserAdmin(
  id: id,
);
UpdateUserAdminData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = EspyConnector.instance.updateUserAdmin(
  id: id,
).ref();
ref.execute();
```


### ToggleUserActiveStatus
#### Required Arguments
```dart
String id = ...;
bool isActive = ...;
EspyConnector.instance.toggleUserActiveStatus(
  id: id,
  isActive: isActive,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<ToggleUserActiveStatusData, ToggleUserActiveStatusVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await EspyConnector.instance.toggleUserActiveStatus(
  id: id,
  isActive: isActive,
);
ToggleUserActiveStatusData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
bool isActive = ...;

final ref = EspyConnector.instance.toggleUserActiveStatus(
  id: id,
  isActive: isActive,
).ref();
ref.execute();
```


### VerifyUserProfessional
#### Required Arguments
```dart
String id = ...;
bool isApproved = ...;
EspyConnector.instance.verifyUserProfessional(
  id: id,
  isApproved: isApproved,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<VerifyUserProfessionalData, VerifyUserProfessionalVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await EspyConnector.instance.verifyUserProfessional(
  id: id,
  isApproved: isApproved,
);
VerifyUserProfessionalData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
bool isApproved = ...;

final ref = EspyConnector.instance.verifyUserProfessional(
  id: id,
  isApproved: isApproved,
).ref();
ref.execute();
```


### VerifyUserInstitution
#### Required Arguments
```dart
String id = ...;
bool isApproved = ...;
EspyConnector.instance.verifyUserInstitution(
  id: id,
  isApproved: isApproved,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<VerifyUserInstitutionData, VerifyUserInstitutionVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await EspyConnector.instance.verifyUserInstitution(
  id: id,
  isApproved: isApproved,
);
VerifyUserInstitutionData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
bool isApproved = ...;

final ref = EspyConnector.instance.verifyUserInstitution(
  id: id,
  isApproved: isApproved,
).ref();
ref.execute();
```


### UpsertCountry
#### Required Arguments
```dart
String id = ...;
String nameEn = ...;
String nameAr = ...;
EspyConnector.instance.upsertCountry(
  id: id,
  nameEn: nameEn,
  nameAr: nameAr,
).execute();
```

#### Optional Arguments
We return a builder for each query. For UpsertCountry, we created `UpsertCountryBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class UpsertCountryVariablesBuilder {
  ...
   UpsertCountryVariablesBuilder isoCode(String? t) {
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

  ...
}
EspyConnector.instance.upsertCountry(
  id: id,
  nameEn: nameEn,
  nameAr: nameAr,
)
.isoCode(isoCode)
.currency(currency)
.flagEmoji(flagEmoji)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<UpsertCountryData, UpsertCountryVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await EspyConnector.instance.upsertCountry(
  id: id,
  nameEn: nameEn,
  nameAr: nameAr,
);
UpsertCountryData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
String nameEn = ...;
String nameAr = ...;

final ref = EspyConnector.instance.upsertCountry(
  id: id,
  nameEn: nameEn,
  nameAr: nameAr,
).ref();
ref.execute();
```


### UpsertRegion
#### Required Arguments
```dart
String id = ...;
String countryId = ...;
String nameEn = ...;
String nameAr = ...;
EspyConnector.instance.upsertRegion(
  id: id,
  countryId: countryId,
  nameEn: nameEn,
  nameAr: nameAr,
).execute();
```

#### Optional Arguments
We return a builder for each query. For UpsertRegion, we created `UpsertRegionBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class UpsertRegionVariablesBuilder {
  ...
   UpsertRegionVariablesBuilder regionCode(String? t) {
   _regionCode.value = t;
   return this;
  }

  ...
}
EspyConnector.instance.upsertRegion(
  id: id,
  countryId: countryId,
  nameEn: nameEn,
  nameAr: nameAr,
)
.regionCode(regionCode)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<UpsertRegionData, UpsertRegionVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await EspyConnector.instance.upsertRegion(
  id: id,
  countryId: countryId,
  nameEn: nameEn,
  nameAr: nameAr,
);
UpsertRegionData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
String countryId = ...;
String nameEn = ...;
String nameAr = ...;

final ref = EspyConnector.instance.upsertRegion(
  id: id,
  countryId: countryId,
  nameEn: nameEn,
  nameAr: nameAr,
).ref();
ref.execute();
```


### UpsertCity
#### Required Arguments
```dart
String id = ...;
String regionId = ...;
String nameEn = ...;
String nameAr = ...;
EspyConnector.instance.upsertCity(
  id: id,
  regionId: regionId,
  nameEn: nameEn,
  nameAr: nameAr,
).execute();
```

#### Optional Arguments
We return a builder for each query. For UpsertCity, we created `UpsertCityBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class UpsertCityVariablesBuilder {
  ...
   UpsertCityVariablesBuilder lat(double? t) {
   _lat.value = t;
   return this;
  }
  UpsertCityVariablesBuilder lng(double? t) {
   _lng.value = t;
   return this;
  }

  ...
}
EspyConnector.instance.upsertCity(
  id: id,
  regionId: regionId,
  nameEn: nameEn,
  nameAr: nameAr,
)
.lat(lat)
.lng(lng)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<UpsertCityData, UpsertCityVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await EspyConnector.instance.upsertCity(
  id: id,
  regionId: regionId,
  nameEn: nameEn,
  nameAr: nameAr,
);
UpsertCityData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
String regionId = ...;
String nameEn = ...;
String nameAr = ...;

final ref = EspyConnector.instance.upsertCity(
  id: id,
  regionId: regionId,
  nameEn: nameEn,
  nameAr: nameAr,
).ref();
ref.execute();
```


### DeleteGeographyEntity
#### Required Arguments
```dart
String id = ...;
EspyConnector.instance.deleteGeographyEntity(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<DeleteGeographyEntityData, DeleteGeographyEntityVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await EspyConnector.instance.deleteGeographyEntity(
  id: id,
);
DeleteGeographyEntityData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = EspyConnector.instance.deleteGeographyEntity(
  id: id,
).ref();
ref.execute();
```


### UpdateSectorBranding
#### Required Arguments
```dart
String id = ...;
EspyConnector.instance.updateSectorBranding(
  id: id,
).execute();
```

#### Optional Arguments
We return a builder for each query. For UpdateSectorBranding, we created `UpdateSectorBrandingBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class UpdateSectorBrandingVariablesBuilder {
  ...
   UpdateSectorBrandingVariablesBuilder iconName(String? t) {
   _iconName.value = t;
   return this;
  }
  UpdateSectorBrandingVariablesBuilder colorHex(String? t) {
   _colorHex.value = t;
   return this;
  }
  UpdateSectorBrandingVariablesBuilder nameEn(String? t) {
   _nameEn.value = t;
   return this;
  }
  UpdateSectorBrandingVariablesBuilder nameAr(String? t) {
   _nameAr.value = t;
   return this;
  }

  ...
}
EspyConnector.instance.updateSectorBranding(
  id: id,
)
.iconName(iconName)
.colorHex(colorHex)
.nameEn(nameEn)
.nameAr(nameAr)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<UpdateSectorBrandingData, UpdateSectorBrandingVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await EspyConnector.instance.updateSectorBranding(
  id: id,
);
UpdateSectorBrandingData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = EspyConnector.instance.updateSectorBranding(
  id: id,
).ref();
ref.execute();
```


### UpsertServiceTag
#### Required Arguments
```dart
String id = ...;
String nameEn = ...;
String nameAr = ...;
EspyConnector.instance.upsertServiceTag(
  id: id,
  nameEn: nameEn,
  nameAr: nameAr,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<UpsertServiceTagData, UpsertServiceTagVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await EspyConnector.instance.upsertServiceTag(
  id: id,
  nameEn: nameEn,
  nameAr: nameAr,
);
UpsertServiceTagData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
String nameEn = ...;
String nameAr = ...;

final ref = EspyConnector.instance.upsertServiceTag(
  id: id,
  nameEn: nameEn,
  nameAr: nameAr,
).ref();
ref.execute();
```


### UpsertPriceTag
#### Required Arguments
```dart
String id = ...;
String nameEn = ...;
String nameAr = ...;
EspyConnector.instance.upsertPriceTag(
  id: id,
  nameEn: nameEn,
  nameAr: nameAr,
).execute();
```

#### Optional Arguments
We return a builder for each query. For UpsertPriceTag, we created `UpsertPriceTagBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class UpsertPriceTagVariablesBuilder {
  ...
   UpsertPriceTagVariablesBuilder category(String? t) {
   _category.value = t;
   return this;
  }

  ...
}
EspyConnector.instance.upsertPriceTag(
  id: id,
  nameEn: nameEn,
  nameAr: nameAr,
)
.category(category)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<UpsertPriceTagData, UpsertPriceTagVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await EspyConnector.instance.upsertPriceTag(
  id: id,
  nameEn: nameEn,
  nameAr: nameAr,
);
UpsertPriceTagData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
String nameEn = ...;
String nameAr = ...;

final ref = EspyConnector.instance.upsertPriceTag(
  id: id,
  nameEn: nameEn,
  nameAr: nameAr,
).ref();
ref.execute();
```


### UpsertPinCategory
#### Required Arguments
```dart
String id = ...;
String nameEn = ...;
String nameAr = ...;
EspyConnector.instance.upsertPinCategory(
  id: id,
  nameEn: nameEn,
  nameAr: nameAr,
).execute();
```

#### Optional Arguments
We return a builder for each query. For UpsertPinCategory, we created `UpsertPinCategoryBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class UpsertPinCategoryVariablesBuilder {
  ...
   UpsertPinCategoryVariablesBuilder iconBase(String? t) {
   _iconBase.value = t;
   return this;
  }

  ...
}
EspyConnector.instance.upsertPinCategory(
  id: id,
  nameEn: nameEn,
  nameAr: nameAr,
)
.iconBase(iconBase)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<UpsertPinCategoryData, UpsertPinCategoryVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await EspyConnector.instance.upsertPinCategory(
  id: id,
  nameEn: nameEn,
  nameAr: nameAr,
);
UpsertPinCategoryData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
String nameEn = ...;
String nameAr = ...;

final ref = EspyConnector.instance.upsertPinCategory(
  id: id,
  nameEn: nameEn,
  nameAr: nameAr,
).ref();
ref.execute();
```


### UpsertPresenceTag
#### Required Arguments
```dart
String id = ...;
String nameEn = ...;
String nameAr = ...;
EspyConnector.instance.upsertPresenceTag(
  id: id,
  nameEn: nameEn,
  nameAr: nameAr,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<UpsertPresenceTagData, UpsertPresenceTagVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await EspyConnector.instance.upsertPresenceTag(
  id: id,
  nameEn: nameEn,
  nameAr: nameAr,
);
UpsertPresenceTagData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
String nameEn = ...;
String nameAr = ...;

final ref = EspyConnector.instance.upsertPresenceTag(
  id: id,
  nameEn: nameEn,
  nameAr: nameAr,
).ref();
ref.execute();
```


### CreateRechargeCard
#### Required Arguments
```dart
String code = ...;
int value = ...;
int pins = ...;
int slots = ...;
EspyConnector.instance.createRechargeCard(
  code: code,
  value: value,
  pins: pins,
  slots: slots,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<CreateRechargeCardData, CreateRechargeCardVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await EspyConnector.instance.createRechargeCard(
  code: code,
  value: value,
  pins: pins,
  slots: slots,
);
CreateRechargeCardData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String code = ...;
int value = ...;
int pins = ...;
int slots = ...;

final ref = EspyConnector.instance.createRechargeCard(
  code: code,
  value: value,
  pins: pins,
  slots: slots,
).ref();
ref.execute();
```


### ModerateService
#### Required Arguments
```dart
String id = ...;
ModerationStatus status = ...;
EspyConnector.instance.moderateService(
  id: id,
  status: status,
).execute();
```

#### Optional Arguments
We return a builder for each query. For ModerateService, we created `ModerateServiceBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class ModerateServiceVariablesBuilder {
  ...
   ModerateServiceVariablesBuilder reason(String? t) {
   _reason.value = t;
   return this;
  }

  ...
}
EspyConnector.instance.moderateService(
  id: id,
  status: status,
)
.reason(reason)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<ModerateServiceData, ModerateServiceVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await EspyConnector.instance.moderateService(
  id: id,
  status: status,
);
ModerateServiceData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
ModerationStatus status = ...;

final ref = EspyConnector.instance.moderateService(
  id: id,
  status: status,
).ref();
ref.execute();
```


### ModerateRequest
#### Required Arguments
```dart
String id = ...;
ModerationStatus status = ...;
EspyConnector.instance.moderateRequest(
  id: id,
  status: status,
).execute();
```

#### Optional Arguments
We return a builder for each query. For ModerateRequest, we created `ModerateRequestBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class ModerateRequestVariablesBuilder {
  ...
   ModerateRequestVariablesBuilder reason(String? t) {
   _reason.value = t;
   return this;
  }

  ...
}
EspyConnector.instance.moderateRequest(
  id: id,
  status: status,
)
.reason(reason)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<ModerateRequestData, ModerateRequestVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await EspyConnector.instance.moderateRequest(
  id: id,
  status: status,
);
ModerateRequestData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
ModerationStatus status = ...;

final ref = EspyConnector.instance.moderateRequest(
  id: id,
  status: status,
).ref();
ref.execute();
```


### UpsertTemplate
#### Required Arguments
```dart
String id = ...;
EspyConnector.instance.upsertTemplate(
  id: id,
).execute();
```

#### Optional Arguments
We return a builder for each query. For UpsertTemplate, we created `UpsertTemplateBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class UpsertTemplateVariablesBuilder {
  ...
   UpsertTemplateVariablesBuilder visibleFields(List<String>? t) {
   _visibleFields.value = t;
   return this;
  }
  UpsertTemplateVariablesBuilder accentColor(String? t) {
   _accentColor.value = t;
   return this;
  }
  UpsertTemplateVariablesBuilder iconName(String? t) {
   _iconName.value = t;
   return this;
  }
  UpsertTemplateVariablesBuilder configJson(String? t) {
   _configJson.value = t;
   return this;
  }

  ...
}
EspyConnector.instance.upsertTemplate(
  id: id,
)
.visibleFields(visibleFields)
.accentColor(accentColor)
.iconName(iconName)
.configJson(configJson)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<UpsertTemplateData, UpsertTemplateVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await EspyConnector.instance.upsertTemplate(
  id: id,
);
UpsertTemplateData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = EspyConnector.instance.upsertTemplate(
  id: id,
).ref();
ref.execute();
```


### CreateLocalizedBroadcast
#### Required Arguments
```dart
String title = ...;
String message = ...;
EspyConnector.instance.createLocalizedBroadcast(
  title: title,
  message: message,
).execute();
```

#### Optional Arguments
We return a builder for each query. For CreateLocalizedBroadcast, we created `CreateLocalizedBroadcastBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class CreateLocalizedBroadcastVariablesBuilder {
  ...
   CreateLocalizedBroadcastVariablesBuilder country(String? t) {
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

  ...
}
EspyConnector.instance.createLocalizedBroadcast(
  title: title,
  message: message,
)
.country(country)
.region(region)
.city(city)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<CreateLocalizedBroadcastData, CreateLocalizedBroadcastVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await EspyConnector.instance.createLocalizedBroadcast(
  title: title,
  message: message,
);
CreateLocalizedBroadcastData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String title = ...;
String message = ...;

final ref = EspyConnector.instance.createLocalizedBroadcast(
  title: title,
  message: message,
).ref();
ref.execute();
```


### ApproveResourceOrder
#### Required Arguments
```dart
String id = ...;
EspyConnector.instance.approveResourceOrder(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<ApproveResourceOrderData, ApproveResourceOrderVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await EspyConnector.instance.approveResourceOrder(
  id: id,
);
ApproveResourceOrderData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = EspyConnector.instance.approveResourceOrder(
  id: id,
).ref();
ref.execute();
```


### ApproveProfessional
#### Required Arguments
```dart
String id = ...;
bool isApproved = ...;
EspyConnector.instance.approveProfessional(
  id: id,
  isApproved: isApproved,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<ApproveProfessionalData, ApproveProfessionalVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await EspyConnector.instance.approveProfessional(
  id: id,
  isApproved: isApproved,
);
ApproveProfessionalData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
bool isApproved = ...;

final ref = EspyConnector.instance.approveProfessional(
  id: id,
  isApproved: isApproved,
).ref();
ref.execute();
```


### ValidateProfile
#### Required Arguments
```dart
String id = ...;
EspyConnector.instance.validateProfile(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<ValidateProfileData, ValidateProfileVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await EspyConnector.instance.validateProfile(
  id: id,
);
ValidateProfileData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = EspyConnector.instance.validateProfile(
  id: id,
).ref();
ref.execute();
```


### ValidateInstitutionProfile
#### Required Arguments
```dart
String id = ...;
EspyConnector.instance.validateInstitutionProfile(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<ValidateInstitutionProfileData, ValidateInstitutionProfileVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await EspyConnector.instance.validateInstitutionProfile(
  id: id,
);
ValidateInstitutionProfileData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = EspyConnector.instance.validateInstitutionProfile(
  id: id,
).ref();
ref.execute();
```


### ResolveSupportTicket
#### Required Arguments
```dart
String id = ...;
EspyConnector.instance.resolveSupportTicket(
  id: id,
).execute();
```

#### Optional Arguments
We return a builder for each query. For ResolveSupportTicket, we created `ResolveSupportTicketBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class ResolveSupportTicketVariablesBuilder {
  ...
   ResolveSupportTicketVariablesBuilder adminNote(String? t) {
   _adminNote.value = t;
   return this;
  }

  ...
}
EspyConnector.instance.resolveSupportTicket(
  id: id,
)
.adminNote(adminNote)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<ResolveSupportTicketData, ResolveSupportTicketVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await EspyConnector.instance.resolveSupportTicket(
  id: id,
);
ResolveSupportTicketData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = EspyConnector.instance.resolveSupportTicket(
  id: id,
).ref();
ref.execute();
```

