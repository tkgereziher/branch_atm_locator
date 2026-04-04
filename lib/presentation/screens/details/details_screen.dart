import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  final String id;

  const DetailsScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Location Details"),
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
              color: Colors.grey[200],
              child: Icon(Icons.image_outlined, size: 64, color: Colors.grey[400]),
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
                      Text(
                        "CBE - Main Branch",
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      _buildStatusChip("Open Now"),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Address & Directions
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.location_on_rounded, color: Colors.red),
                    title: const Text(" Churchill Avenue, Addis Ababa, Ethiopia"),
                    subtitle: const Text("1.2 km away"),
                    trailing: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.directions_rounded),
                      label: const Text("Go"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[600],
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const Divider(height: 48),
                  
                  // Services Offered
                  Text(
                    "Services Offered",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildServiceItem(Icons.account_balance_wallet_rounded, "Cash Withdrawal & Deposit"),
                  _buildServiceItem(Icons.monetization_on_rounded, "Foreign Currency Exchange"),
                  _buildServiceItem(Icons.credit_card_rounded, "Card Issuance"),
                  _buildServiceItem(Icons.support_agent_rounded, "Loan & Mortgages Advisory"),
                  
                  const Divider(height: 48),
                  
                  // Operating Hours
                  Text(
                    "Operating Hours",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildHourItem("Monday - Friday", "8:00 AM - 6:00 PM"),
                  _buildHourItem("Saturday", "8:00 AM - 12:00 PM"),
                  _buildHourItem("Sunday", "Closed"),
                  
                  const SizedBox(height: 24),
                  
                  // Contact Information
                  OutlinedButton.icon(
                     onPressed: () {},
                     icon: const Icon(Icons.phone_rounded),
                     label: const Text("Call Branch"),
                     style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                     ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Report Issue Button
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.report_problem_rounded, color: Colors.orange),
                    label: const Text("Report an issue", style: TextStyle(color: Colors.orange)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: Text(
        status,
        style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }

  Widget _buildServiceItem(IconData icon, String serviceName) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 16),
          Expanded(child: Text(serviceName, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  Widget _buildHourItem(String day, String hours) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(day, style: const TextStyle(fontSize: 16)),
          Text(hours, style: TextStyle(fontSize: 16, color: Colors.blue[800], fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
