library espy_dataconnect_sdk;
import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';

part 'create_user.dart';

part 'update_user_profile.dart';

part 'upsert_professional_profile.dart';

part 'create_service.dart';

part 'update_service.dart';

part 'create_location_node.dart';

part 'create_resource_order.dart';

part 'update_resource_order.dart';

part 'spend_tokens.dart';

part 'post_community_request.dart';

part 'record_interaction.dart';

part 'update_user_admin.dart';

part 'toggle_user_active_status.dart';

part 'verify_user_professional.dart';

part 'verify_user_institution.dart';

part 'create_recharge_card.dart';

part 'update_sector.dart';

part 'update_category.dart';

part 'approve_professional.dart';

part 'validate_profile.dart';

part 'validate_institution_profile.dart';

part 'approve_resource_order.dart';

part 'resolve_support_ticket.dart';

part 'get_user.dart';

part 'get_professional_details.dart';

part 'list_sectors.dart';

part 'list_categories.dart';

part 'list_active_services.dart';

part 'search_services.dart';

part 'list_countries.dart';

part 'list_location_nodes.dart';

part 'list_favorite_ids.dart';

part 'list_contacted_ids.dart';

part 'list_community_requests.dart';

part 'get_wallet_transactions.dart';

part 'get_active_resource_order.dart';

part 'list_all_users.dart';

part 'get_user_details.dart';

part 'list_recharge_cards.dart';

part 'list_pending_approvals.dart';

part 'list_pending_orders.dart';

part 'list_support_tickets.dart';



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
  

  enum OrderStatus {
    
      PENDING,
    
      APPROVED,
    
      PAID,
    
      CANCELLED,
    
  }
  
  String orderStatusSerializer(EnumValue<OrderStatus> e) {
    return e.stringValue;
  }
  EnumValue<OrderStatus> orderStatusDeserializer(dynamic data) {
    switch (data) {
      
      case 'PENDING':
        return const Known(OrderStatus.PENDING);
      
      case 'APPROVED':
        return const Known(OrderStatus.APPROVED);
      
      case 'PAID':
        return const Known(OrderStatus.PAID);
      
      case 'CANCELLED':
        return const Known(OrderStatus.CANCELLED);
      
      default:
        return Unknown(data);
    }
  }
  

  enum SupportTicketStatus {
    
      OPEN,
    
      CLOSED,
    
      PENDING,
    
  }
  
  String supportTicketStatusSerializer(EnumValue<SupportTicketStatus> e) {
    return e.stringValue;
  }
  EnumValue<SupportTicketStatus> supportTicketStatusDeserializer(dynamic data) {
    switch (data) {
      
      case 'OPEN':
        return const Known(SupportTicketStatus.OPEN);
      
      case 'CLOSED':
        return const Known(SupportTicketStatus.CLOSED);
      
      case 'PENDING':
        return const Known(SupportTicketStatus.PENDING);
      
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
  
  
  CreateServiceVariablesBuilder createService ({required String categoryId, required String titleEn, required int price, }) {
    return CreateServiceVariablesBuilder(dataConnect, categoryId: categoryId,titleEn: titleEn,price: price,);
  }
  
  
  UpdateServiceVariablesBuilder updateService ({required String id, }) {
    return UpdateServiceVariablesBuilder(dataConnect, id: id,);
  }
  
  
  CreateLocationNodeVariablesBuilder createLocationNode ({required String countryId, required String label, required double lat, required double lng, required bool isMain, }) {
    return CreateLocationNodeVariablesBuilder(dataConnect, countryId: countryId,label: label,lat: lat,lng: lng,isMain: isMain,);
  }
  
  
  CreateResourceOrderVariablesBuilder createResourceOrder ({required int pins, required int slots, required int broadcasts, required int total, }) {
    return CreateResourceOrderVariablesBuilder(dataConnect, pins: pins,slots: slots,broadcasts: broadcasts,total: total,);
  }
  
  
  UpdateResourceOrderVariablesBuilder updateResourceOrder ({required String id, required int pins, required int slots, required int broadcasts, required int total, }) {
    return UpdateResourceOrderVariablesBuilder(dataConnect, id: id,pins: pins,slots: slots,broadcasts: broadcasts,total: total,);
  }
  
  
  SpendTokensVariablesBuilder spendTokens ({required String userId, required int cost, required int ledgerAmount, required String description, }) {
    return SpendTokensVariablesBuilder(dataConnect, userId: userId,cost: cost,ledgerAmount: ledgerAmount,description: description,);
  }
  
  
  PostCommunityRequestVariablesBuilder postCommunityRequest ({required String sectorId, required String title, required String description, }) {
    return PostCommunityRequestVariablesBuilder(dataConnect, sectorId: sectorId,title: title,description: description,);
  }
  
  
  RecordInteractionVariablesBuilder recordInteraction ({required String targetId, required InteractionType type, }) {
    return RecordInteractionVariablesBuilder(dataConnect, targetId: targetId,type: type,);
  }
  
  
  UpdateUserAdminVariablesBuilder updateUserAdmin ({required String id, }) {
    return UpdateUserAdminVariablesBuilder(dataConnect, id: id,);
  }
  
  
  ToggleUserActiveStatusVariablesBuilder toggleUserActiveStatus ({required String id, required bool isActive, }) {
    return ToggleUserActiveStatusVariablesBuilder(dataConnect, id: id,isActive: isActive,);
  }
  
  
  VerifyUserProfessionalVariablesBuilder verifyUserProfessional ({required String id, required bool isApproved, }) {
    return VerifyUserProfessionalVariablesBuilder(dataConnect, id: id,isApproved: isApproved,);
  }
  
  
  VerifyUserInstitutionVariablesBuilder verifyUserInstitution ({required String id, required bool isApproved, }) {
    return VerifyUserInstitutionVariablesBuilder(dataConnect, id: id,isApproved: isApproved,);
  }
  
  
  CreateRechargeCardVariablesBuilder createRechargeCard ({required String code, required int value, required int pins, required int slots, }) {
    return CreateRechargeCardVariablesBuilder(dataConnect, code: code,value: value,pins: pins,slots: slots,);
  }
  
  
  UpdateSectorVariablesBuilder updateSector ({required String id, }) {
    return UpdateSectorVariablesBuilder(dataConnect, id: id,);
  }
  
  
  UpdateCategoryVariablesBuilder updateCategory ({required String id, }) {
    return UpdateCategoryVariablesBuilder(dataConnect, id: id,);
  }
  
  
  ApproveProfessionalVariablesBuilder approveProfessional ({required String id, required bool isApproved, }) {
    return ApproveProfessionalVariablesBuilder(dataConnect, id: id,isApproved: isApproved,);
  }
  
  
  ValidateProfileVariablesBuilder validateProfile ({required String id, }) {
    return ValidateProfileVariablesBuilder(dataConnect, id: id,);
  }
  
  
  ValidateInstitutionProfileVariablesBuilder validateInstitutionProfile ({required String id, }) {
    return ValidateInstitutionProfileVariablesBuilder(dataConnect, id: id,);
  }
  
  
  ApproveResourceOrderVariablesBuilder approveResourceOrder ({required String id, }) {
    return ApproveResourceOrderVariablesBuilder(dataConnect, id: id,);
  }
  
  
  ResolveSupportTicketVariablesBuilder resolveSupportTicket ({required String id, }) {
    return ResolveSupportTicketVariablesBuilder(dataConnect, id: id,);
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
  
  
  ListActiveServicesVariablesBuilder listActiveServices () {
    return ListActiveServicesVariablesBuilder(dataConnect, );
  }
  
  
  SearchServicesVariablesBuilder searchServices () {
    return SearchServicesVariablesBuilder(dataConnect, );
  }
  
  
  ListCountriesVariablesBuilder listCountries () {
    return ListCountriesVariablesBuilder(dataConnect, );
  }
  
  
  ListLocationNodesVariablesBuilder listLocationNodes ({required String userId, }) {
    return ListLocationNodesVariablesBuilder(dataConnect, userId: userId,);
  }
  
  
  ListFavoriteIdsVariablesBuilder listFavoriteIds ({required String actorId, }) {
    return ListFavoriteIdsVariablesBuilder(dataConnect, actorId: actorId,);
  }
  
  
  ListContactedIdsVariablesBuilder listContactedIds ({required String actorId, }) {
    return ListContactedIdsVariablesBuilder(dataConnect, actorId: actorId,);
  }
  
  
  ListCommunityRequestsVariablesBuilder listCommunityRequests () {
    return ListCommunityRequestsVariablesBuilder(dataConnect, );
  }
  
  
  GetWalletTransactionsVariablesBuilder getWalletTransactions ({required String userId, }) {
    return GetWalletTransactionsVariablesBuilder(dataConnect, userId: userId,);
  }
  
  
  GetActiveResourceOrderVariablesBuilder getActiveResourceOrder ({required String userId, }) {
    return GetActiveResourceOrderVariablesBuilder(dataConnect, userId: userId,);
  }
  
  
  ListAllUsersVariablesBuilder listAllUsers () {
    return ListAllUsersVariablesBuilder(dataConnect, );
  }
  
  
  GetUserDetailsVariablesBuilder getUserDetails ({required String id, }) {
    return GetUserDetailsVariablesBuilder(dataConnect, id: id,);
  }
  
  
  ListRechargeCardsVariablesBuilder listRechargeCards () {
    return ListRechargeCardsVariablesBuilder(dataConnect, );
  }
  
  
  ListPendingApprovalsVariablesBuilder listPendingApprovals () {
    return ListPendingApprovalsVariablesBuilder(dataConnect, );
  }
  
  
  ListPendingOrdersVariablesBuilder listPendingOrders () {
    return ListPendingOrdersVariablesBuilder(dataConnect, );
  }
  
  
  ListSupportTicketsVariablesBuilder listSupportTickets () {
    return ListSupportTicketsVariablesBuilder(dataConnect, );
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
