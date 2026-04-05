import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/di/injection_container.dart';
import '../../../data/models/bank_model.dart';
import '../../../data/models/location_model.dart';
import '../../../data/services/bank_service.dart';
import '../../../data/services/location_service.dart';
import '../favorites/favorites_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String _selectedCategory = "All";
  String _selectedBank = "All Banks";

  List<BankModel> _banks = [];
  List<LocationModel> _locations = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() { _isLoading = true; _errorMessage = null; });
    try {
      final results = await Future.wait([
        sl<BankService>().getBanks(),
        sl<LocationService>().getLocations(),
      ]);
      setState(() {
        _banks = results[0] as List<BankModel>;
        _locations = results[1] as List<LocationModel>;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load data. Is the server running?';
        _isLoading = false;
      });
    }
  }

  List<LocationModel> get _filteredLocations {
    return _locations.where((loc) {
      final categoryMatch =
          _selectedCategory == "All" || loc.type == _selectedCategory;
      final bankMatch =
          _selectedBank == "All Banks" || loc.bank == _selectedBank;
      return categoryMatch && bankMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: [
        _buildHomeBody(),
        const FavoritesScreen(),
        const ProfileScreen(),
      ][_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_rounded),
            label: "Favorites",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: "Profile",
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () => context.push('/map-view'),
              icon: const Icon(Icons.map_rounded),
              label: const Text("Map View"),
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            )
          : null,
    );
  }

  Widget _buildHomeBody() {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          "Bank & ATM Locator",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: AppColors.primary,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.search_rounded, color: AppColors.primary),
                  hintText: "Search for city, neighborhood...",
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Category Filters
            SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildCategoryFilter(Icons.all_inclusive_rounded, "All"),
                  _buildCategoryFilter(
                    Icons.account_balance_rounded,
                    "Branches",
                  ),
                  _buildCategoryFilter(Icons.atm_rounded, "ATMs"),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Bank Selector
            const Text(
              "Select Bank",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _banks.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) return _buildBankChip(BankModel.allBanks);
                  return _buildBankChip(_banks[index - 1]);
                },
              ),
            ),
            const SizedBox(height: 32),

            // Recommended Locations
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedCategory == "All"
                      ? "Recommended"
                      : "$_selectedCategory Nearby",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextButton(onPressed: () {}, child: const Text("See All")),
              ],
            ),
            const SizedBox(height: 16),

            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(40.0),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_errorMessage != null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.cloud_off_rounded,
                        size: 48,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _loadData,
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Retry'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else if (_filteredLocations.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(40.0),
                  child: Text("No locations found for these filters."),
                ),
              )
            else
              ..._filteredLocations.map(
                (loc) => Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: _buildLocationCard(
                    context,
                    loc.id,
                    loc.name,
                    loc.distance,
                    loc.type == 'ATMs'
                        ? Icons.atm_rounded
                        : Icons.account_balance_rounded,
                  ),
                ),
              ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildCategoryFilter(IconData icon, String label) {
    bool isSelected = _selectedCategory == label;
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: FilterChip(
        avatar: Icon(
          icon,
          color: isSelected ? Colors.white : AppColors.textSecondary,
          size: 20,
        ),
        label: Text(label),
        selected: isSelected,
        onSelected: (bool selected) {
          setState(() => _selectedCategory = label);
        },
        backgroundColor: Colors.white,
        selectedColor: AppColors.primary,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : AppColors.textPrimary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
    );
  }

  Widget _buildBankChip(BankModel bank) {
    final bool isSelected = _selectedBank == bank.name;
    return GestureDetector(
      onTap: () => setState(() => _selectedBank = bank.name),
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.secondary : AppColors.divider,
          ),
        ),
        child: Text(
          bank.name,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildLocationCard(
    BuildContext context,
    String id,
    String name,
    String distance,
    IconData icon,
  ) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.divider),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          distance,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: AppColors.divider,
        ),
        onTap: () => context.push('/details/$id'),
      ),
    );
  }
}
