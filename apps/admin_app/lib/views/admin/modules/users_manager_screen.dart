import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:espy_core/espy_core.dart';
import '../../../theme/espy_theme.dart';
import '../../../viewmodels/user_manager_view_model.dart';
import '../../../widgets/common/premium_card.dart';
import '../../../widgets/common/espy_scaffold.dart';
import '../../../widgets/common/espy_filter_bar.dart';
import '../../../widgets/common/espy_status_badge.dart';
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
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query, UserManagerViewModel vm) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      vm.updateSearchQuery(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<UserManagerViewModel>(context);

    return EspyScaffold(
      useCinematicBackground: false,
      appBar: AppBar(
        title: Text("USER PROTOCOLS", style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, fontSize: 14)),
        backgroundColor: Colors.white,
        foregroundColor: EspyTheme.navyDeep,
      ),
      body: Column(
        children: [
          _buildSearchHeader(viewModel),
          _buildFilterBar(viewModel),
          Expanded(
            child: viewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : viewModel.users.isEmpty 
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.all(24),
                        itemCount: viewModel.users.length,
                        itemBuilder: (context, index) {
                          final user = viewModel.users[index];
                          return _buildUserTile(context, user);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchHeader(UserManagerViewModel vm) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
      color: Colors.white,
      child: TextField(
        controller: _searchController,
        onChanged: (q) => _onSearchChanged(q, vm),
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

  Widget _buildFilterBar(UserManagerViewModel vm) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
      color: Colors.white,
      child: Column(
        children: [
          EspyFilterBar(
            label: "ROLE",
            options: const ["visitor", "professional", "institution"],
            selectedOption: vm.filterRole,
            onSelected: (role) => vm.updateFilters(role: role),
          ),
          const SizedBox(height: 16),
          EspyFilterBar(
            label: "STATUS",
            options: const ["PENDING", "ACTIVE", "VERIFIED", "SUSPENDED"],
            selectedOption: vm.filterStatus,
            onSelected: (status) => vm.updateFilters(status: status),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.person_search_rounded, size: 64, color: Colors.black12),
          const SizedBox(height: 16),
          Text("NO USERS MATCHING CRITERIA", style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, color: Colors.black26, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildUserTile(BuildContext context, UserModel user) {
    final String dateStr = DateFormat('dd/MM/yy').format(user.createdAt);
    final String phone = user.phone ?? user.whatsapp ?? 'N/A';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: PremiumCard(
        padding: const EdgeInsets.all(16),
        child: InkWell(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => UserProfileDetailScreen(userId: user.id))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.name.toUpperCase(), style: GoogleFonts.montserrat(fontWeight: FontWeight.w900, fontSize: 13)),
                        Text(user.email, style: GoogleFonts.lora(fontSize: 10, color: Colors.black45)),
                      ],
                    ),
                  ),
                  EspyStatusBadge.fromFlags(
                    hasProfile: user.hasProfile,
                    isActive: user.isActive,
                    isApproved: false, // user['isApproved'] is in detail fetch
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Divider(height: 1, color: Colors.black12),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _infoBit("ID", user.id.substring(0, 8).toUpperCase()),
                  _infoBit("PHONE", phone),
                  _infoBit("JOINED", dateStr),
                  _tag(user.role.name.toUpperCase(), EspyTheme.navyDeep),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoBit(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.cinzel(fontSize: 7, fontWeight: FontWeight.bold, color: Colors.black26)),
        Text(value, style: GoogleFonts.montserrat(fontSize: 9, fontWeight: FontWeight.w700, color: EspyTheme.navyDeep)),
      ],
    );
  }

  Widget _tag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
      child: Text(label, style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: color)),
    );
  }
}
