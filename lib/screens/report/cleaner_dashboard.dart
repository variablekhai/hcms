import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hcms/controllers/user_controller.dart';
import 'package:moon_design/moon_design.dart';

class CleanerDashboard extends StatefulWidget {
  const CleanerDashboard({Key? key}) : super(key: key);

  @override
  _CleanerDashboardState createState() => _CleanerDashboardState();
}

class _CleanerDashboardState extends State<CleanerDashboard> {
  final TextEditingController _dateRangeController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  double _totalEarnings = 0.0;
  int _totalJobs = 0;
  double _averageCleanerRating = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchTotalEarnings();
    _fetchTotalJobs();
    _fetchAverageCleanerRating();
    _fetchRecentReviews();
  }

  Future<void> _fetchTotalEarnings() async {
    String? currentUserId = UserController().currentUser!.id;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('bookings')
        .where('cleaner_id', isEqualTo: currentUserId)
        .where('booking_status', isEqualTo: 'Completed')
        .get();

    double totalEarnings = 0.0;
    for (var doc in snapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      DateTime bookingDate = (data['booking_datetime'] as Timestamp).toDate();
      if ((_startDate == null || bookingDate.isAfter(_startDate!)) &&
          (_endDate == null || bookingDate.isBefore(_endDate!))) {
        totalEarnings += data['booking_total_cost'];
      }
    }

    setState(() {
      _totalEarnings = totalEarnings;
    });
  }

  Future<void> _fetchTotalJobs() async {
    String? currentUserId = UserController().currentUser!.id;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('bookings')
        .where('cleaner_id', isEqualTo: currentUserId)
        .where('booking_status', isEqualTo: 'Completed')
        .get();

    int totalJobs = snapshot.docs.length;
    setState(() {
      _totalJobs = totalJobs;
    });
  }

  Future<void> _fetchAverageCleanerRating() async {
    String? currentUserId = UserController().currentUser!.id;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('ratings')
        .where('cleaner_id', isEqualTo: currentUserId)
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

  Future<List<Map<String, dynamic>>> _fetchRecentReviews() async {
    String? currentUserId = UserController().currentUser!.id;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('ratings')
        .where('cleaner_id', isEqualTo: currentUserId)
        .orderBy('rating_date', descending: true)
        .limit(3)
        .get();

    List<Map<String, dynamic>> reviews = [];
    for (var doc in snapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      reviews.add({
        'review': data['rating_review'],
        'timestamp': data['timestamp'],
      });
    }

    return reviews;
  }

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
                      var selectedDateRange = DateTimeRange(
                        start: _startDate ?? DateTime.now(),
                        end: _endDate ?? DateTime.now(),
                      );
                      DateTimeRange? pickedDateRange =
                          await showDateRangePicker(
                        context: context,
                        initialDateRange: selectedDateRange,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDateRange != null) {
                        setState(() {
                          selectedDateRange = pickedDateRange;
                          _dateRangeController.text =
                              "${"${pickedDateRange.start.toLocal()}".split(' ')[0]} - ${"${pickedDateRange.end.toLocal()}".split(' ')[0]}";
                        });
                        _fetchTotalEarnings();
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Total Earnings Card
            _DashboardCard(
              title: 'Total Earnings (RM)',
              value: 'RM ${_totalEarnings.toStringAsFixed(2)}',
              subtitle: 'For selected period',
            ),
            const SizedBox(height: 16),

            // Completed Jobs Card
            _DashboardCard(
              title: 'Completed Jobs',
              value: _totalJobs != 0 ? '$_totalJobs' : '0',
              subtitle: 'Jobs completed',
              icon: Icons.check_circle_outline,
            ),
            const SizedBox(height: 16),

            // Average Rating Card
            _DashboardCard(
              title: 'Average Rating',
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
            // Recent Reviews Card
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchRecentReviews(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Center(child: const CircularProgressIndicator()),
                  );
                } else if (snapshot.hasError) {
                  return const Text('Error loading reviews');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No reviews available');
                } else {
                  List<Map<String, dynamic>> reviews = snapshot.data!;
                  return _DashboardCard(
                    title: 'Recent Reviews',
                    customChild: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: reviews.map((review) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Review: "${review['review']}"',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 16),
            // Export Report Button
            Row(
              children: [
                Expanded(
                  child: MoonFilledButton(
                    buttonSize: MoonButtonSize.lg,
                    backgroundColor: const Color(0xFF9DC543),
                    onTap: () => {},
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
