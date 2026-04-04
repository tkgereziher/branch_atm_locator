import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class DetailsScreen extends StatelessWidget {
  final String id;

  const DetailsScreen({super.key, required this.id});

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
          IconButton(
            icon: const Icon(Icons.favorite_border_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Image Placeholder
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                image: const DecorationImage(
                  image: NetworkImage('https://via.placeholder.com/600x400'), // Placeholder for real image
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
                          "CBE - Main Branch",
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      _buildStatusChip("Open Now", AppColors.success),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Address & Directions
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.location_on_rounded, color: AppColors.error),
                    title: const Text(" Churchill Avenue, Addis Ababa, Ethiopia"),
                    subtitle: const Text("1.2 km away", style: TextStyle(color: AppColors.textSecondary)),
                    trailing: ElevatedButton.icon(
                      onPressed: () {},
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
                  _buildServiceItem(Icons.account_balance_wallet_rounded, "Cash Withdrawal & Deposit"),
                  _buildServiceItem(Icons.monetization_on_rounded, "Foreign Currency Exchange"),
                  _buildServiceItem(Icons.credit_card_rounded, "Card Issuance"),
                  _buildServiceItem(Icons.support_agent_rounded, "Loan & Mortgages Advisory"),
                  
                  const Divider(height: 48, color: AppColors.divider),
                  
                  // Operating Hours
                  const Text(
                    "Operating Hours",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 16),
                  _buildHourItem("Monday - Friday", "8:00 AM - 6:00 PM"),
                  _buildHourItem("Saturday", "8:00 AM - 12:00 PM"),
                  _buildHourItem("Sunday", "Closed"),
                  
                  const SizedBox(height: 32),
                  
                  // Contact Information
                  OutlinedButton.icon(
                     onPressed: () {},
                     icon: const Icon(Icons.phone_rounded),
                     label: const Text("Call Branch"),
                     style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 56),
                      side: const BorderSide(color: AppColors.primary),
                      foregroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                     ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Report Issue Button
                  Center(
                    child: TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.report_problem_rounded, color: AppColors.warning),
                      label: const Text("Report an issue", style: TextStyle(color: AppColors.warning)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
