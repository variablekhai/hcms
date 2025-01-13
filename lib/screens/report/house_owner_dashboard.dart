import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hcms/controllers/user_controller.dart';
import 'package:moon_design/moon_design.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

class HouseOwnerDashboard extends StatefulWidget {
  const HouseOwnerDashboard({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HouseOwnerDashboardState createState() => _HouseOwnerDashboardState();
}

Widget _buildHeader() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding:
            const EdgeInsets.only(left: 25, right: 25, top: 40, bottom: 25),
        child: Row(
          children: [
            const Text(
              'Hi, Khairul ',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 5),
            Image.asset(
              'assets/wave.png',
              height: 24,
              width: 24,
            ),
          ],
        ),
      ),
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Text(
          'Report Dashboard',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    ],
  );
}

class _HouseOwnerDashboardState extends State<HouseOwnerDashboard> {
  DateTime? _startDate;
  DateTime? _endDate;
  double _totalSpent = 0.0;
  int _totalBookings = 0;
  double _averageCleanerRating = 0.0;
  final TextEditingController _dateRangeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchTotalSpent();
    _fetchTotalBookings();
    _fetchAverageCleanerRating();
  }

  Future<void> _fetchTotalSpent() async {
    String? currentUserId = UserController().currentUser!.id;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('bookings')
        .where('owner_id', isEqualTo: currentUserId)
        .where('booking_status', isEqualTo: 'Completed')
        .get();

    double totalSpent = 0.0;
    for (var doc in snapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      DateTime bookingDate = (data['booking_datetime'] as Timestamp).toDate();
      if ((_startDate == null || bookingDate.isAfter(_startDate!)) &&
          (_endDate == null || bookingDate.isBefore(_endDate!))) {
        totalSpent += data['booking_total_cost'];
      }
    }

    setState(() {
      _totalSpent = totalSpent;
    });
  }

  Future<void> _fetchTotalBookings() async {
    String? currentUserId = UserController().currentUser!.id;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('bookings')
        .where('owner_id', isEqualTo: currentUserId)
        .where('booking_status', isEqualTo: 'Completed')
        .get();

    int totalBookings = snapshot.docs.length;
    setState(() {
      _totalBookings = totalBookings;
    });
  }

  Future<void> _fetchAverageCleanerRating() async {
    String? currentUserId = UserController().currentUser!.id;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('ratings')
        .where('owner_id', isEqualTo: currentUserId)
        .get();

    double totalRating = 0.0;
    int ratingCount = snapshot.docs.length;

    for (var doc in snapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      totalRating += data['rating_score'];
    }

    double averageRating = ratingCount > 0 ? totalRating / ratingCount : 0.0;

    setState(() {
      _averageCleanerRating = averageRating;
    });
  }

  Future<void> _exportReport() async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Text('Hello World'),
            );
          },
        ),
      );
      // Get the "Downloads" directory
      final directory =
          await getExternalStorageDirectory(); // Access external storage
      final downloadsPath =
          "${directory!.path}/Downloads"; // Adjust to use the 'Download' folder
      final file = File("$downloadsPath/house_owner_report.pdf");
      
      // Ensure the Downloads directory exists
      await Directory(downloadsPath).create(recursive: true);
      await file.writeAsBytes(await pdf.save());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Report exported!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to export report: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Dashboard'),
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
            Row(
              children: [
                Expanded(
                  child: MoonFormTextInput(
                    controller: _dateRangeController,
                    validator: (String? value) => value != null && value.isEmpty
                        ? 'Please choose a date range'
                        : null,
                    leading:
                        const Icon(MoonIcons.time_calendar_date_24_regular),
                    hintText: 'Select Date Range',
                    textInputSize: MoonTextInputSize.lg,
                    keyboardType: TextInputType.datetime,
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      var _selectedDateRange = DateTimeRange(
                        start: _startDate ?? DateTime.now(),
                        end: _endDate ?? DateTime.now(),
                      );
                      DateTimeRange? pickedDateRange =
                          await showDateRangePicker(
                        context: context,
                        initialDateRange: _selectedDateRange,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDateRange != null) {
                        setState(() {
                          _selectedDateRange = pickedDateRange;
                          _dateRangeController.text =
                              "${"${pickedDateRange.start.toLocal()}".split(' ')[0]} - ${"${pickedDateRange.end.toLocal()}".split(' ')[0]}";
                        });
                        _fetchTotalSpent();
                      }
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            // Total Spent Card
            _DashboardCard(
              title: 'Total Spent (RM)',
              value: 'RM ${_totalSpent.toStringAsFixed(2)}',
              subtitle: 'For selected period',
            ),
            const SizedBox(height: 16),

            // Total Bookings Card
            _DashboardCard(
              title: 'Total Bookings',
              value: _totalBookings != 0 ? _totalBookings.toString() : '0',
              subtitle: 'Cleaning sessions',
              icon: Icons.event_available,
            ),
            const SizedBox(height: 16),

            // Average Cleaner Rating Card
            _DashboardCard(
              title: 'Average Cleaner Rating',
              icon: Icons.star,
              value: '${_averageCleanerRating.toStringAsFixed(1)}/5',
              subtitle: '',
              customChild: Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < _averageCleanerRating
                        ? Icons.star
                        : Icons.star_border,
                    color: Colors.orange,
                    size: 20,
                  );
                }),
              ),
            ),
            const SizedBox(height: 16),
            // Export Report Button
            Row(
              children: [
                Expanded(
                  child: MoonFilledButton(
                    buttonSize: MoonButtonSize.lg,
                    backgroundColor: const Color(0xFF9DC543),
                    onTap: () => {
                      _exportReport(),
                    },
                    label: const Text("Export Report"),
                  ),
                ),
              ],
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
    super.key,
    required this.title,
    this.value,
    this.subtitle,
    this.icon,
    this.customChild,
  });

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
