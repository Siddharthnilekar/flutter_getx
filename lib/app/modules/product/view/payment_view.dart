import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:getx_chapter_1/app/modules/product/controllers/cart_controller.dart';
import 'package:getx_chapter_1/app/modules/product/controllers/checkout_controller.dart';

class PaymentView extends StatelessWidget {
  final CheckoutController checkoutController = Get.find<CheckoutController>();
  final CartController cartController = Get.find<CartController>();
  final RxString localPaymentStatus = ''.obs;
  final RxString qrTimer = '6:47'.obs;
  Timer? _timer;

  PaymentView({super.key}) {
    _startQrTimer();
  }

  void _startQrTimer() {
    const initialSeconds = 6 * 60 + 47;
    int remainingSeconds = initialSeconds;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        remainingSeconds--;
        final minutes = remainingSeconds ~/ 60;
        final seconds = remainingSeconds % 60;
        qrTimer.value = '$minutes:${seconds.toString().padLeft(2, '0')}';
      } else {
        timer.cancel();
        qrTimer.value = '0:00';
      }
    });
  }

  String? _validateCardNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter card number'.tr;
    }
    final cleanValue = value.replaceAll(RegExp(r'\D'), '');
    if (cleanValue.length != 16) {
      return 'Card number must be 16 digits'.tr;
    }
    return null;
  }

  String? _validateExpiryDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter expiry date'.tr;
    }
    final RegExp expiryRegExp = RegExp(r'^(0[1-9]|1[0-2])\/[0-9]{2}$');
    if (!expiryRegExp.hasMatch(value)) {
      return 'Invalid expiry date format'.tr;
    }
    final parts = value.split('/');
    final month = int.parse(parts[0]);
    final year = int.parse('20${parts[1]}');
    final now = DateTime.now();
    final expiry = DateTime(year, month + 1);
    if (expiry.isBefore(now)) {
      return 'Card is expired'.tr;
    }
    return null;
  }

  String? _validateCvv(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter cvv'.tr;
    }
    if (value.length != 3) {
      return 'cvv must be 3 digits'.tr;
    }
    return null;
  }

  void _selectPaymentMethod(String method) {
    checkoutController.selectedPaymentMethod.value = method;
    localPaymentStatus.value = '$method selected';
    checkoutController.selectedUpiOption.value = '';
    checkoutController.selectCard(null);
    checkoutController.selectedBank.value = '';
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textFieldContentColor = isDarkMode ? Colors.white70 : Colors.black87;
    final iconColor = isDarkMode ? Colors.white70 : Colors.black87;

    final Map<String, String> paymentIcons = {
      'Card': 'assets/images/credit_card.png',
      'UPI / QR': 'assets/images/bhim_upi.png',
      'Net Banking': 'assets/images/net_banking.png',
      'Wallet': 'assets/images/wallet.png',
    };
    final Map<String, Widget> paymentDescriptions = {
      'Card': Row(
        children: [
          Image.asset(
            'assets/images/all_card_logo.png',
            width: 80,
            height: 36,
            errorBuilder: (context, error, stackTrace) => Icon(
              Icons.error,
              color: Theme.of(context).colorScheme.primary,
              size: 36,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '& more'.tr,
            style: GoogleFonts.poppins(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              fontSize: 10,
            ),
          ),
        ],
      ),
      'UPI / QR': Row(
        children: [
          Image.asset(
            'assets/images/google_pay.png',
            width: 20,
            height: 36,
            errorBuilder: (context, error, stackTrace) => Icon(
              Icons.error,
              color: Theme.of(context).colorScheme.primary,
              size: 36,
            ),
          ),
          const SizedBox(width: 4),
          Image.asset(
            'assets/images/phonepe.png',
            width: 20,
            height: 36,
            errorBuilder: (context, error, stackTrace) => Icon(
              Icons.error,
              color: Theme.of(context).colorScheme.primary,
              size: 36,
            ),
          ),
          const SizedBox(width: 4),
          Image.asset(
            'assets/images/paytm.png',
            width: 20,
            height: 36,
            errorBuilder: (context, error, stackTrace) => Icon(
              Icons.error,
              color: Theme.of(context).colorScheme.primary,
              size: 36,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '& more'.tr,
            style: GoogleFonts.poppins(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              fontSize: 10,
            ),
          ),
        ],
      ),
      'Net Banking': Text(
        'All Indian Banks'.tr,
        style: GoogleFonts.poppins(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          fontSize: 10,
        ),
      ),
      'Wallet': Text(
        'Pay Using Wallet'.tr,
        style: GoogleFonts.poppins(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          fontSize: 10,
        ),
      ),
    };
    final List<String> paymentMethods = ['Card', 'UPI / QR', 'Net Banking', 'Wallet'];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'payment'.tr,
          style: GoogleFonts.poppins(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: isDarkMode ? 0 : 2,
        shadowColor: isDarkMode ? null : Colors.black26,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(8.0, 2.0, 8.0, 80.0),
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 4,
                    color: isDarkMode ? Colors.grey[800] : Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isDarkMode
                              ? [Colors.purple.shade700, Colors.purple.shade500]
                              : [const Color.fromARGB(255, 253, 253, 253), const Color.fromARGB(255, 238, 212, 243)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                const SizedBox(height: 1),
                                Image.asset(
                                  'assets/images/qr-code.png',
                                  width: 100,
                                  height: 100,
                                  errorBuilder: (context, error, stackTrace) => Icon(
                                    Icons.error,
                                    color: Theme.of(context).colorScheme.error,
                                    size: 150,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Scan the QR using any UPI'.tr,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.onSurface,
                                    ),
                                  ),
                                  Text(
                                    'app on your phone.'.tr,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Theme.of(context).colorScheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        'assets/images/google_pay.png',
                                        width: 32,
                                        height: 32,
                                        errorBuilder: (context, error, stackTrace) => Icon(
                                          Icons.error,
                                          color: Theme.of(context).colorScheme.primary,
                                          size: 32,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Image.asset(
                                        'assets/images/phonepe.png',
                                        width: 32,
                                        height: 32,
                                        errorBuilder: (context, error, stackTrace) => Icon(
                                          Icons.error,
                                          color: Theme.of(context).colorScheme.primary,
                                          size: 32,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Image.asset(
                                        'assets/images/paytm.png',
                                        width: 32,
                                        height: 32,
                                        errorBuilder: (context, error, stackTrace) => Icon(
                                          Icons.error,
                                          color: Theme.of(context).colorScheme.primary,
                                          size: 32,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Image.asset(
                                        'assets/images/bhim_upi.png',
                                        width: 32,
                                        height: 32,
                                        errorBuilder: (context, error, stackTrace) => Icon(
                                          Icons.error,
                                          color: Theme.of(context).colorScheme.primary,
                                          size: 32,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'QR Code is valid for'.tr,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Theme.of(context).colorScheme.onSurface,
                                    ),
                                  ),
                                  Text(
                                    qrTimer.value,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ).animate().fadeIn(duration: 500.ms, delay: 100.ms),
                  const SizedBox(height: 16),
                  Text(
                    'Cards, Upi & More'.tr,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ).animate().fadeIn(duration: 500.ms, delay: 400.ms),
                  const SizedBox(height: 8),
                  Card(
                    elevation: 4,
                    color: isDarkMode ? Colors.grey[800] : Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isDarkMode
                              ? [const Color.fromARGB(255, 187, 211, 208), const Color.fromARGB(255, 212, 231, 229)]
                              : [const Color.fromARGB(255, 241, 233, 244), const Color.fromARGB(255, 255, 255, 255)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                        child: Column(
                          children: paymentMethods.asMap().entries.map((entry) {
                            final method = entry.value;
                            return Column(
                              children: [
                                GestureDetector(
                                  onTap: () => _selectPaymentMethod(method),
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: checkoutController.selectedPaymentMethod.value == method
                                            ? Theme.of(context).colorScheme.primary
                                            : Colors.grey,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        paymentIcons[method] != null
                                            ? Image.asset(
                                                paymentIcons[method]!,
                                                width: 36,
                                                height: 36,
                                                errorBuilder: (context, error, stackTrace) => Icon(
                                                  Icons.error,
                                                  color: Theme.of(context).colorScheme.primary,
                                                  size: 36,
                                                ),
                                              )
                                            : Icon(
                                                Icons.error,
                                                color: Theme.of(context).colorScheme.primary,
                                                size: 36,
                                              ),
                                        const SizedBox(width: 24),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                method.tr,
                                                style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme.of(context).colorScheme.onSurface,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              paymentDescriptions[method] ?? const SizedBox.shrink(),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (entry.key < paymentMethods.length - 1) const SizedBox(height: 8),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ).animate().fadeIn(duration: 500.ms, delay: 500.ms),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: SafeArea(
              child: Center(
                child: AnimatedButton(
                  text: checkoutController.isPlacingOrder.value ? 'placing_order'.tr : 'place_order'.tr,
                  onPressed: checkoutController.isPlacingOrder.value ? null : () => checkoutController.placeOrder(),
                  icon: checkoutController.isPlacingOrder.value ? Icons.hourglass_empty : Icons.check_circle,
                  isDarkMode: isDarkMode,
                  isLoading: checkoutController.isPlacingOrder.value,
                  gradient: LinearGradient(
                    colors: isDarkMode
                        ? [Colors.blue.shade700, Colors.blue.shade400]
                        : [const Color.fromARGB(255, 178, 202, 240), const Color.fromARGB(255, 96, 160, 220)],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (newText.length > 2) {
      newText = '${newText.substring(0, 2)}/${newText.substring(2, newText.length)}';
    }
    if (newText.length > 5) {
      newText = newText.substring(0, 5);
    }
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

class AnimatedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isDarkMode;
  final bool isLoading;
  final Gradient? gradient;

  const AnimatedButton({
    required this.text,
    this.onPressed,
    this.icon,
    required this.isDarkMode,
    this.isLoading = false,
    this.gradient,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final RxBool isTapped = false.obs;

    return GestureDetector(
      onTapDown: onPressed != null && !isLoading ? (_) => isTapped.value = true : null,
      onTapUp: onPressed != null && !isLoading
          ? (_) {
              isTapped.value = false;
              onPressed!();
            }
          : null,
      onTapCancel: onPressed != null && !isLoading ? () => isTapped.value = false : null,
      child: Obx(
        () => AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.bounceOut,
          transform: Matrix4.identity()..scale((isTapped.value && !isLoading) ? 0.95 : 1.0),
          child: Container(
            decoration: BoxDecoration(
              gradient: gradient ??
                  LinearGradient(
                    colors: isDarkMode
                        ? [Colors.grey.shade700, Colors.grey.shade500]
                        : [Colors.grey.shade300, Colors.grey.shade100],
                  ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isLoading) ...[
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ] else if (icon != null) ...[
                    Icon(
                      icon,
                      color: Theme.of(context).colorScheme.onSurface,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

