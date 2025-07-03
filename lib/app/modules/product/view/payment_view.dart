import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:getx_chapter_1/app/modules/product/controllers/cart_controller.dart';
import 'package:getx_chapter_1/app/modules/product/controllers/checkout_controller.dart';

class PaymentView extends StatelessWidget {
  final CheckoutController checkoutController = Get.find<CheckoutController>();
  final CartController cartController = Get.find<CartController>();

  PaymentView({super.key});

  // Validation functions
  String? _validateCardNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'please_enter_card_number'.tr;
    }
    final cleanValue = value.replaceAll(RegExp(r'\D'), '');
    if (cleanValue.length != 16) {
      return 'card_number_must_be_16_digits'.tr;
    }
    return null;
  }

  String? _validateExpiryDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'please_enter_expiry_date'.tr;
    }
    final RegExp expiryRegExp = RegExp(r'^(0[1-9]|1[0-2])\/[0-9]{2}$');
    if (!expiryRegExp.hasMatch(value)) {
      return 'invalid_expiry_date_format'.tr;
    }
    final parts = value.split('/');
    final month = int.parse(parts[0]);
    final year = int.parse('20${parts[1]}');
    final now = DateTime.now();
    final expiry = DateTime(year, month + 1);
    if (expiry.isBefore(now)) {
      return 'card_is_expired'.tr;
    }
    return null;
  }

  String? _validateCvv(String? value) {
    if (value == null || value.isEmpty) {
      return 'please_enter_cvv'.tr;
    }
    if (value.length != 3) {
      return 'cvv_must_be_3_digits'.tr;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textFieldContentColor = isDarkMode ? Colors.white70 : Colors.black87;
    final iconColor = isDarkMode ? Colors.white70 : Colors.black87;
    final radioColor = isDarkMode ? Colors.white70 : Colors.black87; // Radio button color for dark/light theme

    final Map<String, String> paymentIcons = {
      'UPI': 'assets/images/upi.png',
      'Pay using card': 'assets/images/credit_card.png',
      'Cash on Delivery': 'assets/images/cod.png',
      'Net Banking': 'assets/images/net_banking.png',
      'EMI': 'assets/images/emi.png',
      'Wallet': 'assets/images/wallet.png',
    };
    final Map<String, String> paymentDescriptions = {
      'UPI': 'Pay with one-set UPI, apps or choose other'.tr,
      'Pay using card': 'All cards supported'.tr,
      'Cash on Delivery': 'Pay at time of delivery'.tr,
      'Net Banking': 'All Indian banks'.tr,
      'EMI': 'Card, EarlySalary and more'.tr,
      'Wallet': 'Pay with digital wallets'.tr,
    };
    final Map<String, String> upiSubOptions = {
      'Google Pay': 'assets/images/google_pay.png',
      'PhonePe': 'assets/images/phonepe.png',
      'Paytm': 'assets/images/paytm.png',
      'Other': 'assets/images/other.png',
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'payment'.tr,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: isDarkMode ? 0 : 2,
        shadowColor: isDarkMode ? null : Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 80.0), // Added bottom padding for sticky button
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'order_summary'.tr,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Card(
                    elevation: 3,
                    color: Theme.of(context).colorScheme.surface,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'subtotal'.tr,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              Text(
                                '\$${cartController.totalAmount.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'discount'.tr,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              Text(
                                checkoutController.discount.value > 0
                                    ? '-\$${((cartController.totalAmount * checkoutController.discount.value).toStringAsFixed(2))}'
                                    : '\$0.00',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'total'.tr,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              Text(
                                '\$${checkoutController.discountedTotal.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'payment_methods'.tr,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  ...checkoutController.paymentMethods.map((method) {
                    return Column(
                      children: [
                        Card(
                          elevation: 3,
                          color: Theme.of(context).colorScheme.surface,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                RadioListTile<String>(
                                  contentPadding: const EdgeInsets.all(6.0),
                                  title: Text(
                                    method.tr,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.onSurface,
                                      fontSize: 14,
                                    ),
                                  ),
                                  subtitle: Text(
                                    paymentDescriptions[method] ?? '',
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                      fontSize: 12,
                                    ),
                                  ),
                                  value: method,
                                  groupValue: checkoutController.selectedPaymentMethod.value,
                                  onChanged: (value) {
                                    checkoutController.selectedPaymentMethod.value = value ?? '';
                                    if (method != 'UPI') {
                                      checkoutController.selectedUpiOption.value = '';
                                    }
                                    if (method != 'Pay using card') {
                                      checkoutController.selectCard(null);
                                    }
                                    if (method != 'Net Banking') {
                                      checkoutController.selectedBank.value = '';
                                    }
                                  },
                                  activeColor: radioColor, // Light in dark theme, dark in light theme
                                  secondary: paymentIcons[method] != null
                                      ? Image.asset(
                                          paymentIcons[method]!,
                                          width: 40,
                                          height: 40,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Icon(
                                              Icons.error,
                                              color: Theme.of(context).colorScheme.primary,
                                              size: 40,
                                            );
                                          },
                                        )
                                      : Icon(
                                          Icons.error,
                                          color: Theme.of(context).colorScheme.primary,
                                          size: 40,
                                        ),
                                  controlAffinity: ListTileControlAffinity.leading,
                                ),
                                if (checkoutController.selectedPaymentMethod.value == method) ...[
                                  const Divider(height: 12),
                                  _buildPaymentContent(
                                    context,
                                    method,
                                    upiSubOptions,
                                    checkoutController,
                                    textFieldContentColor,
                                    iconColor,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    );
                  }).toList(),
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
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentContent(
    BuildContext context,
    String method,
    Map<String, String> upiSubOptions,
    CheckoutController checkoutController,
    Color textFieldContentColor,
    Color iconColor,
  ) {
    final radioColor = Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black87; // Radio button color for dark/light theme

    switch (method) {
      case 'UPI':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'select_upi_option'.tr,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: upiSubOptions.entries.map((entry) {
                return GestureDetector(
                  onTap: () => checkoutController.selectedUpiOption.value = entry.key,
                  child: Obx(
                    () => AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: checkoutController.selectedUpiOption.value == entry.key
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey,
                          width: checkoutController.selectedUpiOption.value == entry.key ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Column(
                        children: [
                          Image.asset(
                            entry.value,
                            width: 40,
                            height: 40,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.error,
                                color: Theme.of(context).colorScheme.primary,
                                size: 40,
                              );
                            },
                          ),
                          const SizedBox(height: 6),
                          Text(
                            entry.key.tr,
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      case 'Pay using card':
        return Form(
          key: checkoutController.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'select_saved_card'.tr,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              if (checkoutController.savedCards.isEmpty)
                Text(
                  'no_cards_saved'.tr,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    fontSize: 14,
                  ),
                )
              else
                ...checkoutController.savedCards.take(2).map((card) {
                  return Card(
                    elevation: 3,
                    color: Theme.of(context).colorScheme.surface,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: RadioListTile<CardDetails>(
                      contentPadding: const EdgeInsets.all(6.0),
                      title: Text(
                        '**** **** **** ${card.cardNumber.substring(card.cardNumber.length - 4)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      subtitle: Text(
                        'Expires: ${card.expiryDate}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                      value: card,
                      groupValue: checkoutController.selectedCard.value,
                      onChanged: (value) => checkoutController.selectCard(value),
                      activeColor: radioColor, // Light in dark theme, dark in light theme
                      secondary: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.credit_card,
                            color: iconColor,
                            size: 24,
                          ),
                          const SizedBox(width: 6),
                          IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.redAccent,
                              size: 24,
                            ),
                            onPressed: () => checkoutController.removeCard(card),
                            tooltip: 'remove_card'.tr,
                          ),
                        ],
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  );
                }).toList(),
              if (checkoutController.savedCards.length > 2)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: TextButton(
                    onPressed: () {
                      // Logic to show more cards (e.g., navigate to a new screen or expand)
                    },
                    child: Text(
                      'Show more cards',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              Text(
                'card_details'.tr,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                onChanged: (value) => checkoutController.cardNumber.value = value,
                decoration: InputDecoration(
                  labelText: 'card_number'.tr,
                  labelStyle: TextStyle(
                    color: textFieldContentColor,
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(
                    Icons.credit_card,
                    color: textFieldContentColor,
                    size: 24,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: textFieldContentColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: textFieldContentColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: textFieldContentColor,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.redAccent,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.redAccent,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.2),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                ),
                style: TextStyle(color: textFieldContentColor, fontSize: 14),
                cursorColor: textFieldContentColor,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(16),
                ],
                validator: _validateCardNumber,
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      onChanged: (value) => checkoutController.expiryDate.value = value,
                      decoration: InputDecoration(
                        labelText: 'expiry_date'.tr,
                        labelStyle: TextStyle(
                          color: textFieldContentColor,
                          fontSize: 14,
                        ),
                        prefixIcon: Icon(
                          Icons.calendar_today,
                          color: textFieldContentColor,
                          size: 24,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: textFieldContentColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: textFieldContentColor),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: textFieldContentColor,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.redAccent,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.redAccent,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.2),
                        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      ),
                      style: TextStyle(
                        color: textFieldContentColor,
                        fontSize: 14,
                      ),
                      cursorColor: textFieldContentColor,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')),
                        LengthLimitingTextInputFormatter(5),
                        _ExpiryDateInputFormatter(),
                      ],
                      validator: _validateExpiryDate,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: TextFormField(
                      onChanged: (value) => checkoutController.cvv.value = value,
                      decoration: InputDecoration(
                        labelText: 'cvv'.tr,
                        labelStyle: TextStyle(
                          color: textFieldContentColor,
                          fontSize: 14,
                        ),
                        prefixIcon: Icon(
                          Icons.lock,
                          color: textFieldContentColor,
                          size: 24,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: textFieldContentColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: textFieldContentColor),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: textFieldContentColor,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.redAccent,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.redAccent,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.2),
                        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      ),
                      style: TextStyle(
                        color: textFieldContentColor,
                        fontSize: 14,
                      ),
                      cursorColor: textFieldContentColor,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(3),
                      ],
                      validator: _validateCvv,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      case 'Net Banking':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'select_bank'.tr,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            Obx(
              () => DropdownButtonFormField<String>(
                value: checkoutController.selectedBank.value.isEmpty ? null : checkoutController.selectedBank.value,
                hint: Text(
                  'choose_an_option'.tr,
                  style: TextStyle(
                    color: textFieldContentColor.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: textFieldContentColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: textFieldContentColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: textFieldContentColor,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.2),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                ),
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: iconColor,
                  size: 24,
                ),
                style: TextStyle(
                  color: textFieldContentColor,
                  fontSize: 14,
                ),
                items: checkoutController.banks.map((String bank) {
                  return DropdownMenuItem<String>(
                    value: bank,
                    child: Text(bank.tr, style: TextStyle(fontSize: 14)),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    checkoutController.selectedBank.value = newValue;
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'please_select_bank'.tr;
                  }
                  return null;
                },
              ),
            ),
          ],
        );
      case 'Cash on Delivery':
        return Text(
          'pay_at_delivery'.tr,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        );
      case 'EMI':
        return Text(
          'select_emi_option'.tr,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        );
      case 'Wallet':
        return Text(
          'select_wallet_to_proceed'.tr,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        );
      default:
        return const SizedBox.shrink();
    }
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

  const AnimatedButton({
    required this.text,
    this.onPressed,
    this.icon,
    required this.isDarkMode,
    this.isLoading = false,
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
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(10),
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
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
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
                    const SizedBox(width: 6),
                  ] else if (icon != null) ...[
                    Icon(
                      icon,
                      color: Theme.of(context).colorScheme.onSurface,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                  ],
                  Text(
                    text,
                    style: TextStyle(
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