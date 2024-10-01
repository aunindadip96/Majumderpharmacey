import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../ModelClass/Payment_Model.dart';

class AdminMakePayment {
  // Method to make a payment
  Future<void> makePayment(Payment payment) async {
    final url = Uri.parse("https://pharmacy.symbexbd.com/api/make_payment");
    EasyLoading.show(status: "Processing Payment...");

    try {
      final response = await http.post(
        url,
        headers: {"Content-type": "application/json"},
        body: jsonEncode(payment.toJson()), // Convert Payment model to JSON
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Response Body: ${response.body}'); // Print the response body
        EasyLoading.showSuccess("Payment Processed Successfully");

        Future.delayed(const Duration(seconds: 2), () {
          EasyLoading.dismiss();
        });
      } else {
        print('Error Response: ${response.body}'); // Print error response
        EasyLoading.showError("Failed to process payment");
        EasyLoading.dismiss();
      }
    } catch (e) {
      print('Exception: $e'); // Print the exception message
      EasyLoading.showError("Something Went Wrong");
      EasyLoading.dismiss();
    }
  }
}
