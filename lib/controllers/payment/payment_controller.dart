import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class PaymentController {
  PaymentController._();

  static final PaymentController instance = PaymentController._();

  Future<void> makePayment() async {
    try{
      String? paymentIntentClientSecret = await _createPaymentIntent(
      1000, 
      'usd');
      if(paymentIntentClientSecret == null) return;
      await Stripe.instance.initPaymentSheet(paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntentClientSecret,
        merchantDisplayName: 'Flutter Stripe Store',
      ));
      await _processPayment();
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
      var response = await dio.post('https://api.stripe.com/v1/payment_intents', 
      data: data,
      options: Options(contentType: Headers.formUrlEncodedContentType,
      headers: {
        "Authorization": "Bearer sk_test_51QBuXtEbdf93ZSBciFRPV4aY6xdznQXK4eAXkX2l2TkTJzgKAl9kHa4uqZXryS758qhp9LWn108S8L7wr0kvijOF005xq1R14v",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      ),
      );
      if(response.data != null){
        return response.data['client_secret'];
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<void> _processPayment() async {
    try {
      await Stripe.instance.presentPaymentSheet();
    } catch (e) {
      print(e);
    }
  }

  
}