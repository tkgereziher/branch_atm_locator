import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String _selectedCategory = "All";
  String _selectedBank = "All Banks";

  final List<String> _banks = ["All Banks", "CBE", "Awash", "Dashen", "Abyssinia", "Zemen"];
  final List<Map<String, dynamic>> _allLocations = [
    {"id": "cbe-1", "name": "CBE - Main Branch", "distance": "1.2 km away", "type": "Branches", "bank": "CBE", "icon": Icons.account_balance_rounded},
    {"id": "awash-1", "name": "Awash ATM - Bole", "distance": "0.5 km away", "type": "ATMs", "bank": "Awash", "icon": Icons.atm_rounded},
    {"id": "dashen-1", "name": "Dashen Bank - Kazanchis", "distance": "2.1 km away", "type": "Branches", "bank": "Dashen", "icon": Icons.account_balance_rounded},
    {"id": "cbe-2", "name": "CBE ATM - Piazza", "distance": "0.8 km away", "type": "ATMs", "bank": "CBE", "icon": Icons.atm_rounded},
  ];

  List<Map<String, dynamic>> get _filteredLocations {
    return _allLocations.where((loc) {
      final categoryMatch = _selectedCategory == "All" || loc['type'] == _selectedCategory;
      final bankMatch = _selectedBank == "All Banks" || loc['bank'] == _selectedBank;
      return categoryMatch && bankMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Bank & ATM Locator", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: AppColors.primary),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
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
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
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
                  _buildCategoryFilter(Icons.account_balance_rounded, "Branches"),
                  _buildCategoryFilter(Icons.atm_rounded, "ATMs"),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Bank Selector
            const Text(
              "Select Bank",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _banks.length,
                itemBuilder: (context, index) => _buildBankChip(_banks[index]),
              ),
            ),
            const SizedBox(height: 32),
            
            // Recommended Locations
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedCategory == "All" ? "Recommended" : "$_selectedCategory Nearby",
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
            
            if (_filteredLocations.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(40.0),
                  child: Text("No locations found for these filters."),
                ),
              )
            else
              ..._filteredLocations.map((loc) => Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: _buildLocationCard(context, loc['id'], loc['name'], loc['distance'], loc['icon']),
              )),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_rounded), label: "Favorites"),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: "Profile"),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/map-view'),
        icon: const Icon(Icons.map_rounded),
        label: const Text("Map View"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildCategoryFilter(IconData icon, String label) {
    bool isSelected = _selectedCategory == label;
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: FilterChip(
        avatar: Icon(icon, color: isSelected ? Colors.white : AppColors.textSecondary, size: 20),
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

  Widget _buildBankChip(String bankName) {
    bool isSelected = _selectedBank == bankName;
    return GestureDetector(
      onTap: () => setState(() => _selectedBank = bankName),
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? AppColors.secondary : AppColors.divider),
        ),
        child: Text(
          bankName,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildLocationCard(BuildContext context, String id, String name, String distance, IconData icon) {
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
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        subtitle: Text(distance, style: const TextStyle(color: AppColors.textSecondary)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.divider),
        onTap: () => context.push('/details/$id'),
      ),
    );
  }
}
