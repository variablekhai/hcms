import 'package:flutter/material.dart';

class CleanerDashboard extends StatelessWidget {
  const CleanerDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cleaner Dashboard'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Date Range Selector
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Jan 01, 2024 - Oct 27, 2024',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  Icon(Icons.calendar_today, color: Colors.black),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Total Earnings Card
            _DashboardCard(
              title: 'Total Earnings (RM)',
              value: 'RM 3,450.00',
              subtitle: 'For selected period',
            ),
            const SizedBox(height: 16),

            // Completed Jobs Card
            _DashboardCard(
              title: 'Completed Jobs',
              value: '29',
              subtitle: 'Jobs completed',
              icon: Icons.check_circle_outline,
            ),
            const SizedBox(height: 16),

            // Average Rating Card
            _DashboardCard(
              title: 'Average Rating',
              value: '4.9/5',
              subtitle: '',
              customChild: Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < 4
                        ? Icons.star
                        : Icons.star_half, // Half star for 4.9 rating
                    color: Colors.orange,
                    size: 20,
                  );
                }),
              ),
            ),
            const SizedBox(height: 16),

            // Recent Reviews Card
            _DashboardCard(
              title: 'Recent Reviews',
              customChild: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Review 1: "Great work!"'),
                  SizedBox(height: 8),
                  Text('Review 2: "Very professional!"'),
                  SizedBox(height: 8),
                  Text('Review 3: "Highly recommended!"'),
                ],
              ),
            ),
            const Spacer(),

            // Export Report Button
            ElevatedButton.icon(
              onPressed: () {
                // Implement export report functionality
              },
              icon: const Icon(Icons.file_download),
              label: const Text('Export Report'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Widget for Dashboard Cards
class _DashboardCard extends StatelessWidget {
  final String title;
  final String? value;
  final String? subtitle;
  final IconData? icon;
  final Widget? customChild;

  const _DashboardCard({
    Key? key,
    required this.title,
    this.value,
    this.subtitle,
    this.icon,
    this.customChild,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) Icon(icon, color: Colors.grey.shade700),
              if (icon != null) const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          if (value != null) ...[
            const SizedBox(height: 8),
            Text(
              value!,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
          if (customChild != null) ...[
            const SizedBox(height: 8),
            customChild!,
          ],
        ],
      ),
    );
  }
}
