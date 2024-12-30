import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';

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
      home: AddBookingScreen(),
    );
  }
}

class AddBookingScreen extends StatefulWidget {
  AddBookingScreen({super.key});

  @override
  _AddBookingScreenState createState() => _AddBookingScreenState();
}

class _AddBookingScreenState extends State<AddBookingScreen> {
  final TextEditingController _textController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Perform the booking creation logic here
      MoonToast.show(context,
          backgroundColor: Colors.green[50],
          leading: Icon(
            MoonIcons.time_calendar_success_24_regular,
            color: Colors.green[700],
          ),
          label: Text(
            'Booking successfully created',
            style: TextStyle(color: Colors.green[700]),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    var _currentPage = 0;
    return Scaffold(
        body: Padding(
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
                    'Add Booking',
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
                  const HouseCarousel(),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: MoonFormTextInput(
                          controller: _textController,
                          validator: (String? value) =>
                              value != null && value.isEmpty
                                  ? 'Please choose a date'
                                  : null,
                          leading: const Icon(
                              MoonIcons.time_calendar_date_24_regular),
                          hintText: 'Select Date',
                          textInputSize: MoonTextInputSize.lg,
                          keyboardType: TextInputType.datetime,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: MoonFormTextInput(
                          controller: _textController,
                          validator: (String? value) =>
                              value != null && value.isEmpty
                                  ? 'Please choose a time'
                                  : null,
                          leading: const Icon(MoonIcons.time_clock_24_regular),
                          hintText: 'Select Time',
                          textInputSize: MoonTextInputSize.lg,
                          keyboardType: TextInputType.datetime,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const MoonTextArea(
                    height: 150,
                    hintText: 'Enter any special requirements...',
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: MoonFormTextInput(
                          controller: _textController,
                          leading: const Icon(MoonIcons.time_clock_24_regular),
                          hintText: 'Duration',
                          textInputSize: MoonTextInputSize.lg,
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: MoonFormTextInput(
                          controller: _textController,
                          validator: (String? value) =>
                              value != null && value.isEmpty
                                  ? 'Please enter wage'
                                  : null,
                          leading: const Center(child: Text('RM')),
                          hintText: 'Wage',
                          textInputSize: MoonTextInputSize.lg,
                          keyboardType: TextInputType.number,
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
                          label: const Text("Create Booking"),
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
  const HouseCarousel({super.key});

  @override
  State<HouseCarousel> createState() => _HouseCarouselState();
}

class _HouseCarouselState extends State<HouseCarousel> {
  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: OverflowBox(
        maxWidth: MediaQuery.of(context).size.width,
        child: MoonCarousel(
          itemCount: 10,
          isCentered: false,
          anchor: 0.05,
          itemExtent: 200,
          itemBuilder: (BuildContext context, int itemIndex, int _) =>
              GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = itemIndex;
              });
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
                    child: Image.asset(
                      'barefoot-villa.jpg',
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
                    child: const Text(
                      'House Name',
                      style: TextStyle(
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
          ),
        ),
      ),
    );
  }
}
