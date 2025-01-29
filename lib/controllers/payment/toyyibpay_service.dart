import 'dart:convert';
import 'package:http/http.dart' as http;

class ToyyibPayService {
  final String apiKey =
      '1y7d1m73-9e3t-tl5d-0i2y-epv6q1zposog'; // Replace with your ToyyibPay secret key
  final String baseUrl = 'https://dev.toyyibpay.com/';

  Future<String?> createBill({
    required String billTitle,
    required String billDescription,
    required String billAmount,
    required String userEmail,
    required String userPhone,
    required String categoryCode,
    String returnUrl = 'https://yourapp.com/return',
    String callbackUrl = 'https://yourapp.com/callback',
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}index.php/api/createBill'),
        body: {
          'userSecretKey': apiKey,
          'categoryCode': categoryCode,
          'billName': billTitle,
          'billDescription': billDescription,
          'billPriceSetting': '1',
          'billPayorInfo': '1',
          'billAmount': billAmount,
          'billReturnUrl': returnUrl,
          'billCallbackUrl': callbackUrl,
          'billTo': userEmail,
          'billEmail': userEmail,
          'billPhone': userPhone,
          'billSplitPayment': '0',
          'billSplitPaymentArgs': '',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData is List && responseData.isNotEmpty) {
          return responseData[0]['BillCode']; // Return the generated bill code
        } else {
          throw Exception('Invalid response from ToyyibPay API');
        }
      } else {
        throw Exception('Failed to create bill: ${response.body}');
      }
    } catch (error) {
      throw Exception('Error creating bill: $error');
    }
  }
}
