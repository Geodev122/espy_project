library espy_dataconnect_sdk;
import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';

part 'create_user.dart';

part 'update_user_profile.dart';

part 'upsert_professional_profile.dart';

part 'upsert_institution_profile.dart';

part 'create_service.dart';

part 'update_service.dart';

part 'create_location_node.dart';

part 'create_resource_order.dart';

part 'update_resource_order.dart';

part 'post_service_request.dart';

part 'record_interaction.dart';

part 'upsert_country.dart';

part 'upsert_region.dart';

part 'upsert_city.dart';

part 'delete_geography_entity.dart';

part 'update_sector_branding.dart';

part 'update_category.dart';

part 'upsert_service_tag.dart';

part 'upsert_price_tag.dart';

part 'upsert_pin_category.dart';

part 'upsert_presence_tag.dart';

part 'moderate_service.dart';

part 'moderate_request.dart';

part 'upsert_template.dart';

part 'create_localized_broadcast.dart';

part 'approve_resource_order.dart';

part 'get_user.dart';

part 'get_professional_details.dart';

part 'list_sectors.dart';

part 'list_categories.dart';

part 'list_regions.dart';

part 'list_cities.dart';

part 'list_metadata_tags.dart';

part 'list_active_services.dart';

part 'list_countries.dart';

part 'list_location_nodes.dart';

part 'list_interactions.dart';

part 'list_service_requests.dart';

part 'search_users_admin.dart';

part 'get_audit_details.dart';

part 'list_service_moderation_queue.dart';

part 'list_request_moderation_queue.dart';

part 'list_templates.dart';



  enum CommunityRequestStatus {
    
      ACTIVE,
    
      FULFILLED,
    
      EXPIRED,
    
      PENDING,
    
  }
  
  String communityRequestStatusSerializer(EnumValue<CommunityRequestStatus> e) {
    return e.stringValue;
  }
  EnumValue<CommunityRequestStatus> communityRequestStatusDeserializer(dynamic data) {
    switch (data) {
      
      case 'ACTIVE':
        return const Known(CommunityRequestStatus.ACTIVE);
      
      case 'FULFILLED':
        return const Known(CommunityRequestStatus.FULFILLED);
      
      case 'EXPIRED':
        return const Known(CommunityRequestStatus.EXPIRED);
      
      case 'PENDING':
        return const Known(CommunityRequestStatus.PENDING);
      
      default:
        return Unknown(data);
    }
  }
  

  enum DeliveryMode {
    
      ONLINE,
    
      FACE_TO_FACE,
    
      FIELD,
    
  }
  
  String deliveryModeSerializer(EnumValue<DeliveryMode> e) {
    return e.stringValue;
  }
  EnumValue<DeliveryMode> deliveryModeDeserializer(dynamic data) {
    switch (data) {
      
      case 'ONLINE':
        return const Known(DeliveryMode.ONLINE);
      
      case 'FACE_TO_FACE':
        return const Known(DeliveryMode.FACE_TO_FACE);
      
      case 'FIELD':
        return const Known(DeliveryMode.FIELD);
      
      default:
        return Unknown(data);
    }
  }
  

  enum InteractionType {
    
      LIKE,
    
      DISLIKE,
    
      VIEW,
    
      FAVORITE,
    
      SHARE,
    
      CONTACT,
    
  }
  
  String interactionTypeSerializer(EnumValue<InteractionType> e) {
    return e.stringValue;
  }
  EnumValue<InteractionType> interactionTypeDeserializer(dynamic data) {
    switch (data) {
      
      case 'LIKE':
        return const Known(InteractionType.LIKE);
      
      case 'DISLIKE':
        return const Known(InteractionType.DISLIKE);
      
      case 'VIEW':
        return const Known(InteractionType.VIEW);
      
      case 'FAVORITE':
        return const Known(InteractionType.FAVORITE);
      
      case 'SHARE':
        return const Known(InteractionType.SHARE);
      
      case 'CONTACT':
        return const Known(InteractionType.CONTACT);
      
      default:
        return Unknown(data);
    }
  }
  

  enum MembershipTier {
    
      BASIC,
    
      GOLD,
    
      PLATINUM,
    
  }
  
  String membershipTierSerializer(EnumValue<MembershipTier> e) {
    return e.stringValue;
  }
  EnumValue<MembershipTier> membershipTierDeserializer(dynamic data) {
    switch (data) {
      
      case 'BASIC':
        return const Known(MembershipTier.BASIC);
      
      case 'GOLD':
        return const Known(MembershipTier.GOLD);
      
      case 'PLATINUM':
        return const Known(MembershipTier.PLATINUM);
      
      default:
        return Unknown(data);
    }
  }
  

  enum ModerationStatus {
    
      PENDING,
    
      APPROVED,
    
      FLAGGED,
    
      ARCHIVED,
    
  }
  
  String moderationStatusSerializer(EnumValue<ModerationStatus> e) {
    return e.stringValue;
  }
  EnumValue<ModerationStatus> moderationStatusDeserializer(dynamic data) {
    switch (data) {
      
      case 'PENDING':
        return const Known(ModerationStatus.PENDING);
      
      case 'APPROVED':
        return const Known(ModerationStatus.APPROVED);
      
      case 'FLAGGED':
        return const Known(ModerationStatus.FLAGGED);
      
      case 'ARCHIVED':
        return const Known(ModerationStatus.ARCHIVED);
      
      default:
        return Unknown(data);
    }
  }
  

  enum TransactionType {
    
      RECHARGE,
    
      PURCHASE,
    
      REFUND,
    
      BONUS,
    
  }
  
  String transactionTypeSerializer(EnumValue<TransactionType> e) {
    return e.stringValue;
  }
  EnumValue<TransactionType> transactionTypeDeserializer(dynamic data) {
    switch (data) {
      
      case 'RECHARGE':
        return const Known(TransactionType.RECHARGE);
      
      case 'PURCHASE':
        return const Known(TransactionType.PURCHASE);
      
      case 'REFUND':
        return const Known(TransactionType.REFUND);
      
      case 'BONUS':
        return const Known(TransactionType.BONUS);
      
      default:
        return Unknown(data);
    }
  }
  

  enum UrgencyLevel {
    
      LOW,
    
      MEDIUM,
    
      HIGH,
    
      EMERGENCY,
    
  }
  
  String urgencyLevelSerializer(EnumValue<UrgencyLevel> e) {
    return e.stringValue;
  }
  EnumValue<UrgencyLevel> urgencyLevelDeserializer(dynamic data) {
    switch (data) {
      
      case 'LOW':
        return const Known(UrgencyLevel.LOW);
      
      case 'MEDIUM':
        return const Known(UrgencyLevel.MEDIUM);
      
      case 'HIGH':
        return const Known(UrgencyLevel.HIGH);
      
      case 'EMERGENCY':
        return const Known(UrgencyLevel.EMERGENCY);
      
      default:
        return Unknown(data);
    }
  }
  

  enum UserRole {
    
      VISITOR,
    
      PROFESSIONAL,
    
      INSTITUTION,
    
      ADMIN,
    
      PENDING,
    
  }
  
  String userRoleSerializer(EnumValue<UserRole> e) {
    return e.stringValue;
  }
  EnumValue<UserRole> userRoleDeserializer(dynamic data) {
    switch (data) {
      
      case 'VISITOR':
        return const Known(UserRole.VISITOR);
      
      case 'PROFESSIONAL':
        return const Known(UserRole.PROFESSIONAL);
      
      case 'INSTITUTION':
        return const Known(UserRole.INSTITUTION);
      
      case 'ADMIN':
        return const Known(UserRole.ADMIN);
      
      case 'PENDING':
        return const Known(UserRole.PENDING);
      
      default:
        return Unknown(data);
    }
  }
  



String enumSerializer(Enum e) {
  return e.name;
}



/// A sealed class representing either a known enum value or an unknown string value.
@immutable
sealed class EnumValue<T extends Enum> {
  const EnumValue();

  

  /// The string representation of the value.
  String get stringValue;
  @override
  String toString() {
    return "EnumValue($stringValue)";
  }
}

/// Represents a known, valid enum value.
class Known<T extends Enum> extends EnumValue<T> {
  /// The actual enum value.
  final T value;

  const Known(this.value);

  @override
  String get stringValue => value.name;

  @override
  String toString() {
    return "Known($stringValue)";
  }
}
/// Represents an unknown or unrecognized enum value.
class Unknown extends EnumValue<Never> {
  /// The raw string value that couldn't be mapped to a known enum.
  @override
  final String stringValue;

  const Unknown(this.stringValue);
  @override
  String toString() {
    return "Unknown($stringValue)";
  }
}

class EspyConnector {
  
  
  CreateUserVariablesBuilder createUser ({required String id, required String email, required UserRole role, }) {
    return CreateUserVariablesBuilder(dataConnect, id: id,email: email,role: role,);
  }
  
  
  UpdateUserProfileVariablesBuilder updateUserProfile ({required String id, }) {
    return UpdateUserProfileVariablesBuilder(dataConnect, id: id,);
  }
  
  
  UpsertProfessionalProfileVariablesBuilder upsertProfessionalProfile ({required String id, }) {
    return UpsertProfessionalProfileVariablesBuilder(dataConnect, id: id,);
  }
  
  
  UpsertInstitutionProfileVariablesBuilder upsertInstitutionProfile ({required String id, }) {
    return UpsertInstitutionProfileVariablesBuilder(dataConnect, id: id,);
  }
  
  
  CreateServiceVariablesBuilder createService ({required String categoryId, required String sectorId, required String titleEn, required int price, }) {
    return CreateServiceVariablesBuilder(dataConnect, categoryId: categoryId,sectorId: sectorId,titleEn: titleEn,price: price,);
  }
  
  
  UpdateServiceVariablesBuilder updateService ({required String id, }) {
    return UpdateServiceVariablesBuilder(dataConnect, id: id,);
  }
  
  
  CreateLocationNodeVariablesBuilder createLocationNode ({required String cityId, required String label, required double lat, required double lng, required bool isMain, }) {
    return CreateLocationNodeVariablesBuilder(dataConnect, cityId: cityId,label: label,lat: lat,lng: lng,isMain: isMain,);
  }
  
  
  CreateResourceOrderVariablesBuilder createResourceOrder ({required int pins, required int slots, required int broadcasts, required int total, }) {
    return CreateResourceOrderVariablesBuilder(dataConnect, pins: pins,slots: slots,broadcasts: broadcasts,total: total,);
  }
  
  
  UpdateResourceOrderVariablesBuilder updateResourceOrder ({required String id, required int pins, required int slots, required int broadcasts, required int total, }) {
    return UpdateResourceOrderVariablesBuilder(dataConnect, id: id,pins: pins,slots: slots,broadcasts: broadcasts,total: total,);
  }
  
  
  PostServiceRequestVariablesBuilder postServiceRequest ({required String sectorId, required String descriptionEn, }) {
    return PostServiceRequestVariablesBuilder(dataConnect, sectorId: sectorId,descriptionEn: descriptionEn,);
  }
  
  
  RecordInteractionVariablesBuilder recordInteraction ({required String targetId, required InteractionType type, }) {
    return RecordInteractionVariablesBuilder(dataConnect, targetId: targetId,type: type,);
  }
  
  
  UpsertCountryVariablesBuilder upsertCountry ({required String id, required String nameEn, required String nameAr, }) {
    return UpsertCountryVariablesBuilder(dataConnect, id: id,nameEn: nameEn,nameAr: nameAr,);
  }
  
  
  UpsertRegionVariablesBuilder upsertRegion ({required String id, required String countryId, required String nameEn, required String nameAr, }) {
    return UpsertRegionVariablesBuilder(dataConnect, id: id,countryId: countryId,nameEn: nameEn,nameAr: nameAr,);
  }
  
  
  UpsertCityVariablesBuilder upsertCity ({required String id, required String regionId, required String nameEn, required String nameAr, }) {
    return UpsertCityVariablesBuilder(dataConnect, id: id,regionId: regionId,nameEn: nameEn,nameAr: nameAr,);
  }
  
  
  DeleteGeographyEntityVariablesBuilder deleteGeographyEntity ({required String id, }) {
    return DeleteGeographyEntityVariablesBuilder(dataConnect, id: id,);
  }
  
  
  UpdateSectorBrandingVariablesBuilder updateSectorBranding ({required String id, }) {
    return UpdateSectorBrandingVariablesBuilder(dataConnect, id: id,);
  }
  
  
  UpdateCategoryVariablesBuilder updateCategory ({required String id, required String sectorId, required String nameEn, required String nameAr, required UserRole targetRole, }) {
    return UpdateCategoryVariablesBuilder(dataConnect, id: id,sectorId: sectorId,nameEn: nameEn,nameAr: nameAr,targetRole: targetRole,);
  }
  
  
  UpsertServiceTagVariablesBuilder upsertServiceTag ({required String id, required String nameEn, required String nameAr, }) {
    return UpsertServiceTagVariablesBuilder(dataConnect, id: id,nameEn: nameEn,nameAr: nameAr,);
  }
  
  
  UpsertPriceTagVariablesBuilder upsertPriceTag ({required String id, required String nameEn, required String nameAr, }) {
    return UpsertPriceTagVariablesBuilder(dataConnect, id: id,nameEn: nameEn,nameAr: nameAr,);
  }
  
  
  UpsertPinCategoryVariablesBuilder upsertPinCategory ({required String id, required String nameEn, required String nameAr, }) {
    return UpsertPinCategoryVariablesBuilder(dataConnect, id: id,nameEn: nameEn,nameAr: nameAr,);
  }
  
  
  UpsertPresenceTagVariablesBuilder upsertPresenceTag ({required String id, required String nameEn, required String nameAr, }) {
    return UpsertPresenceTagVariablesBuilder(dataConnect, id: id,nameEn: nameEn,nameAr: nameAr,);
  }
  
  
  ModerateServiceVariablesBuilder moderateService ({required String id, required ModerationStatus status, }) {
    return ModerateServiceVariablesBuilder(dataConnect, id: id,status: status,);
  }
  
  
  ModerateRequestVariablesBuilder moderateRequest ({required String id, required ModerationStatus status, }) {
    return ModerateRequestVariablesBuilder(dataConnect, id: id,status: status,);
  }
  
  
  UpsertTemplateVariablesBuilder upsertTemplate ({required String id, }) {
    return UpsertTemplateVariablesBuilder(dataConnect, id: id,);
  }
  
  
  CreateLocalizedBroadcastVariablesBuilder createLocalizedBroadcast ({required String title, required String message, }) {
    return CreateLocalizedBroadcastVariablesBuilder(dataConnect, title: title,message: message,);
  }
  
  
  ApproveResourceOrderVariablesBuilder approveResourceOrder ({required String id, }) {
    return ApproveResourceOrderVariablesBuilder(dataConnect, id: id,);
  }
  
  
  GetUserVariablesBuilder getUser ({required String uid, }) {
    return GetUserVariablesBuilder(dataConnect, uid: uid,);
  }
  
  
  GetProfessionalDetailsVariablesBuilder getProfessionalDetails ({required String uid, }) {
    return GetProfessionalDetailsVariablesBuilder(dataConnect, uid: uid,);
  }
  
  
  ListSectorsVariablesBuilder listSectors () {
    return ListSectorsVariablesBuilder(dataConnect, );
  }
  
  
  ListCategoriesVariablesBuilder listCategories () {
    return ListCategoriesVariablesBuilder(dataConnect, );
  }
  
  
  ListRegionsVariablesBuilder listRegions ({required String countryId, }) {
    return ListRegionsVariablesBuilder(dataConnect, countryId: countryId,);
  }
  
  
  ListCitiesVariablesBuilder listCities ({required String regionId, }) {
    return ListCitiesVariablesBuilder(dataConnect, regionId: regionId,);
  }
  
  
  ListMetadataTagsVariablesBuilder listMetadataTags () {
    return ListMetadataTagsVariablesBuilder(dataConnect, );
  }
  
  
  ListActiveServicesVariablesBuilder listActiveServices () {
    return ListActiveServicesVariablesBuilder(dataConnect, );
  }
  
  
  ListCountriesVariablesBuilder listCountries () {
    return ListCountriesVariablesBuilder(dataConnect, );
  }
  
  
  ListLocationNodesVariablesBuilder listLocationNodes ({required String userId, }) {
    return ListLocationNodesVariablesBuilder(dataConnect, userId: userId,);
  }
  
  
  ListInteractionsVariablesBuilder listInteractions ({required String actorId, required InteractionType type, }) {
    return ListInteractionsVariablesBuilder(dataConnect, actorId: actorId,type: type,);
  }
  
  
  ListServiceRequestsVariablesBuilder listServiceRequests () {
    return ListServiceRequestsVariablesBuilder(dataConnect, );
  }
  
  
  SearchUsersAdminVariablesBuilder searchUsersAdmin () {
    return SearchUsersAdminVariablesBuilder(dataConnect, );
  }
  
  
  GetAuditDetailsVariablesBuilder getAuditDetails ({required String id, }) {
    return GetAuditDetailsVariablesBuilder(dataConnect, id: id,);
  }
  
  
  ListServiceModerationQueueVariablesBuilder listServiceModerationQueue () {
    return ListServiceModerationQueueVariablesBuilder(dataConnect, );
  }
  
  
  ListRequestModerationQueueVariablesBuilder listRequestModerationQueue () {
    return ListRequestModerationQueueVariablesBuilder(dataConnect, );
  }
  
  
  ListTemplatesVariablesBuilder listTemplates () {
    return ListTemplatesVariablesBuilder(dataConnect, );
  }
  

  static ConnectorConfig connectorConfig = ConnectorConfig(
    'us-east1',
    'espy',
    'espy-453d3-service',
  );

  EspyConnector({required this.dataConnect});
  static EspyConnector get instance {
    
    return EspyConnector(
        dataConnect: FirebaseDataConnect.instanceFor(
            connectorConfig: connectorConfig,
            
            sdkType: CallerSDKType.generated));
  }

  FirebaseDataConnect dataConnect;
}
