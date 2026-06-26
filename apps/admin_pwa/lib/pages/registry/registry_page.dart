import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme.dart';
import 'registry_providers.dart';
import 'package:shared_core/models/professional_model.dart';
import 'package:shared_core/models/visitor_model.dart';
import 'package:shared_core/models/service_model.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/firestore_service.dart';
import '../../services/export_service.dart';
import '../../widgets/common/admin_badge.dart';
import '../../widgets/common/admin_doc_modal.dart';
import '../../widgets/common/admin_edit_user_modal.dart';

class RegistryPage extends ConsumerStatefulWidget {
  const RegistryPage({super.key});

  @override
  ConsumerState<RegistryPage> createState() => _RegistryPageState();
}

class _RegistryPageState extends ConsumerState<RegistryPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTimeRange? _dateRange;
  bool _ascending = false;
  String _statusFilter = 'all';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  void _resetFilters() {
    setState(() {
      _dateRange = null;
      _ascending = false;
      _statusFilter = 'all';
    });
  }

  List<T> _filterData<T>(List<T> data, DateTime? Function(T) getDate, bool Function(T, String) filterByStatus) {
    var filtered = data;
    
    if (_dateRange != null) {
      filtered = filtered.where((item) {
        final date = getDate(item);
        if (date == null) return false;
        return date.isAfter(_dateRange!.start) && date.isBefore(_dateRange!.end.add(const Duration(days: 1)));
      }).toList();
    }

    if (_statusFilter != 'all') {
      filtered = filtered.where((item) => filterByStatus(item, _statusFilter)).toList();
    }

    filtered.sort((a, b) {
      final dateA = getDate(a) ?? DateTime(0);
      final dateB = getDate(b) ?? DateTime(0);
      return _ascending ? dateA.compareTo(dateB) : dateB.compareTo(dateA);
    });

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 32),
          _buildFilterBar(),
          const SizedBox(height: 16),
          _buildTabs(),
          const SizedBox(height: 24),
          Expanded(
            child: Scrollbar(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildProfessionalsTab(),
                  _buildInstitutionsTab(),
                  _buildVisitorsTab(),
                  _buildServicesTab(),
                  _buildCommunityRequestsTab(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'PROVIDER REGISTRY',
              style: EspyTheme.cinzelStyle.copyWith(fontSize: 24, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              'Manage and verify all ecosystem PINs',
              style: EspyTheme.loraStyle.copyWith(fontSize: 14, color: Colors.white38),
            ),
          ],
        ),
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        GestureDetector(
          onTap: _handleExport,
          child: _buildIconAction(LucideIcons.download, 'Export Excel'),
        ),
        const SizedBox(width: 12),
        _buildIconAction(LucideIcons.plus, 'Add New'),
      ],
    );
  }

  Widget _buildIconAction(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: EspyTheme.electricBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: EspyTheme.electricBlue.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: EspyTheme.electricBlue),
          const SizedBox(width: 8),
          Text(label, style: EspyTheme.cinzelStyle.copyWith(fontSize: 9, color: EspyTheme.electricBlue)),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Row(
      children: [
        OutlinedButton.icon(
          onPressed: () async {
            final picked = await showDateRangePicker(
              context: context,
              firstDate: DateTime(2023),
              lastDate: DateTime.now(),
              initialDateRange: _dateRange,
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.dark(
                      primary: EspyTheme.electricBlue,
                      onPrimary: Colors.white,
                      surface: Color(0xFF061226),
                      onSurface: Colors.white,
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (picked != null) setState(() => _dateRange = picked);
          },
          icon: Icon(LucideIcons.calendar, size: 14),
          label: Text(_dateRange == null ? 'FILTER BY DATE' : '${DateFormat('dd MMM').format(_dateRange!.start)} - ${DateFormat('dd MMM').format(_dateRange!.end)}'),
        ),
        const SizedBox(width: 16),
        DropdownButton<String>(
          value: _statusFilter,
          underline: const SizedBox(),
          dropdownColor: const Color(0xFF061226),
          style: EspyTheme.cinzelStyle.copyWith(fontSize: 11, color: Colors.white),
          items: const [
            DropdownMenuItem(value: 'all', child: Text('ALL STATUSES')),
            DropdownMenuItem(value: 'active', child: Text('ACTIVE / APPROVED')),
            DropdownMenuItem(value: 'pending', child: Text('PENDING')),
          ],
          onChanged: (val) => setState(() => _statusFilter = val!),
        ),
        const SizedBox(width: 16),
        IconButton(
          onPressed: () => setState(() => _ascending = !_ascending),
          icon: Icon(_ascending ? LucideIcons.sortAsc : LucideIcons.sortDesc, size: 16, color: EspyTheme.gold),
          tooltip: 'Sort by Date',
        ),
        const Spacer(),
        if (_dateRange != null || _statusFilter != 'all')
          TextButton(onPressed: _resetFilters, child: const Text('RESET FILTERS', style: TextStyle(fontSize: 10, color: Colors.redAccent))),
      ],
    );
  }

  Widget _buildTabs() {
    return Container(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.05)))),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        indicatorColor: EspyTheme.electricBlue,
        dividerColor: Colors.transparent,
        labelStyle: EspyTheme.cinzelStyle.copyWith(fontSize: 11, fontWeight: FontWeight.bold),
        unselectedLabelStyle: EspyTheme.cinzelStyle.copyWith(fontSize: 11),
        unselectedLabelColor: Colors.white38,
        labelColor: Colors.white,
        tabs: const [
          Tab(text: 'PROFESSIONALS'),
          Tab(text: 'INSTITUTIONS'),
          Tab(text: 'VISITORS'),
          Tab(text: 'SERVICES'),
          Tab(text: 'COMMUNITY'),
        ],
      ),
    );
  }

  Widget _buildProfessionalsTab() {
    final asyncProfs = ref.watch(professionalsStreamProvider);
    return asyncProfs.when(
      data: (profs) {
        final filtered = _filterData<ProfessionalModel>(profs, (u) => u.createdAt, (u, s) => s == 'active' ? u.isApproved : !u.isApproved);
        return _buildUserTable(filtered);
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('Error: $e')),
    );
  }

  Widget _buildInstitutionsTab() {
    final asyncInsts = ref.watch(institutionsStreamProvider);
    return asyncInsts.when(
      data: (insts) {
        final filtered = _filterData<ProfessionalModel>(insts, (u) => u.createdAt, (u, s) => s == 'active' ? u.isApproved : !u.isApproved);
        return _buildUserTable(filtered);
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('Error: $e')),
    );
  }

  Widget _buildVisitorsTab() {
    final asyncVisitors = ref.watch(visitorsStreamProvider);
    return asyncVisitors.when(
      data: (visitors) {
        final filtered = _filterData<VisitorModel>(visitors, (v) => v.createdAt, (v, s) => true);
        return _buildVisitorTable(filtered);
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('Error: $e')),
    );
  }

  Widget _buildUserTable(List<ProfessionalModel> users) {
    return Card(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingTextStyle: EspyTheme.cinzelStyle.copyWith(fontSize: 10, color: EspyTheme.gold),
            dataTextStyle: EspyTheme.loraStyle.copyWith(fontSize: 13, color: Colors.white70),
            columnSpacing: 24,
            columns: const [
              DataColumn(label: Text('IDENTITY')),
              DataColumn(label: Text('DATE')),
              DataColumn(label: Text('SPECIALTY')),
              DataColumn(label: Text('FAVS')),
              DataColumn(label: Text('CONTACT')),
              DataColumn(label: Text('STATUS')),
              DataColumn(label: Text('TIER')),
              DataColumn(label: Text('ACTIONS')),
            ],
            rows: users.map((u) => _buildUserRow(u)).toList(),
          ),
        ),
      ),
    );
  }

  DataRow _buildUserRow(ProfessionalModel user) {
    return DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundImage: user.photoUrl != null ? NetworkImage(user.photoUrl!) : null,
                child: user.photoUrl == null ? Icon(LucideIcons.user, size: 14) : null,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(user.fullNameEn ?? user.name ?? 'Unknown', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      if (user.isHonorVerified) ...[
                        const SizedBox(width: 4),
                        Icon(LucideIcons.award, size: 10, color: EspyTheme.gold),
                      ],
                    ],
                  ),
                  Text(user.email ?? '', style: const TextStyle(color: Colors.white38, fontSize: 11)),
                ],
              ),
            ],
          ),
        ),
        DataCell(Text(user.createdAt != null ? DateFormat('dd MMM yy').format(user.createdAt!) : '—')),
        DataCell(Text(user.specialty ?? 'General')),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: EspyTheme.gold.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Text('${user.favoriteCount}', style: const TextStyle(color: EspyTheme.gold, fontWeight: FontWeight.bold, fontSize: 11)),
          ),
        ),
        DataCell(Text(user.phone ?? '—')),
        DataCell(
          Switch(
            value: user.isApproved,
            activeColor: Colors.green,
            onChanged: (val) => _handleToggleApproval(user.id, user.isApproved, user.role),
          ),
        ),
        DataCell(Text(user.membershipTier.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
        DataCell(
          Row(
            children: [
              IconButton(icon: Icon(LucideIcons.edit, size: 16, color: Colors.white24), onPressed: () {
                showDialog(context: context, builder: (_) => AdminEditUserModal(user: user));
              }),
              IconButton(
                icon: Icon(LucideIcons.fileText, size: 16, color: user.isApproved ? Colors.green : Colors.white24), 
                onPressed: () {
                  showDialog(context: context, builder: (_) => AdminDocModal(user: user));
                }
              ),
              IconButton(
                icon: Icon(LucideIcons.shieldCheck, size: 16, color: user.isHonorVerified ? Colors.green : Colors.white24),
                onPressed: () => _handleToggleHonor(user.id, user.isHonorVerified, user.role),
              ),
              IconButton(icon: Icon(LucideIcons.trash2, size: 16, color: Colors.redAccent), onPressed: () => _handleDelete(user.id, user.role == 'institution' ? 'directory_institutions' : 'directory_professionals')),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVisitorTable(List<VisitorModel> visitors) {
    return Card(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingTextStyle: EspyTheme.cinzelStyle.copyWith(fontSize: 10, color: EspyTheme.gold),
            dataTextStyle: EspyTheme.loraStyle.copyWith(fontSize: 13, color: Colors.white70),
            columnSpacing: 24,
            columns: const [
              DataColumn(label: Text('IDENTITY')),
              DataColumn(label: Text('DATE')),
              DataColumn(label: Text('SOURCE')),
              DataColumn(label: Text('STATUS')),
              DataColumn(label: Text('LAST ONLINE')),
              DataColumn(label: Text('ACTIONS')),
            ],
            rows: visitors.map((v) => _buildVisitorRow(v)).toList(),
          ),
        ),
      ),
    );
  }

  DataRow _buildVisitorRow(VisitorModel visitor) {
    return DataRow(
      cells: [
        DataCell(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(visitor.name ?? 'Guest', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              Text(visitor.email ?? '', style: const TextStyle(color: Colors.white38, fontSize: 11)),
            ],
          ),
        ),
        DataCell(Text(visitor.createdAt != null ? DateFormat('dd MMM yy').format(visitor.createdAt!) : '—')),
        DataCell(Text(visitor.source.toUpperCase(), style: const TextStyle(fontSize: 10))),
        DataCell(
          Switch(
            value: visitor.isVerified, 
            activeColor: Colors.green,
            onChanged: (val) => _handleToggleVisitorVerification(visitor.id, visitor.isVerified),
          ),
        ),
        DataCell(Text(visitor.updatedAt != null ? DateFormat('dd MMM HH:mm').format(visitor.updatedAt!) : '—')),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: Icon(LucideIcons.edit, size: 16, color: Colors.white24),
                onPressed: () {
                  final user = ProfessionalModel(
                    id: visitor.id,
                    fullNameEn: visitor.name,
                    email: visitor.email,
                    phone: visitor.phone,
                    role: 'visitor',
                    isActive: true,
                  );
                  showDialog(context: context, builder: (_) => AdminEditUserModal(user: user));
                }
              ),
              IconButton(icon: Icon(LucideIcons.trash2, size: 16, color: Colors.redAccent), onPressed: () => _handleDelete(visitor.id, 'directory_visitors')),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildServicesTab() {
    final asyncServices = ref.watch(servicesStreamProvider);
    return asyncServices.when(
      data: (services) {
        final filtered = _filterData<ServiceModel>(services, (s) => s.createdAt, (s, st) => st == 'active' ? s.isActive : !s.isActive);
        return _buildServicesTable(filtered);
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('Error: $e')),
    );
  }

  Widget _buildServicesTable(List<ServiceModel> services) {
    return Card(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingTextStyle: EspyTheme.cinzelStyle.copyWith(fontSize: 10, color: EspyTheme.gold),
            dataTextStyle: EspyTheme.loraStyle.copyWith(fontSize: 13, color: Colors.white70),
            columnSpacing: 24,
            columns: const [
              DataColumn(label: Text('SERVICE')),
              DataColumn(label: Text('DATE')),
              DataColumn(label: Text('PROVIDER')),
              DataColumn(label: Text('FAVS')),
              DataColumn(label: Text('PRICING')),
              DataColumn(label: Text('STATUS')),
              DataColumn(label: Text('ACTIONS')),
            ],
            rows: services.map((s) => _buildServiceRow(s)).toList(),
          ),
        ),
      ),
    );
  }

  DataRow _buildServiceRow(ServiceModel service) {
    return DataRow(
      cells: [
        DataCell(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(service.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              Text(service.id, style: const TextStyle(color: Colors.white12, fontSize: 9)),
            ],
          ),
        ),
        DataCell(Text(service.createdAt != null ? DateFormat('dd MMM yy').format(service.createdAt!) : '—')),
        DataCell(Text(service.professionalId.length > 8 ? service.professionalId.substring(0, 8) : service.professionalId)),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: EspyTheme.gold.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Text('${service.favoriteCount}', style: const TextStyle(color: EspyTheme.gold, fontWeight: FontWeight.bold, fontSize: 11)),
          ),
        ),
        DataCell(Text(service.pricingType.toUpperCase(), style: const TextStyle(fontSize: 10))),
        DataCell(Text(service.isActive ? 'LIVE' : 'HIDDEN', style: TextStyle(color: service.isActive ? Colors.green : Colors.white24, fontSize: 9, fontWeight: FontWeight.bold))),
        DataCell(
          Row(
            children: [
              IconButton(icon: Icon(LucideIcons.edit, size: 16, color: Colors.white24), onPressed: () {}),
              IconButton(icon: Icon(LucideIcons.trash2, size: 16, color: Colors.redAccent), onPressed: () => _handleDelete(service.id, 'directory_services')),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCommunityRequestsTab() {
    final asyncRequests = ref.watch(communityRequestsStreamProvider);
    return asyncRequests.when(
      data: (data) {
        final filtered = _filterData<Map<String, dynamic>>(data, (r) => (r['createdAt'] as Timestamp?)?.toDate(), (r, st) => r['status'] == st);
        return _buildCommunityTable(filtered);
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('Error: $e')),
    );
  }

  Widget _buildCommunityTable(List<Map<String, dynamic>> requests) {
    return Card(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingTextStyle: EspyTheme.cinzelStyle.copyWith(fontSize: 10, color: EspyTheme.gold),
            dataTextStyle: EspyTheme.loraStyle.copyWith(fontSize: 13, color: Colors.white70),
            columnSpacing: 24,
            columns: const [
              DataColumn(label: Text('REQUEST')),
              DataColumn(label: Text('DATE')),
              DataColumn(label: Text('CONTENT')),
              DataColumn(label: Text('REQUESTER')),
              DataColumn(label: Text('STATUS')),
              DataColumn(label: Text('ACTIONS')),
            ],
            rows: requests.map((r) => _buildCommunityRow(r)).toList(),
          ),
        ),
      ),
    );
  }

  DataRow _buildCommunityRow(Map<String, dynamic> req) {
    final status = req['status'] ?? 'pending';
    return DataRow(
      cells: [
        DataCell(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(req['title'] ?? 'Untitled', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              Text(req['id'], style: const TextStyle(color: Colors.white12, fontSize: 9)),
            ],
          ),
        ),
        DataCell(Text(req['createdAt'] != null ? DateFormat('dd MMM yy').format((req['createdAt'] as Timestamp).toDate()) : '—')),
        DataCell(SizedBox(width: 200, child: Text(req['description'] ?? '', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11)))),
        DataCell(Text(req['requester_name'] ?? 'Anonymous')),
        DataCell(
          Switch(
            value: status == 'active',
            activeColor: Colors.green,
            onChanged: (val) => _handleToggleRequestStatus(req['id'], status == 'active'),
          ),
        ),
        DataCell(
          Row(
            children: [
              IconButton(icon: Icon(LucideIcons.trash2, size: 16, color: Colors.redAccent), onPressed: () => _handleDelete(req['id'], 'directory_community_requests')),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _handleToggleRequestStatus(String id, bool current) async {
    try {
      await ref.read(firestoreServiceProvider).toggleCommunityRequestStatus(id, !current);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Request status updated')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $e')));
    }
  }

  Future<void> _handleToggleApproval(String id, bool current, String role) async {
    try {
      await ref.read(firestoreServiceProvider).approveProfessional(id, !current, role);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Approval status updated')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $e')));
    }
  }

  Future<void> _handleToggleHonor(String id, bool current, String role) async {
    try {
      await ref.read(firestoreServiceProvider).toggleHonorBadge(id, current, role);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(current ? 'Honor badge removed' : 'Honor badge granted')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $e')));
    }
  }

  Future<void> _handleToggleVisitorVerification(String id, bool current) async {
    try {
      await ref.read(firestoreServiceProvider).updateUser(id, 'visitor', {'isVerified': !current});
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Visitor verification updated')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $e')));
    }
  }

  Future<void> _handleDelete(String id, String col) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF061226),
        title: const Text('CONFIRM FORFEIT'),
        content: const Text('Are you sure you want to permanently delete this node? This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('CANCEL')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent), child: const Text('DELETE')),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await ref.read(firestoreServiceProvider).deleteItem(col, id);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Node successfully removed')));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Deletion failed: $e')));
      }
    }
  }

  Future<void> _handleExport() async {
    final firestore = ref.read(firestoreServiceProvider);
    String fileName;
    List<String> headers;
    List<List<dynamic>> rows = [];

    switch (_tabController.index) {
      case 0:
        fileName = 'Professionals';
        headers = ['ID', 'Name', 'Email', 'Specialty', 'Phone', 'Approved', 'Tier', 'Created'];
        final data = await firestore.listCollection('directory_professionals');
        for (var d in data) {
          final u = ProfessionalModel.fromJson(d);
          rows.add([u.id, u.fullNameEn, u.email, u.specialty, u.phone, u.isApproved, u.membershipTier, u.createdAt]);
        }
        break;
      case 1:
        fileName = 'Institutions';
        headers = ['ID', 'Name', 'Email', 'Specialty', 'Phone', 'Approved', 'Tier', 'Created'];
        final data = await firestore.listCollection('directory_institutions');
        for (var d in data) {
          final u = ProfessionalModel.fromJson(d);
          rows.add([u.id, u.fullNameEn, u.email, u.specialty, u.phone, u.isApproved, u.membershipTier, u.createdAt]);
        }
        break;
      case 2:
        fileName = 'Visitors';
        headers = ['ID', 'Name', 'Email', 'Source', 'Verified', 'Created', 'Last Active'];
        final data = await firestore.listCollection('directory_visitors');
        for (var d in data) {
          final v = VisitorModel.fromJson(d);
          final u = ProfessionalModel.fromJson(d); // To get lastActive if stored there
          rows.add([v.id, v.name, v.email, v.source, v.isVerified, v.createdAt, u.lastActive]);
        }
        break;
      case 3:
        fileName = 'Services';
        headers = ['ID', 'Title', 'Provider ID', 'Pricing', 'Active', 'Created'];
        final data = await firestore.listCollection('directory_services');
        for (var d in data) {
          final s = ServiceModel.fromJson(d);
          rows.add([s.id, s.title, s.professionalId, s.pricingType, s.isActive, s.createdAt]);
        }
        break;
      case 4:
        fileName = 'Community_Requests';
        headers = ['ID', 'Title', 'Requester', 'Status', 'Approved', 'Created'];
        final data = await firestore.listCollection('directory_community_requests');
        for (var d in data) {
          rows.add([d['id'], d['title'], d['requester_name'], d['status'], d['is_approved'], (d['createdAt'] as Timestamp?)?.toDate()]);
        }
        break;
      default: return;
    }
    
    await ExportService.exportToExcel('Registry_${fileName}_${DateFormat('yyyyMMdd').format(DateTime.now())}', headers, rows);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$fileName export complete')));
  }
}
