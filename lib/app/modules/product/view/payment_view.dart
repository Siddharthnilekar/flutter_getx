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

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textFieldContentColor = isDarkMode ? Colors.white70 : Colors.black87;
    final iconColor = isDarkMode ? Colors.white70 : Colors.black87;
    final radioColor = isDarkMode ? Colors.white70 : Colors.black87;

    final Map<String, String> paymentIcons = {
      'UPI': 'assets/images/upi.png',
      'Pay using card': 'assets/images/credit_card.png',
      'Cash on Delivery': 'assets/images/cod.png',
      'Net Banking': 'assets/images/net_banking.png',
      'EMI': 'assets/images/emi.png',
      'Wallet': 'assets/images/wallet.png',
    };
    final Map<String, String> paymentDescriptions = {
      'UPI': 'Pay with UPI apps'.tr,
      'Pay using card': 'All cards supported'.tr,
      'Cash on Delivery': 'Pay at delivery'.tr,
      'Net Banking': 'All Indian banks'.tr,
      'EMI': 'Card, EMI options'.tr,
      'Wallet': 'Digital wallets'.tr,
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
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: isDarkMode ? 0 : 1,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(8.0, 2.0, 8.0, 80.0),
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order summary'.tr,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Card(
                    elevation: 2,
                    color: Theme.of(context).colorScheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Subtotal'.tr,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              Text(
                                '\$${cartController.totalAmount.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 1),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Discount'.tr,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              Text(
                                checkoutController.discount.value > 0
                                    ? '-\$${((cartController.totalAmount * checkoutController.discount.value).toStringAsFixed(2))}'
                                    : '\$0.00',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'total'.tr,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              Text(
                                '\$${checkoutController.discountedTotal.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 14,
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
                  const SizedBox(height: 2),
                  Text(
                    'How would you like to pay?'.tr,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 1),
                  ...checkoutController.paymentMethods.map((method) {
                    return Column(
                      children: [
                        Card(
                          elevation: 2,
                          color: Theme.of(context).colorScheme.surface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0), 
                            child: Column(
                              children: [
                                RadioListTile<String>(
                                  contentPadding: const EdgeInsets.all(1.0),
                                  title: Text(
                                    method.tr,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.onSurface,
                                      fontSize: 12,
                                    ),
                                  ),
                                  subtitle: Text(
                                    paymentDescriptions[method] ?? '',
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                      fontSize: 10,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
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
                                  activeColor: radioColor,
                                  secondary: Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: paymentIcons[method] != null
                                        ? Image.asset(
                                            paymentIcons[method]!,
                                            width: 32,
                                            height: 32,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Icon(
                                                Icons.error,
                                                color: Theme.of(context).colorScheme.primary,
                                                size: 32,
                                              );
                                            },
                                          )
                                        : Icon(
                                            Icons.error,
                                            color: Theme.of(context).colorScheme.primary,
                                            size: 32,
                                          ),
                                  ),
                                  controlAffinity: ListTileControlAffinity.leading,
                                  dense: true,
                                ),
                                if (checkoutController.selectedPaymentMethod.value == method)
                                  _buildPaymentContent(
                                    context,
                                    method,
                                    upiSubOptions,
                                    checkoutController,
                                    textFieldContentColor,
                                    iconColor,
                                  ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
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
    final radioColor = Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black87;

    switch (method) {
      case 'UPI':
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: upiSubOptions.entries.map((entry) {
            return Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => checkoutController.selectedUpiOption.value = entry.key,
                      child: Obx(
                        () => Container(
                          height: 60,
                          padding: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: checkoutController.selectedUpiOption.value == entry.key
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                entry.value,
                                width: 28,
                                height: 28,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.error,
                                    color: Theme.of(context).colorScheme.primary,
                                    size: 28,
                                  );
                                },
                              ),
                              const SizedBox(height: 2),
                              Text(
                                entry.key.tr,
                                style: TextStyle(
                                  fontSize: 9,
                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                ),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (entry.key != upiSubOptions.keys.last) const SizedBox(width: 8),
                ],
              ),
            );
          }).toList(),
        );
      case 'Pay using card':
        return Form(
          key: checkoutController.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (checkoutController.savedCards.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select saved card'.tr,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 1),
                    ...checkoutController.savedCards.take(2).map((card) {
                      return RadioListTile<CardDetails>(
                        contentPadding: const EdgeInsets.all(1.0),
                        title: Text(
                          '**** **** **** ${card.cardNumber.substring(card.cardNumber.length - 4)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        subtitle: Text(
                          'Expires: ${card.expiryDate}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                            fontSize: 10,
                          ),
                        ),
                        value: card,
                        groupValue: checkoutController.selectedCard.value,
                        onChanged: (value) => checkoutController.selectCard(value),
                        activeColor: radioColor,
                        secondary: Icon(
                          Icons.credit_card,
                          color: iconColor,
                          size: 28,
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        dense: true,
                      );
                    }).toList(),
                  ],
                ),
              const SizedBox(height: 2),
              TextFormField(
                onChanged: (value) => checkoutController.cardNumber.value = value,
                decoration: InputDecoration(
                  labelText: 'card number'.tr,
                  labelStyle: TextStyle(color: textFieldContentColor, fontSize: 12),
                  prefixIcon: Icon(Icons.credit_card, color: textFieldContentColor, size: 22),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(color: textFieldContentColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: textFieldContentColor),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: textFieldContentColor, width: 1.5),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.redAccent, width: 1.5),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.redAccent, width: 1.5),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.2),
                  contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                ),
                style: TextStyle(color: textFieldContentColor, fontSize: 12),
                cursorColor: textFieldContentColor,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(16),
                ],
                validator: _validateCardNumber,
              ),
              const SizedBox(height: 7),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      onChanged: (value) => checkoutController.expiryDate.value = value,
                      decoration: InputDecoration(
                        labelText: 'expiry date'.tr,
                        labelStyle: TextStyle(color: textFieldContentColor, fontSize: 12),
                        prefixIcon: Icon(Icons.calendar_today, color: textFieldContentColor, size: 22),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: textFieldContentColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: textFieldContentColor),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: textFieldContentColor, width: 1.5),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.redAccent, width: 1.5),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.redAccent, width: 1.5),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.2),
                        contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                      ),
                      style: TextStyle(color: textFieldContentColor, fontSize: 12),
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
                  const SizedBox(width: 4),
                  Expanded(
                    child: TextFormField(
                      onChanged: (value) => checkoutController.cvv.value = value,
                      decoration: InputDecoration(
                        labelText: 'cvv'.tr,
                        labelStyle: TextStyle(color: textFieldContentColor, fontSize: 12),
                        prefixIcon: Icon(Icons.lock, color: textFieldContentColor, size: 22),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: textFieldContentColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: textFieldContentColor),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: textFieldContentColor, width: 1.5),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.redAccent, width: 1.5),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.redAccent, width: 1.5),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.2),
                        contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                      ),
                      style: TextStyle(color: textFieldContentColor, fontSize: 12),
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
        return Obx(
          () => DropdownButtonFormField<String>(
            value: checkoutController.selectedBank.value.isEmpty ? null : checkoutController.selectedBank.value,
            hint: Text(
              'Choose an option'.tr,
              style: TextStyle(
                color: textFieldContentColor.withOpacity(0.7),
                fontSize: 12,
              ),
            ),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: textFieldContentColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: textFieldContentColor),
                borderRadius: BorderRadius.circular(6),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: textFieldContentColor, width: 1.5),
                borderRadius: BorderRadius.circular(6),
              ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.2),
              contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
            ),
            icon: Icon(Icons.arrow_drop_down, color: iconColor, size: 28),
            style: TextStyle(color: textFieldContentColor, fontSize: 12),
            items: checkoutController.banks.map((String bank) {
              return DropdownMenuItem<String>(
                value: bank,
                child: Text(bank.tr, style: TextStyle(fontSize: 12)),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                checkoutController.selectedBank.value = newValue;
              }
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select bank'.tr;
              }
              return null;
            },
          ),
        );
      case 'Cash on Delivery':
      case 'EMI':
      case 'Wallet':
        return Text(
          method == 'Cash on Delivery'
              ? 'you will need to pay cash when deliveryman arrives'.tr
              : method == 'EMI'
                  ? 'select_emi_option'.tr
                  : 'select_wallet_to_proceed'.tr,
          style: TextStyle(
            fontSize: 12,
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
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isLoading) ...[
                    const SizedBox(
                      width: 10,
                      height: 10,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    ),
                    const SizedBox(width: 2),
                  ] else if (icon != null) ...[
                    Icon(
                      icon,
                      color: isDarkMode ? Colors.white : Colors.black,
                      size: 28,
                    ),
                    const SizedBox(width: 2),
                  ],
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 12,
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