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
    final buttonColor = isDarkMode ? Colors.white70 : Colors.black87;

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
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
                      child: RadioListTile<String>(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                        },
                        activeColor: textFieldContentColor,
                        secondary: paymentIcons[method] != null
                            ? Image.asset(
                                paymentIcons[method]!,
                                width: 24,
                                height: 24,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.error,
                                    color: Theme.of(context).colorScheme.primary,
                                  );
                                },
                              )
                            : Icon(
                                Icons.error,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),
                    if (checkoutController.selectedPaymentMethod.value == method) ...[
                      const SizedBox(height: 6),
                      Card(
                        elevation: 3,
                        color: Theme.of(context).colorScheme.surface,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: _buildPaymentContent(
                            context,
                            method,
                            upiSubOptions,
                            checkoutController,
                            textFieldContentColor,
                            iconColor,
                          ),
                        ),
                      ),
                    ],
                  ],
                );
              }).toList(),
              const SizedBox(height: 12),
              Center(
                child: AnimatedButton(
                  text: checkoutController.isPlacingOrder.value ? 'placing_order'.tr : 'place_order'.tr,
                  onPressed: checkoutController.isPlacingOrder.value ? null : () => checkoutController.placeOrder(),
                  icon: checkoutController.isPlacingOrder.value ? Icons.hourglass_empty : Icons.check_circle,
                  isDarkMode: isDarkMode,
                  isLoading: checkoutController.isPlacingOrder.value,
                  buttonColor: buttonColor,
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
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
    switch (method) {
      case 'UPI':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'select_upi_option'.tr,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: upiSubOptions.entries.map((entry) {
                return GestureDetector(
                  onTap: () => checkoutController.selectedUpiOption.value = entry.key,
                  child: Obx(
                    () => Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: checkoutController.selectedUpiOption.value == entry.key
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(8),
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
                              );
                            },
                          ),
                          const SizedBox(height: 4),
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
                  fontSize: 16,
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
                ...checkoutController.savedCards.map((card) {
                  return Card(
                    elevation: 2,
                    child: RadioListTile<CardDetails>(
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
                      activeColor: textFieldContentColor,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      secondary: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.credit_card,
                            color: iconColor,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
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
              const SizedBox(height: 12),
              Text(
                'card_details'.tr,
                style: TextStyle(
                  fontSize: 16,
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
                    color: iconColor,
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
                          color: iconColor,
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
                          color: iconColor,
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
      case 'Cash on Delivery':
        return Text(
          'pay_at_delivery'.tr,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        );
      case 'Net Banking':
        return Text(
          'select_bank_to_proceed'.tr,
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
  final Color buttonColor;

  const AnimatedButton({
    required this.text,
    this.onPressed,
    this.icon,
    required this.isDarkMode,
    this.isLoading = false,
    required this.buttonColor,
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
          curve: Curves.easeInOut,
          transform: Matrix4.identity()..scale((isTapped.value && !isLoading) ? 0.95 : 1.0),
          child: Container(
            decoration: BoxDecoration(
              color: buttonColor,
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
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ] else if (icon != null) ...[
                    Icon(
                      icon,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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