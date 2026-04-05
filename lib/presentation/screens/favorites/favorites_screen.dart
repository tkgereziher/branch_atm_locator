import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample Favorites Data
    final List<Map<String, dynamic>> _favorites = [
      {"id": "cbe-1", "name": "CBE - Main Branch", "distance": "1.2 km away", "type": "Branches", "icon": Icons.account_balance_rounded},
      {"id": "awash-1", "name": "Awash ATM - Bole", "distance": "0.5 km away", "type": "ATMs", "icon": Icons.atm_rounded},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("My Favorites", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppColors.primary,
        centerTitle: true,
      ),
      body: _favorites.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite_border_rounded, size: 80, color: AppColors.textSecondary.withOpacity(0.3)),
                const SizedBox(height: 16),
                const Text(
                  "No favorites yet",
                  style: TextStyle(fontSize: 18, color: AppColors.textSecondary, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Branches and ATMs you save will appear here.",
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
          )
        : ListView.separated(
            padding: const EdgeInsets.all(20.0),
            itemCount: _favorites.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final loc = _favorites[index];
              return _buildFavoriteCard(context, loc);
            },
          ),
    );
  }

  Widget _buildFavoriteCard(BuildContext context, Map<String, dynamic> loc) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.divider),
      ),
      child: InkWell(
        onTap: () => context.push('/details/${loc['id']}'),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.primary.withOpacity(0.1),
                radius: 28,
                child: Icon(loc['icon'], color: AppColors.primary, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loc['name'],
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${loc['type']} • ${loc['distance']}",
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.favorite_rounded, color: AppColors.error),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
