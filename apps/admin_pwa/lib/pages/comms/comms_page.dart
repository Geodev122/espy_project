import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../widgets/common/admin_badge.dart';
import '../../services/firestore_service.dart';
import '../registry/registry_providers.dart';

class CommsPage extends ConsumerStatefulWidget {
  const CommsPage({super.key});

  @override
  ConsumerState<CommsPage> createState() => _CommsPageState();
}

class _CommsPageState extends ConsumerState<CommsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Admin Push Controllers
  final TextEditingController _pushTitleCtrl = TextEditingController();
  final TextEditingController _pushBodyCtrl = TextEditingController();
  final TextEditingController _pushUserIdCtrl = TextEditingController();
  String _pushTargetType = 'all'; 
  String _selectedRole = 'visitor';

  // Support Inbox State
  Map<String, dynamic>? _selectedSupportMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
          _buildTabs(),
          const SizedBox(height: 24),
          Expanded(
            child: Scrollbar(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildUserBroadcastsTab(),
                  _buildAdminPushTab(),
                  _buildVisitorsRequestsTab(),
                  _buildSupportInboxTab(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SIGNAL & SOCIAL HUB',
          style: EspyTheme.cinzelStyle.copyWith(fontSize: 24, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(
          'Manage community signals, direct broadcasts, and provider assistance',
          style: EspyTheme.loraStyle.copyWith(fontSize: 14, color: Colors.white38),
        ),
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
        tabs: const [
          Tab(text: 'USER BROADCASTS'),
          Tab(text: 'ADMIN PUSH BROADCASTS'),
          Tab(text: 'VISITORS REQUESTS'),
          Tab(text: 'SUPPORT INBOX'),
        ],
      ),
    );
  }

  // ─── TAB 1: USER BROADCASTS ────────────────────────────────────────────────

  Widget _buildUserBroadcastsTab() {
    final asyncBroadcasts = ref.watch(userBroadcastsStreamProvider);

    return asyncBroadcasts.when(
      data: (data) => Card(
        child: Scrollbar(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingTextStyle: EspyTheme.cinzelStyle.copyWith(fontSize: 10, color: EspyTheme.gold),
                dataTextStyle: EspyTheme.loraStyle.copyWith(fontSize: 13, color: Colors.white70),
                columnSpacing: 24,
                columns: const [
                  DataColumn(label: Text('DATE')),
                  DataColumn(label: Text('ID')),
                  DataColumn(label: Text('USER ID')),
                  DataColumn(label: Text('TARGET')),
                  DataColumn(label: Text('CONTENT')),
                  DataColumn(label: Text('STATUS')),
                  DataColumn(label: Text('ACTIONS')),
                ],
                rows: data.map((b) => _buildUserBroadcastRow(b)).toList(),
              ),
            ),
          ),
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.shieldAlert, color: Colors.redAccent, size: 48),
            const SizedBox(height: 16),
            Text('ACCESS RESTRICTED: $e', style: const TextStyle(color: Colors.white38)),
          ],
        )
      ),
    );
  }

  DataRow _buildUserBroadcastRow(Map<String, dynamic> b) {
    final status = b['status'] ?? 'queued';
    return DataRow(
      cells: [
        DataCell(Text(b['timestamp'] != null ? DateFormat('dd MMM HH:mm').format((b['timestamp'] as Timestamp).toDate()) : '—')),
        DataCell(Text(b['id'].toString().substring(0, 8))),
        DataCell(Text(b['senderId']?.toString().substring(0, 8) ?? '—')),
        DataCell(Text(b['targetCountry'] ?? 'GLOBAL')),
        DataCell(SizedBox(width: 200, child: Text(b['title'] ?? '', maxLines: 1, overflow: TextOverflow.ellipsis))),
        DataCell(AdminBadge(
          variant: status == 'approved' ? 'emerald' : (status == 'offensive' ? 'danger' : 'gold'),
          children: Text(status.toUpperCase()),
        )),
        DataCell(
          Row(
            children: [
              IconButton(icon: Icon(LucideIcons.eye, size: 16), onPressed: () => _viewBroadcastDetails(b)),
              if (status == 'queued' || status == 'pending') ...[
                IconButton(icon: Icon(LucideIcons.checkCircle, size: 16, color: Colors.green), onPressed: () => _handleBroadcastAction(b, 'approved')),
                IconButton(icon: Icon(LucideIcons.shieldAlert, size: 16, color: Colors.redAccent), onPressed: () => _handleBroadcastAction(b, 'offensive')),
              ],
              IconButton(icon: Icon(LucideIcons.trash2, size: 16, color: Colors.white12), onPressed: () => _deleteBroadcast(b['id'])),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _viewBroadcastDetails(Map<String, dynamic> b) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF061226),
        title: Text('BROADCAST DETAILS: ${b['id'].substring(0,8)}', style: EspyTheme.cinzelStyle.copyWith(fontSize: 14)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (b['imageUrl'] != null) 
              Image.network(b['imageUrl'], height: 200, width: double.infinity, fit: BoxFit.cover),
            const SizedBox(height: 16),
            Text(b['title'] ?? 'Untitled', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            Text(b['message'] ?? '', style: const TextStyle(color: Colors.white70)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('DISMISS')),
        ],
      ),
    );
  }

  Future<void> _handleBroadcastAction(Map<String, dynamic> b, String status) async {
    try {
      final firestore = ref.read(firestoreServiceProvider);
      await firestore.updateBroadcastStatus(b['id'], status);
      
      String title = 'BROADCAST ${status.toUpperCase()}';
      String msg = status == 'approved' 
        ? 'Your broadcast has been validated and published to the network.' 
        : 'Your broadcast was flagged as offensive and rejected. No credits were deducted.';
      
      await firestore.sendInAppNotification(
        userId: b['senderId'],
        title: title,
        message: msg,
        type: 'broadcast_decision',
      );

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Action Recorded: $status')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _deleteBroadcast(String id) async {
     await ref.read(firestoreServiceProvider).deleteItem('directory_broadcasts', id);
  }

  // ─── TAB 2: ADMIN PUSH BROADCASTS ──────────────────────────────────────────

  Widget _buildAdminPushTab() {
    final asyncNotifications = ref.watch(adminNotificationsStreamProvider);

    return Column(
      children: [
        _buildPushComposer(),
        const SizedBox(height: 24),
        Expanded(
          child: asyncNotifications.when(
            data: (data) => Card(
              child: Scrollbar(
                child: data.isEmpty 
                  ? const Center(child: Text('NO SIGNAL HISTORY FOUND', style: TextStyle(color: Colors.white10, fontSize: 10)))
                  : ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, i) => _buildPushLogTile(data[i]),
                    ),
              ),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.lock, color: Colors.orangeAccent, size: 32),
                  const SizedBox(height: 12),
                  Text('HISTORY UNAVAILABLE: $e', style: const TextStyle(color: Colors.white24, fontSize: 11)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPushComposer() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('DISPATCH GOVERNANCE SIGNAL', style: EspyTheme.cinzelStyle.copyWith(fontSize: 12, color: EspyTheme.gold)),
                _buildTargetTypeSelector(),
              ],
            ),
            const SizedBox(height: 24),
            _buildTargetFields(),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: _buildComposeField('HEADLINE', 'e.g. Protocol Update', _pushTitleCtrl)),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: _executePush,
                  icon: Icon(LucideIcons.send, size: 16),
                  label: const Text('TRANSMIT'),
                  style: ElevatedButton.styleFrom(backgroundColor: EspyTheme.electricBlue, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildComposeField('MESSAGE CONTENT', 'Broadcast details...', _pushBodyCtrl, isLong: true),
          ],
        ),
      ),
    );
  }

  Widget _buildTargetTypeSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
      child: DropdownButton<String>(
        value: _pushTargetType,
        underline: const SizedBox(),
        items: const [
          DropdownMenuItem(value: 'all', child: Text('GLOBAL')),
          DropdownMenuItem(value: 'user', child: Text('SPECIFIC UID')),
          DropdownMenuItem(value: 'role', child: Text('MISSION ROLE')),
        ],
        onChanged: (v) => setState(() => _pushTargetType = v!),
      ),
    );
  }

  Widget _buildTargetFields() {
    if (_pushTargetType == 'user') {
      return TextField(controller: _pushUserIdCtrl, decoration: const InputDecoration(hintText: 'TARGET FIREBASE UID'));
    }
    if (_pushTargetType == 'role') {
      return DropdownButton<String>(
        value: _selectedRole,
        items: const [
          DropdownMenuItem(value: 'visitor', child: Text('VISITORS')),
          DropdownMenuItem(value: 'professional', child: Text('PROFESSIONALS')),
          DropdownMenuItem(value: 'institution', child: Text('INSTITUTIONS')),
        ],
        onChanged: (v) => setState(() => _selectedRole = v!),
      );
    }
    return const SizedBox();
  }

  Widget _buildPushLogTile(Map<String, dynamic> n) {
    return ListTile(
      leading: Icon(LucideIcons.radio, color: EspyTheme.cyan, size: 18),
      title: Text(n['title'] ?? 'Signal', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      subtitle: Text(n['message'] ?? '', maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          AdminBadge(variant: 'outline', children: Text(n['target']?.toString().toUpperCase() ?? 'ALL')),
          Text(n['timestamp'] != null ? DateFormat('dd MMM HH:mm').format((n['timestamp'] as Timestamp).toDate()) : '—', style: const TextStyle(fontSize: 9, color: Colors.white12)),
        ],
      ),
    );
  }

  Future<void> _executePush() async {
    if (_pushTitleCtrl.text.isEmpty || _pushBodyCtrl.text.isEmpty) return;
    final firestore = ref.read(firestoreServiceProvider);
    String target = _pushTargetType == 'all' ? 'all' : (_pushTargetType == 'user' ? _pushUserIdCtrl.text : _selectedRole);
    
    // 1. Send as In-App Notification (Live)
    await firestore.sendInAppNotification(userId: target, title: _pushTitleCtrl.text, message: _pushBodyCtrl.text, type: 'admin_push');
    
    // 2. Record in directory_broadcasts for historical visibility in the network
    await FirebaseFirestore.instance.collection('directory_broadcasts').add({
      'title': _pushTitleCtrl.text,
      'message': _pushBodyCtrl.text,
      'senderId': 'ADMIN',
      'senderName': 'ESPY GOVERNANCE',
      'status': 'approved',
      'targetCountry': target.toUpperCase(),
      'timestamp': FieldValue.serverTimestamp(),
      'createdAt': FieldValue.serverTimestamp(),
    });

    _pushTitleCtrl.clear();
    _pushBodyCtrl.clear();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Signal Transmitted and Recorded')));
  }

  // ─── TAB 3: VISITORS REQUESTS ──────────────────────────────────────────────

  Widget _buildVisitorsRequestsTab() {
    final asyncRequests = ref.watch(communityRequestsStreamProvider);
    return asyncRequests.when(
      data: (data) => Card(
        child: Scrollbar(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingTextStyle: EspyTheme.cinzelStyle.copyWith(fontSize: 10, color: EspyTheme.gold),
                dataTextStyle: EspyTheme.loraStyle.copyWith(fontSize: 13, color: Colors.white70),
                columnSpacing: 24,
                columns: const [
                  DataColumn(label: Text('DATE')),
                  DataColumn(label: Text('TITLE')),
                  DataColumn(label: Text('CONTENT PREVIEW')),
                  DataColumn(label: Text('STATUS')),
                  DataColumn(label: Text('ACTIONS')),
                ],
                rows: data.map((r) => _buildRequestRow(r)).toList(),
              ),
            ),
          ),
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('Error: $e')),
    );
  }

  DataRow _buildRequestRow(Map<String, dynamic> r) {
    final status = r['status'] ?? 'pending';
    return DataRow(
      cells: [
        DataCell(Text(r['createdAt'] != null ? DateFormat('dd MMM yy').format((r['createdAt'] as Timestamp).toDate()) : '—')),
        DataCell(Text(r['title'] ?? 'Untitled')),
        DataCell(SizedBox(width: 300, child: Text(r['description'] ?? '', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11)))),
        DataCell(Switch(
          value: status == 'active',
          activeColor: Colors.green,
          onChanged: (val) => ref.read(firestoreServiceProvider).toggleCommunityRequestStatus(r['id'], val),
        )),
        DataCell(IconButton(icon: Icon(LucideIcons.trash2, size: 16, color: Colors.redAccent), onPressed: () => _deleteRequest(r['id']))),
      ],
    );
  }

  Future<void> _deleteRequest(String id) async {
    await ref.read(firestoreServiceProvider).deleteItem('directory_community_requests', id);
  }

  // ─── TAB 4: SUPPORT INBOX ──────────────────────────────────────────────────

  Widget _buildSupportInboxTab() {
    final asyncSupport = ref.watch(supportInboxStreamProvider);

    return asyncSupport.when(
      data: (data) => Row(
        children: [
          Expanded(
            flex: 2,
            child: Card(
              child: Scrollbar(
                child: ListView.separated(
                  itemCount: data.length,
                  separatorBuilder: (_, __) => Divider(height: 1, color: Colors.white.withOpacity(0.05)),
                  itemBuilder: (context, i) => _buildSupportListTile(data[i]),
                ),
              ),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            flex: 3,
            child: _selectedSupportMessage == null 
              ? const Center(child: Text('SELECT COMMUNICATION', style: TextStyle(color: Colors.white10, fontSize: 10)))
              : _buildSupportDetailView(),
          ),
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('Error: $e')),
    );
  }

  Widget _buildSupportListTile(Map<String, dynamic> msg) {
    final isNew = msg['status'] == 'unread';
    return ListTile(
      selected: _selectedSupportMessage?['id'] == msg['id'],
      onTap: () => setState(() => _selectedSupportMessage = msg),
      leading: CircleAvatar(backgroundColor: isNew ? EspyTheme.gold : Colors.white.withOpacity(0.05), radius: 4),
      title: Text(msg['sender_name'] ?? 'User', style: TextStyle(fontWeight: isNew ? FontWeight.bold : FontWeight.normal, fontSize: 13)),
      subtitle: Text(msg['subject'] ?? 'No Subject', maxLines: 1),
      trailing: Text(msg['timestamp'] != null ? DateFormat('HH:mm').format((msg['timestamp'] as Timestamp).toDate()) : ''),
    );
  }

  Widget _buildSupportDetailView() {
    final msg = _selectedSupportMessage!;
    final TextEditingController replyCtrl = TextEditingController();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(msg['subject']?.toString().toUpperCase() ?? 'SUPPORT', style: EspyTheme.cinzelStyle.copyWith(fontSize: 14, color: EspyTheme.gold)),
                AdminBadge(variant: 'outline', children: Text(msg['status']?.toString().toUpperCase() ?? 'OPEN')),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(child: SingleChildScrollView(child: Text(msg['message'] ?? '', style: const TextStyle(fontSize: 15, height: 1.6, color: Colors.white70)))),
            const Divider(height: 48, color: Colors.white10),
            Row(
              children: [
                Expanded(child: TextField(controller: replyCtrl, decoration: const InputDecoration(hintText: 'Compose response...'))),
                const SizedBox(width: 16),
                IconButton(
                  onPressed: () => _sendSupportReply(msg, replyCtrl.text),
                  icon: Icon(LucideIcons.send, color: EspyTheme.electricBlue),
                  style: IconButton.styleFrom(backgroundColor: EspyTheme.electricBlue.withOpacity(0.1), padding: const EdgeInsets.all(16)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendSupportReply(Map<String, dynamic> msg, String text) async {
    if (text.isEmpty) return;
    final firestore = ref.read(firestoreServiceProvider);
    await firestore.sendInAppNotification(userId: msg['sender_id'] ?? msg['userId'], title: 'SUPPORT RESPONSE', message: text, type: 'support_reply');
    await firestore.updateSupportMessageStatus(msg['id'], 'replied');
    setState(() => _selectedSupportMessage = null);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Response sent')));
  }

  Widget _buildComposeField(String label, String hint, TextEditingController ctrl, {bool isLong = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white38)),
        const SizedBox(height: 8),
        TextField(controller: ctrl, maxLines: isLong ? 4 : 1, decoration: InputDecoration(hintText: hint)),
      ],
    );
  }
}

final userBroadcastsStreamProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  return ref.watch(firestoreServiceProvider).watchUserBroadcasts();
});

final adminNotificationsStreamProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  return ref.watch(firestoreServiceProvider).watchAdminNotifications();
});

final supportInboxStreamProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  return ref.watch(firestoreServiceProvider).watchSupportInbox();
});
