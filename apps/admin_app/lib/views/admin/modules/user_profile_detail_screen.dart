import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../theme/espy_theme.dart';
import '../../../viewmodels/espy_repository.dart';
import '../../../viewmodels/user_manager_view_model.dart';
import '../../../widgets/common/premium_card.dart';
import '../../../widgets/common/espy_scaffold.dart';
import '../../../widgets/common/premium_button.dart';

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
    final data = await vm.getUserDetails(widget.userId);
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
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildStatusCard(vm),
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

  Widget _buildStatusCard(UserManagerViewModel vm) {
    final bool isActive = _userDetails?['isActive'] != false;
    final bool isApproved = _userDetails?['isApproved'] == true;
    final bool isValidated = _userDetails?['isProfileValidated'] == true;

    return PremiumCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _statusRow("ACCOUNT STATUS", isActive ? "ACTIVE" : "SUSPENDED", isActive ? EspyTheme.success : Colors.redAccent),
          const Divider(height: 24),
          _statusRow("IDENTITY VERIFICATION", isApproved ? "VERIFIED" : "UNVERIFIED", isApproved ? EspyTheme.royalBlue : EspyTheme.gold),
          const Divider(height: 24),
          _statusRow("PROTOCOL VALIDATION", isValidated ? "VALIDATED" : "PENDING", isValidated ? EspyTheme.success : EspyTheme.gold),
        ],
      ),
    );
  }

  Widget _statusRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.cinzel(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.black38)),
        Text(value, style: GoogleFonts.montserrat(fontSize: 11, fontWeight: FontWeight.w900, color: color)),
      ],
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
    final bool isApproved = _userDetails?['isApproved'] == true;

    return Column(
      children: [
        if (!isApproved)
          PremiumButton(
            label: "VERIFY IDENTITY & APPROVE",
            fullWidth: true,
            variant: PremiumButtonVariant.gold,
            onPressed: () async {
              await vm.verifyUser(_userDetails!['id'], _userDetails!['role'], true);
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
                onPressed: () {},
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: PremiumButton(
                label: isActive ? "SUSPEND" : "REACTIVATE",
                variant: isActive ? PremiumButtonVariant.outline : PremiumButtonVariant.cyan,
                onPressed: () async {
                  await vm.suspendUser(_userDetails!['id'], isActive);
                  _loadDetails();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
