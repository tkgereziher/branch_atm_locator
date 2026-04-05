import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/di/injection_container.dart';
import '../../../data/models/location_model.dart';
import '../../../data/services/location_service.dart';
import '../../../data/services/favorite_service.dart';

class DetailsScreen extends StatefulWidget {
  final String id;

  const DetailsScreen({super.key, required this.id});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  LocationModel? _location;
  bool _isLoading = true;
  String? _errorMessage;
  bool _isSavingFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadLocationDetails();
  }

  Future<void> _loadLocationDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final service = sl<LocationService>();
      final loc = await service.getLocationById(widget.id);
      setState(() {
        _location = loc;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load details.';
        _isLoading = false;
      });
    }
  }

  Future<void> _addToFavorites() async {
    if (_location == null) return;
    setState(() => _isSavingFavorite = true);
    try {
      final service = sl<FavoriteService>();
      await service.addFavorite(_location!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Added to Favorites!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add to favorites.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSavingFavorite = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Location Details", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppColors.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded),
            onPressed: () {},
          ),
          if (_location != null)
            IconButton(
              icon: _isSavingFavorite
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                    )
                  : const Icon(Icons.favorite_border_rounded),
              onPressed: _isSavingFavorite ? null : _addToFavorites,
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (_errorMessage != null || _location == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded, size: 48, color: AppColors.error),
            const SizedBox(height: 16),
            Text(_errorMessage ?? 'Location not found', style: const TextStyle(color: AppColors.error)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadLocationDetails,
              child: const Text('Retry'),
            )
          ],
        ),
      );
    }

    final loc = _location!;

    return SingleChildScrollView(
      child: Column(
        children: [
          // Header Image
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.05),
              image: DecorationImage(
                image: NetworkImage(loc.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(0.4), Colors.transparent],
                ),
              ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name and Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        loc.name,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    _buildStatusChip(loc.status, AppColors.success),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Address & Directions
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.location_on_rounded, color: AppColors.error),
                  title: Text(loc.address),
                  subtitle: Text(loc.distance, style: const TextStyle(color: AppColors.textSecondary)),
                  trailing: ElevatedButton.icon(
                    onPressed: () async {
                      final lat = loc.latitude;
                      final lng = loc.longitude;
                      final googleMapsUrl = Uri.parse("google.navigation:q=$lat,$lng");
                      final appleMapsUrl = Uri.parse("https://maps.apple.com/?q=$lat,$lng");
                      final browserUrl = Uri.parse("https://www.google.com/maps/search/?api=1&query=$lat,$lng");

                      if (await canLaunchUrl(googleMapsUrl)) {
                        await launchUrl(googleMapsUrl);
                      } else if (await canLaunchUrl(appleMapsUrl)) {
                        await launchUrl(appleMapsUrl);
                      } else {
                        await launchUrl(browserUrl, mode: LaunchMode.externalApplication);
                      }
                    },
                    icon: const Icon(Icons.directions_rounded),
                    label: const Text("Go"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const Divider(height: 48, color: AppColors.divider),
                
                // Services Offered
                const Text(
                  "Services Offered",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 16),
                ...loc.services.map((service) => _buildServiceItem(Icons.check_circle_outline_rounded, service)),
                
                const Divider(height: 48, color: AppColors.divider),
                
                // Operating Hours
                const Text(
                  "Operating Hours",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 16),
                ...loc.hours.entries.map((entry) => _buildHourItem(entry.key.toUpperCase(), entry.value)),
                
                const SizedBox(height: 32),
                
                // Contact Information
                if (loc.phone != null) ...[
                  OutlinedButton.icon(
                    onPressed: () async {
                      final url = Uri.parse("tel:${loc.phone}");
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      }
                    },
                    icon: const Icon(Icons.phone_rounded),
                    label: Text("Call ${loc.phone}"),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 56),
                      side: const BorderSide(color: AppColors.primary),
                      foregroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                
                // Report Issue Button
                Center(
                  child: TextButton.icon(
                    onPressed: () {
                      GoRouter.of(context).push('/report/${loc.id}/${loc.name}');
                    },
                    icon: const Icon(Icons.report_problem_rounded, color: AppColors.warning),
                    label: const Text("Report an issue", style: TextStyle(color: AppColors.warning)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        status,
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }

  Widget _buildServiceItem(IconData icon, String serviceName) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary.withOpacity(0.7)),
          const SizedBox(width: 16),
          Expanded(child: Text(serviceName, style: const TextStyle(fontSize: 16, color: AppColors.textPrimary))),
        ],
      ),
    );
  }

  Widget _buildHourItem(String day, String hours) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(day, style: const TextStyle(fontSize: 16, color: AppColors.textSecondary)),
          Text(hours, style: const TextStyle(fontSize: 16, color: AppColors.primary, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
