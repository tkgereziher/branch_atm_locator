import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/di/injection_container.dart';
import '../../../data/models/report_model.dart';
import '../../../data/services/report_service.dart';

class ReportIssueScreen extends StatefulWidget {
  final String locationId;
  final String locationName;

  const ReportIssueScreen({
    super.key,
    required this.locationId,
    required this.locationName,
  });

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  String? _selectedIssue;
  bool _isSubmitting = false;
  final TextEditingController _detailsController = TextEditingController();

  final List<String> _issueTypes = [
    "ATM out of cash",
    "Branch closed during hours",
    "Machine not working",
    "Incorrect location",
    "Facility issue",
    "Other",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Report an Issue", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Reporting for:",
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              widget.locationName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary),
            ),
            const SizedBox(height: 32),
            
            const Text(
              "What is the problem?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 16),
            
            // Issue Type Selection
            ..._issueTypes.map((issue) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _selectedIssue == issue ? AppColors.primary : Colors.transparent,
                  width: 2,
                ),
              ),
              child: RadioListTile<String>(
                title: Text(issue, style: const TextStyle(fontWeight: FontWeight.w500)),
                value: issue,
                groupValue: _selectedIssue,
                onChanged: (val) => setState(() => _selectedIssue = val),
                activeColor: AppColors.primary,
                controlAffinity: ListTileControlAffinity.trailing,
              ),
            )),
            
            const SizedBox(height: 24),
            const Text(
              "Additional Details",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _detailsController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Please describe the issue in detail (optional)...",
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 40),
            
            // Submit Button
            ElevatedButton(
              onPressed: (_selectedIssue == null || _isSubmitting) ? null : _submitReport,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: _isSubmitting
                ? const SizedBox(
                    height: 24, width: 24,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                : const Text("Submit Report", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    ),
  );
}

Future<void> _submitReport() async {
  setState(() => _isSubmitting = true);
  try {
    final report = ReportModel(
      locationId: widget.locationId,
      locationName: widget.locationName,
      issueType: _selectedIssue!,
      details: _detailsController.text.trim().isEmpty ? null : _detailsController.text.trim(),
      createdAt: DateTime.now().toIso8601String(),
    );
    await sl<ReportService>().submitReport(report);
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Report Submitted"),
          content: const Text("Thank you for your feedback. We will investigate this issue immediately."),
          actions: [
            TextButton(
              onPressed: () { context.pop(); context.pop(); },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to submit report. Please try again.')),
      );
    }
  } finally {
    if (mounted) setState(() => _isSubmitting = false);
  }
}
}
