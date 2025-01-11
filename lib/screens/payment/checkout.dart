import 'package:flutter/material.dart';
import 'package:hcms/controllers/payment/payment_controller.dart';
import 'package:hcms/screens/auth/login.dart';
import 'package:hcms/screens/booking/edit_booking.dart';
import 'package:moon_design/moon_design.dart';

class Checkout extends StatelessWidget {
  const Checkout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
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
              const SizedBox(height: 16),
              const Text(
                'Booking Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey.shade200,
                            image: const DecorationImage(
                              image: AssetImage('barefoot-villa.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.deepPurple,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Waiting for Payment',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.home, color: Colors.grey),
                              SizedBox(width: 8),
                              Text('House: John Doe',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black)),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: const [
                              Icon(Icons.calendar_today, color: Colors.grey),
                              SizedBox(width: 8),
                              Text('Date: 25th Dec 2024',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black)),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: const [
                              Icon(Icons.access_time, color: Colors.grey),
                              SizedBox(width: 8),
                              Text('Time: 2:00 PM',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black)),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: const [
                              Icon(Icons.location_on, color: Colors.grey),
                              SizedBox(width: 8),
                              Text('Location: XYZ Street',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black)),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: const [
                              Icon(Icons.phone, color: Colors.grey),
                              SizedBox(width: 8),
                              Text('Contact: +1234567890',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black)),
                            ],
                          ),
                          SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Total : RM120',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: MoonFilledButton(
                      buttonSize: MoonButtonSize.lg,
                      onTap: () {
                        PaymentController.instance.makePayment();
                      },
                      label: const Text("Make Payment"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
