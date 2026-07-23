import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../theme/espy_theme.dart';
import '../../../viewmodels/espy_repository.dart';
import '../../../viewmodels/user_manager_view_model.dart';
import '../../../widgets/common/premium_card.dart';
import '../../../widgets/common/espy_scaffold.dart';
import 'user_profile_detail_screen.dart';

class UsersManagerScreen extends StatelessWidget {
  const UsersManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserManagerViewModel(context.read<EspyRepository>()),
      child: const _UsersManagerView(),
    );
  }
}

class _UsersManagerView extends StatefulWidget {
  const _UsersManagerView();

  @override
  State<_UsersManagerView> createState() => _UsersManagerViewState();
}

class _UsersManagerViewState extends State<_UsersManagerView> {
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<UserManagerViewModel>(context);

    final filteredUsers = viewModel.users.where((u) {
      final query = _searchQuery.toLowerCase();
      return u['name']?.toString().toLowerCase().contains(query) == true ||
             u['email']?.toString().toLowerCase().contains(query) == true ||
             u['id']?.toString().toLowerCase().contains(query) == true;
    }).toList();

    return EspyScaffold(
      useCinematicBackground: false,
      appBar: AppBar(
        title: Text("USER PROTOCOLS", style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, fontSize: 14)),
        backgroundColor: Colors.white,
        foregroundColor: EspyTheme.navyDeep,
      ),
      body: Column(
        children: [
          _buildSearchHeader(),
          Expanded(
            child: viewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.all(24),
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = filteredUsers[index];
                      return _buildUserTile(context, user);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      color: Colors.white,
      child: TextField(
        onChanged: (v) => setState(() => _searchQuery = v),
        decoration: InputDecoration(
          hintText: "SEARCH ID, NAME OR EMAIL...",
          prefixIcon: const Icon(Icons.search_rounded),
          filled: true,
          fillColor: EspyTheme.platinum,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _buildUserTile(BuildContext context, Map<String, dynamic> user) {
    final bool isSuspended = user['isActive'] == false;
    final bool isVerified = user['isApproved'] == true;
    final bool isPending = user['hasProfile'] == false;
    
    String status = "ACTIVE";
    Color statusColor = EspyTheme.success;

    if (isSuspended) {
      status = "SUSPENDED";
      statusColor = Colors.redAccent;
    } else if (isVerified) {
      status = "VERIFIED";
      statusColor = EspyTheme.royalBlue;
    } else if (isPending) {
      status = "PENDING";
      statusColor = EspyTheme.gold;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: PremiumCard(
        padding: const EdgeInsets.all(16),
        child: InkWell(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => UserProfileDetailScreen(userId: user['id']))),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user['name']?.toString().toUpperCase() ?? 'UNNAMED', style: GoogleFonts.montserrat(fontWeight: FontWeight.w900, fontSize: 13)),
                    Text(user['email'] ?? 'No Email', style: GoogleFonts.lora(fontSize: 10, color: Colors.black45)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _tag(user['role']?.toString().toUpperCase() ?? 'VISITOR', EspyTheme.navyDeep),
                        const SizedBox(width: 8),
                        _tag(status, statusColor),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: EspyTheme.gold),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
      child: Text(label, style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: color)),
    );
  }
}
