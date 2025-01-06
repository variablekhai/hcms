import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:moon_design/moon_design.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Booking App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: EditBookingScreen(bookingId: '', houseId: ''),
    );
  }
}

class EditBookingScreen extends StatefulWidget {
  final String bookingId;
  final String houseId;

  EditBookingScreen({super.key, required this.bookingId, required this.houseId});

  @override
  _EditBookingScreenState createState() => _EditBookingScreenState();
}

class _EditBookingScreenState extends State<EditBookingScreen> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _wageController = TextEditingController();
  final TextEditingController _requirementsController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _selectedHouseId = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBookingDetails();
  }

  Future<void> _loadBookingDetails() async {
    final DocumentSnapshot bookingSnapshot = await FirebaseFirestore.instance
        .collection('bookings')
        .doc(widget.bookingId)
        .get();

    final bookingData = bookingSnapshot.data() as Map<String, dynamic>;

    setState(() {
      _dateController.text = DateFormat('yyyy-MM-dd').format((bookingData['booking_datetime'] as Timestamp).toDate());
      _timeController.text = DateFormat('h:mm a').format((bookingData['booking_datetime'] as Timestamp).toDate());
      _durationController.text = bookingData['booking_duration'].toString();
      _wageController.text = bookingData['booking_total_cost'].toString();
      _requirementsController.text = bookingData['booking_requirements'];
      _selectedHouseId = (bookingData['house_id'] as DocumentReference).id;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    _durationController.dispose();
    _wageController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final String date = _dateController.text;
      final String time = _timeController.text;
      final String duration = _durationController.text;
      final String wage = _wageController.text;
      final String houseId = _selectedHouseId;

      final dateTimeString = '$date $time';
      final dateTime = DateFormat('yyyy-MM-dd h:mm a').parse(dateTimeString);

      FirebaseFirestore.instance.collection('bookings').doc(widget.bookingId).update({
        'booking_datetime': Timestamp.fromDate(dateTime),
        'booking_total_cost': double.parse(wage),
        'booking_duration': int.parse(duration),
        'booking_requirements': _requirementsController.text,
        'house_id': FirebaseFirestore.instance.collection('houses').doc(houseId),
      }).then((_) {
        Navigator.of(context).pop();
        MoonToast.show(context,
            backgroundColor: Colors.green[50],
            leading: Icon(
              MoonIcons.time_calendar_success_24_regular,
              color: Colors.green[700],
            ),
            label: Text(
              'Booking successfully updated',
              style: TextStyle(color: Colors.green[700]),
            ));
      }).catchError((error) {
        MoonToast.show(context,
            backgroundColor: Colors.red[50],
            leading: Icon(
              MoonIcons.time_calendar_success_24_regular,
              color: Colors.red[700],
            ),
            label: Text(
              'Failed to update booking: $error',
              style: TextStyle(color: Colors.red[700]),
            ));
      });
    }
  }

  void _onHouseSelected(String houseId) {
    setState(() {
      _selectedHouseId = houseId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(MoonIcons.arrows_left_24_regular),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          const Text(
                            'Back',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Update Booking',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Please fill in all details of your booking',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 28),
                      const Text(
                        'Select House',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 12),
                      HouseCarousel(onHouseSelected: _onHouseSelected, houseId: _selectedHouseId),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: MoonFormTextInput(
                              controller: _dateController,
                              validator: (String? value) =>
                                  value != null && value.isEmpty
                                      ? 'Please choose a date'
                                      : null,
                              leading: const Icon(MoonIcons.time_calendar_date_24_regular),
                              hintText: 'Select Date',
                              textInputSize: MoonTextInputSize.lg,
                              keyboardType: TextInputType.datetime,
                              onTap: () async {
                                FocusScope.of(context).requestFocus(FocusNode());
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2101),
                                );
                                if (pickedDate != null) {
                                  setState(() {
                                    _dateController.text = "${pickedDate.toLocal()}".split(' ')[0];
                                  });
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: MoonFormTextInput(
                              controller: _timeController,
                              validator: (String? value) =>
                                  value != null && value.isEmpty
                                      ? 'Please choose a time'
                                      : null,
                              leading: const Icon(MoonIcons.time_clock_24_regular),
                              hintText: 'Select Time',
                              textInputSize: MoonTextInputSize.lg,
                              keyboardType: TextInputType.datetime,
                              onTap: () async {
                                FocusScope.of(context).requestFocus(FocusNode());
                                TimeOfDay? pickedTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );
                                if (pickedTime != null) {
                                  setState(() {
                                    _timeController.text = pickedTime.format(context);
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      MoonTextArea(
                        height: 150,
                        hintText: 'Enter any special requirements...',
                        controller: _requirementsController,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: MoonFormTextInput(
                              controller: _durationController,
                              leading: const Icon(MoonIcons.time_clock_24_regular),
                              trailing: const Center(child: Text('hr(s)')),
                              hintText: 'Duration',
                              textInputSize: MoonTextInputSize.lg,
                              keyboardType: TextInputType.text,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: MoonFormTextInput(
                              controller: _wageController,
                              validator: (String? value) =>
                                  value != null && value.isEmpty
                                      ? 'Please enter wage'
                                      : null,
                              leading: const Center(child: Text('RM')),
                              hintText: 'Wage',
                              textInputSize: MoonTextInputSize.lg,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: MoonFilledButton(
                              buttonSize: MoonButtonSize.lg,
                              onTap: _submitForm,
                              label: const Text("Update Booking"),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

class HouseCarousel extends StatefulWidget {
  final Function(String) onHouseSelected;
  final String houseId;

  const HouseCarousel({super.key, required this.onHouseSelected, required this.houseId});

  @override
  State<HouseCarousel> createState() => _HouseCarouselState();
}

class _HouseCarouselState extends State<HouseCarousel> {
  int _selectedIndex = -1;
  List<Map<String, dynamic>> _houses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchHouses();
  }

  Future<void> fetchHouses() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('houses')
          .where('owner_id', isEqualTo: 'owneridtest')
          .get();

      final List<DocumentSnapshot> documents = snapshot.docs;

      setState(() {
        _houses = documents.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          return data;
        }).toList();
        _isLoading = false;

        _selectedIndex = _houses.indexWhere((house) => house['id'] == widget.houseId);
      });
    } catch (e) {
      setState(() {
        _houses = [];
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load houses: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _houses.isEmpty ? 100 : 200,
      child: OverflowBox(
        maxWidth: MediaQuery.of(context).size.width,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _houses.isEmpty
                ? const Center(child: Text('No houses available'))
                : MoonCarousel(
                    itemCount: _houses.length,
                    isCentered: false,
                    anchor: 0.05,
                    itemExtent: 200,
                    itemBuilder: (BuildContext context, int itemIndex, int _) {
                      final house = _houses[itemIndex];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedIndex = itemIndex;
                          });
                          widget.onHouseSelected(house['id']);
                        },
                        child: Stack(
                          children: [
                            Container(
                              decoration: ShapeDecoration(
                                color: context.moonColors!.goku,
                                shape: MoonSquircleBorder(
                                  borderRadius: BorderRadius.circular(12)
                                      .squircleBorderRadius(context),
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  house['house_picture'],
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 8,
                              left: 8,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  house['house_name'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            if (_selectedIndex == itemIndex)
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.black45.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.check_circle,
                                    color: Colors.white,
                                    size: 50,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
