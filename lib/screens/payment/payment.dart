import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentPage extends StatefulWidget {
  final String billCode;

  const PaymentPage({Key? key, required this.billCode}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            // You can show a loading indicator here if needed
            debugPrint('WebView is loading (progress: $progress%)');
          },
          onPageStarted: (url) {
            debugPrint('Page started loading: $url');
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (url) {
            debugPrint('Page finished loading: $url');
            setState(() {
              _isLoading = false;
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            debugPrint('Navigating to: ${request.url}');
            final uri = Uri.parse(request.url);

            // Intercept the redirect URLs
            if (request.url.contains('payment-success')) {
              final status = uri.queryParameters['status_id'];

              if (status == '1') {
                // Payment successful
                Navigator.pop(context); // Close the WebView
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentSuccessScreen(),
                  ),
                );
                return NavigationDecision
                    .prevent; // Prevent loading the URL in the WebView
              } else if (status == '3') {
                // Payment failed
                Navigator.pop(context); // Close the WebView
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentFailureScreen(),
                  ),
                );
                return NavigationDecision
                    .prevent; // Prevent loading the URL in the WebView
              }
            } else if (request.url.contains('payment-failure')) {
              // Payment failed
              Navigator.pop(context); // Close the WebView
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentFailureScreen(),
                ),
              );
              return NavigationDecision
                  .prevent; // Prevent loading the URL in the WebView
            }

            return NavigationDecision.navigate; // Allow other URLs to load
          },
        ),
      )
      ..loadRequest(Uri.parse('https://dev.toyyibpay.com/${widget.billCode}'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}

class PaymentSuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Successful'),
      ),
      body: Center(
        child: Text('Thank you! Your payment was successful.'),
      ),
    );
  }
}

class PaymentFailureScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Failed'),
      ),
      body: Center(
        child: Text('Payment failed. Please try again.'),
      ),
    );
  }
}
