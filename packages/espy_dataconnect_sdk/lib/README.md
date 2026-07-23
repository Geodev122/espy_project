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

  ...
}
EspyConnector.instance.listActiveServices()
.categoryId(categoryId)
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


### ListCommunityRequests
#### Required Arguments
```dart
// No required arguments
EspyConnector.instance.listCommunityRequests().execute();
```

#### Optional Arguments
We return a builder for each query. For ListCommunityRequests, we created `ListCommunityRequestsBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class ListCommunityRequestsVariablesBuilder {
  ...
 
  ListCommunityRequestsVariablesBuilder sectorId(String? t) {
   _sectorId.value = t;
   return this;
  }
  ListCommunityRequestsVariablesBuilder status(CommunityRequestStatus? t) {
   _status.value = t;
   return this;
  }

  ...
}
EspyConnector.instance.listCommunityRequests()
.sectorId(sectorId)
.status(status)
.execute();
```

#### Return Type
`execute()` returns a `QueryResult<ListCommunityRequestsData, ListCommunityRequestsVariables>`
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

final result = await EspyConnector.instance.listCommunityRequests();
ListCommunityRequestsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = EspyConnector.instance.listCommunityRequests().ref();
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


### CreateService
#### Required Arguments
```dart
String categoryId = ...;
String titleEn = ...;
int price = ...;
EspyConnector.instance.createService(
  categoryId: categoryId,
  titleEn: titleEn,
  price: price,
).execute();
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
String titleEn = ...;
int price = ...;

final ref = EspyConnector.instance.createService(
  categoryId: categoryId,
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
String countryId = ...;
String label = ...;
double lat = ...;
double lng = ...;
bool isMain = ...;
EspyConnector.instance.createLocationNode(
  countryId: countryId,
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
  countryId: countryId,
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
String countryId = ...;
String label = ...;
double lat = ...;
double lng = ...;
bool isMain = ...;

final ref = EspyConnector.instance.createLocationNode(
  countryId: countryId,
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


### PostCommunityRequest
#### Required Arguments
```dart
String sectorId = ...;
String title = ...;
String description = ...;
EspyConnector.instance.postCommunityRequest(
  sectorId: sectorId,
  title: title,
  description: description,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<PostCommunityRequestData, PostCommunityRequestVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await EspyConnector.instance.postCommunityRequest(
  sectorId: sectorId,
  title: title,
  description: description,
);
PostCommunityRequestData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String sectorId = ...;
String title = ...;
String description = ...;

final ref = EspyConnector.instance.postCommunityRequest(
  sectorId: sectorId,
  title: title,
  description: description,
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


### UpdateSector
#### Required Arguments
```dart
String id = ...;
EspyConnector.instance.updateSector(
  id: id,
).execute();
```

#### Optional Arguments
We return a builder for each query. For UpdateSector, we created `UpdateSectorBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class UpdateSectorVariablesBuilder {
  ...
   UpdateSectorVariablesBuilder nameEn(String? t) {
   _nameEn.value = t;
   return this;
  }
  UpdateSectorVariablesBuilder displayOrder(int? t) {
   _displayOrder.value = t;
   return this;
  }

  ...
}
EspyConnector.instance.updateSector(
  id: id,
)
.nameEn(nameEn)
.displayOrder(displayOrder)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<UpdateSectorData, UpdateSectorVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await EspyConnector.instance.updateSector(
  id: id,
);
UpdateSectorData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = EspyConnector.instance.updateSector(
  id: id,
).ref();
ref.execute();
```


### UpdateCategory
#### Required Arguments
```dart
String id = ...;
EspyConnector.instance.updateCategory(
  id: id,
).execute();
```

#### Optional Arguments
We return a builder for each query. For UpdateCategory, we created `UpdateCategoryBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class UpdateCategoryVariablesBuilder {
  ...
   UpdateCategoryVariablesBuilder nameEn(String? t) {
   _nameEn.value = t;
   return this;
  }

  ...
}
EspyConnector.instance.updateCategory(
  id: id,
)
.nameEn(nameEn)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<UpdateCategoryData, UpdateCategoryVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await EspyConnector.instance.updateCategory(
  id: id,
);
UpdateCategoryData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = EspyConnector.instance.updateCategory(
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

