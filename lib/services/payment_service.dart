class PaymentService {
  Future<bool> makePayment(double amount) async {
    // ignore: avoid_print
    print("Processing payment of ₹$amount...");
    await Future.delayed(const Duration(seconds: 1));

    return true; // success
  }

  Future<String> getTransactionStatus(String txnId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return "Transaction $txnId completed";
  }
}
