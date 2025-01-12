import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hcms/screens/booking/booking_list.dart';
import 'package:hcms/widgets/bottomNavigationMenu.dart';

class PaymentController {
  PaymentController._();

  static final PaymentController instance = PaymentController._();

  Future<void> makePayment(
      BuildContext context, double amount, String bookingId) async {
    try {
      String? paymentIntentClientSecret =
          await _createPaymentIntent(calculateAmount(amount), 'myr');
      if (paymentIntentClientSecret == null) return;
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntentClientSecret,
        merchantDisplayName: 'Flutter Stripe Store',
      ));
      await _processPayment(context, bookingId, amount);
    } catch (e) {
      print(e);
    }
  }

  Future<String?> _createPaymentIntent(int amount, String currency) async {
    try {
      // Add your payment intent logic here
      final Dio dio = Dio();
      Map<String, dynamic> data = {
        'amount': amount,
        'currency': currency,
      };
      var response = await dio.post(
        'https://api.stripe.com/v1/payment_intents',
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            "Authorization":
                "Bearer sk_test_51QBuXtEbdf93ZSBciFRPV4aY6xdznQXK4eAXkX2l2TkTJzgKAl9kHa4uqZXryS758qhp9LWn108S8L7wr0kvijOF005xq1R14v",
            "Content-Type": "application/x-www-form-urlencoded"
          },
        ),
      );
      if (response.data != null) {
        return response.data['client_secret'];
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<void> _processPayment(
      BuildContext context, String bookingId, double amount) async {
    try {
      await Stripe.instance.presentPaymentSheet();
      navDone(context);
      updateBookingStatus(context, bookingId);
      addPaymentDetails(context, bookingId, amount);
    } catch (e) {
      if (e is StripeException) {
        print('StripeException: ${e.error.localizedMessage}');
      } else {
        print('Error: $e');
      }
    }
  }

  calculateAmount(double amount) {
    final calculatedAmount = amount.round() * 100;
    return calculatedAmount;
  }

  void navDone(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BottomNavigationMenu(),
      ),
    );
  }

  void updateBookingStatus(BuildContext context, String bookingId) {
    Map<String, dynamic> updatedStatus = {
      'booking_status': 'Completed',
    };
    FirebaseFirestore.instance
        .collection('bookings')
        .doc(bookingId)
        .update(updatedStatus)
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking payment completed!')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update payment: $error')),
      );
    });
  }

  void addPaymentDetails(
      BuildContext context, String bookingId, double amount) {
    Map<String, dynamic> paymentDetails = {
      'booking_id': bookingId,
      'payment_amount': amount,
      'payment_method': 'Credit Card',
      'payment_date': DateTime.now(),
      'payment_status': 'Paid',
    };
    FirebaseFirestore.instance
        .collection('payment')
        .add(paymentDetails)
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment details added!')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add payment details: $error')),
      );
    });
  }
}
