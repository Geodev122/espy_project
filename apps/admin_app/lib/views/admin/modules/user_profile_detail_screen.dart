import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:espy_core/espy_core.dart';
import '../../../theme/espy_theme.dart';
import '../../../viewmodels/user_manager_view_model.dart';
import '../../../widgets/common/premium_card.dart';
import '../../../widgets/common/espy_scaffold.dart';
import '../../../widgets/common/premium_button.dart';
import '../../../widgets/common/admin_data_row.dart';
import '../../../widgets/common/espy_status_badge.dart';

class UserProfileDetailScreen extends StatelessWidget {
  final String userId;
  const UserProfileDetailScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserManagerViewModel(context.read<EspyRepository>()),
      child: _UserProfileDetailView(userId: userId),
    );
  }
}

class _UserProfileDetailView extends StatefulWidget {
  final String userId;
  const _UserProfileDetailView({required this.userId});

  @override
  State<_UserProfileDetailView> createState() => _UserProfileDetailViewState();
}

class _UserProfileDetailViewState extends State<_UserProfileDetailView> {
  Map<String, dynamic>? _userDetails;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    final vm = Provider.of<UserManagerViewModel>(context, listen: false);
    final data = await vm.getAuditDetails(widget.userId);
    if (mounted) {
      setState(() {
        _userDetails = data;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<UserManagerViewModel>(context);

    return EspyScaffold(
      useCinematicBackground: false,
      appBar: AppBar(
        title: Text("PROTOCOL AUDIT", style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, fontSize: 14)),
        backgroundColor: Colors.white,
        foregroundColor: EspyTheme.navyDeep,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildStatusCard(),
                  const SizedBox(height: 24),
                  _buildDetailsCard(vm),
                  const SizedBox(height: 24),
                  _buildDocumentSection(),
                  const SizedBox(height: 32),
                  _buildAdminActions(vm),
                ],
              ),
            ),
    );
  }

  Widget _buildHeader() {
    return PremiumCard(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: _userDetails?['photoUrl'] != null ? NetworkImage(_userDetails!['photoUrl']) : null,
            backgroundColor: EspyTheme.platinum,
            child: _userDetails?['photoUrl'] == null ? const Icon(Icons.person, size: 40) : null,
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_userDetails?['name']?.toString().toUpperCase() ?? 'UNNAMED', style: GoogleFonts.montserrat(fontWeight: FontWeight.w900, fontSize: 18)),
                Text(_userDetails?['email'] ?? 'No Email', style: GoogleFonts.lora(fontSize: 12, color: Colors.black45)),
                const SizedBox(height: 8),
                Text("ROLE: ${_userDetails?['role']?.toString().toUpperCase()}", style: GoogleFonts.montserrat(fontSize: 10, fontWeight: FontWeight.bold, color: EspyTheme.gold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    return PremiumCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("PROTOCOL STATUS", style: GoogleFonts.cinzel(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.black38, letterSpacing: 2)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              EspyStatusBadge.fromFlags(
                hasProfile: _userDetails?['hasProfile'] == true,
                isActive: _userDetails?['isActive'] != false,
                isApproved: _userDetails?['professionalProfile']?['isApproved'] == true || _userDetails?['institutionProfile']?['isApproved'] == true,
              ),
              Text(
                "SINCE ${_formatDate(_userDetails?['createdAt'])}",
                style: GoogleFonts.montserrat(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.black26),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard(UserManagerViewModel vm) {
    return PremiumCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("IDENTITY DATA", style: GoogleFonts.cinzel(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.black38, letterSpacing: 2)),
          const SizedBox(height: 12),
          AdminDataRow(label: "USER ID", value: widget.userId),
          AdminDataRow(label: "PHONE", value: _userDetails?['phone'] ?? "N/A", onEdit: () => _showEditDialog("phone", _userDetails?['phone'])),
          AdminDataRow(label: "WHATSAPP", value: _userDetails?['whatsapp'] ?? "N/A", onEdit: () => _showEditDialog("whatsapp", _userDetails?['whatsapp'])),
          AdminDataRow(label: "BALANCE", value: "${_userDetails?['walletBalance'] ?? 0} \$E", onEdit: () => _showEditDialog("walletBalance", _userDetails?['walletBalance']?.toString())),
          const Divider(height: 32),
          Text("ADMIN NOTES", style: GoogleFonts.cinzel(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.black38)),
          const SizedBox(height: 8),
          Text(_userDetails?['adminNotes'] ?? "No administrative logs recorded.", style: GoogleFonts.lora(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _buildDocumentSection() {
    final dynamic profile = _userDetails?['professionalProfile'] ?? _userDetails?['institutionProfile'];
    final String? docUrl = profile?['verificationDocUrl'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("VERIFICATION DOCUMENTS", style: GoogleFonts.cinzel(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.black38, letterSpacing: 2)),
        const SizedBox(height: 16),
        PremiumCard(
          padding: const EdgeInsets.all(24),
          child: docUrl != null
              ? Column(
                  children: [
                    const Icon(LucideIcons.fileText, size: 48, color: EspyTheme.royalBlue),
                    const SizedBox(height: 16),
                    Text("Official Credentials Uploaded", style: GoogleFonts.lora(fontSize: 13, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    PremiumButton(
                      label: "VIEW DOCUMENT",
                      size: PremiumButtonSize.small,
                      onPressed: () => launchUrl(Uri.parse(docUrl)),
                    ),
                  ],
                )
              : Center(child: Text("NO DOCUMENTS UPLOADED", style: GoogleFonts.lora(fontSize: 12, color: Colors.black26, fontStyle: FontStyle.italic))),
        ),
      ],
    );
  }

  Widget _buildAdminActions(UserManagerViewModel vm) {
    final bool isActive = _userDetails?['isActive'] != false;
    final dynamic profile = _userDetails?['professionalProfile'] ?? _userDetails?['institutionProfile'];
    final bool isApproved = profile?['isApproved'] == true;

    return Column(
      children: [
        if (!isApproved)
          PremiumButton(
            label: "VERIFY IDENTITY & APPROVE",
            fullWidth: true,
            variant: PremiumButtonVariant.gold,
            onPressed: () async {
              await vm.verifyUser(widget.userId, _userDetails!['role'], true);
              _loadDetails();
            },
          ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: PremiumButton(
                label: "FORCE EDIT",
                variant: PremiumButtonVariant.platinum,
                onPressed: () => _showEditDialog("name", _userDetails?['name']),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: PremiumButton(
                label: isActive ? "SUSPEND" : "REACTIVATE",
                variant: isActive ? PremiumButtonVariant.outline : PremiumButtonVariant.cyan,
                onPressed: () async {
                  await vm.suspendUser(widget.userId, isActive);
                  _loadDetails();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatDate(dynamic date) {
    if (date == null) return "N/A";
    if (date is DateTime) return DateFormat('dd MMM yyyy').format(date);
    return date.toString();
  }

  void _showEditDialog(String field, String? initialValue) {
    final controller = TextEditingController(text: initialValue);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("EDIT ${field.toUpperCase()}"),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: "Enter new $field"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCEL")),
          ElevatedButton(
            onPressed: () async {
              if (_userDetails == null) return;
              final vm = Provider.of<UserManagerViewModel>(context, listen: false);
              
              final Map<String, dynamic> updatedData = Map<String, dynamic>.from(_userDetails!);
              updatedData[field] = field == 'walletBalance' ? (int.tryParse(controller.text) ?? 0) : controller.text.trim();
              
              await vm.adminUpdateUser(widget.userId, UserModel.fromMap(updatedData));
              Navigator.pop(context);
              _loadDetails();
            },
            child: const Text("SAVE"),
          ),
        ],
      ),
    );
  }
}
