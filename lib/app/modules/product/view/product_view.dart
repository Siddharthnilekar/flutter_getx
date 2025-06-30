import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_chapter_1/app/modules/product/controllers/product_controller.dart';
import 'package:getx_chapter_1/app/modules/product/controllers/cart_controller.dart';
import 'package:getx_chapter_1/app/services/theme_service.dart';
import 'package:getx_chapter_1/app/services/language_selector.dart';
import '../models/product_model.dart';

class ProductView extends StatelessWidget {
  final ProductController productController = Get.find<ProductController>();
  final CartController cartController = Get.find<CartController>();
  final GlobalKey cartIconKey = GlobalKey(); // Key to track cart icon position
  final TextEditingController _searchController =
      TextEditingController(); // Controller for search bar

  ProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('product_list'.tr),
        actions: [
          const LanguageSelector(),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Obx(
              () => Badge(
                isLabelVisible: cartController.cartItems.isNotEmpty,
                label: Text(
                  cartController.cartItems.length.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
                backgroundColor: Colors.red,
                offset: const Offset(-4, -4),
                child: IconButton(
                  key: cartIconKey,
                  icon: const Icon(Icons.shopping_cart),
                  tooltip: 'view_cart'.tr,
                  onPressed: () => Get.toNamed('/cart'),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.brightness_6),
            tooltip: 'theme'.tr,
            onPressed: () => ThemeService().switchTheme(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Obx(
              () => TextField(
                controller: _searchController,
                onChanged: (value) =>
                    productController.filterProducts(value.trimLeft()),
                cursorColor: Theme.of(context)
                    .colorScheme
                    .onSurface, // Black in light mode, white in dark mode
                decoration: InputDecoration(
                  labelText: 'search_products'.tr,
                  labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ), // Black in light mode, white in dark mode
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: productController.searchQuery.value.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            productController.filterProducts('');
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (productController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (productController.errorMessage.isNotEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(productController.errorMessage.value),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () => productController.fetchProducts(),
                        child: Text('retry'.tr),
                      ),
                    ],
                  ),
                );
              }
              return GridView.builder(
                padding: const EdgeInsets.all(12.0),
                itemCount: productController.filteredProductList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio:
                      MediaQuery.of(context).size.width /
                      (MediaQuery.of(context).size.height * 1.0),
                ),
                itemBuilder: (context, index) {
                  final product = productController.filteredProductList[index];
                  return AnimatedListItem(
                    key: ValueKey(product.id),
                    product: product,
                    cartIconKey: cartIconKey,
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class AnimatedListItem extends StatefulWidget {
  final ProductModel product;
  final GlobalKey cartIconKey;

  const AnimatedListItem({
    required Key key,
    required this.product,
    required this.cartIconKey,
  }) : super(key: key);

  @override
  _AnimatedListItemState createState() => _AnimatedListItemState();
}

class _AnimatedListItemState extends State<AnimatedListItem> {
  bool _isTapped = false;

  void _addToCartWithAnimation(BuildContext context) {
    final cartController = Get.find<CartController>();
    final RenderBox? cartBox =
        widget.cartIconKey.currentContext?.findRenderObject() as RenderBox?;
    final RenderBox? itemBox = context.findRenderObject() as RenderBox?;
    if (cartBox == null || itemBox == null) return;

    final cartPosition = cartBox.localToGlobal(Offset.zero);
    final itemPosition = itemBox.localToGlobal(Offset.zero);
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => AnimatedImageToCart(
        imageUrl: widget.product.image,
        startPosition: itemPosition,
        endPosition: cartPosition,
        onAnimationComplete: () {
          cartController.addToCart(widget.product);
          Get.snackbar(
            'added_to_cart'.tr,
            '${widget.product.title} ${'added_to_cart_message'.tr}',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        },
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(const Duration(milliseconds: 600), () {
      overlayEntry.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent:
            ModalRoute.of(context)!.animation ??
            const AlwaysStoppedAnimation(1.0),
        curve: Curves.easeIn,
      ),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isTapped = true),
        onTapUp: (_) => setState(() => _isTapped = false),
        onTapCancel: () => setState(() => _isTapped = false),
        onTap: () => Get.toNamed('/product-details', arguments: widget.product),
        child: AnimatedScale(
          scale: _isTapped ? 0.95 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: Material(
            elevation: 3,
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(
              context,
            ).colorScheme.surface, // Theme-based card background
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                        image: NetworkImage(widget.product.image),
                        fit: BoxFit.contain,
                        onError: (exception, stackTrace) =>
                            const Icon(Icons.error, size: 50),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Flexible(
                    child: Text(
                      widget.product.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface, // Theme-based text color
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.green, // Retain original green color
                        ),
                        child: Row(
                          children: [
                            Text(
                              widget.product.rating.rate.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.star,
                              color: Colors.white,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        child: Text(
                          widget.product.category,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface, // Theme-based text color
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${widget.product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface, // Theme-based text color
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: AnimatedButton(
                      text: 'add_to_cart'.tr,
                      onPressed: () => _addToCartWithAnimation(context),
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

class AnimatedButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;

  const AnimatedButton({
    required this.text,
    required this.onPressed,
    super.key,
  });

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onPressed();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: ElevatedButton(
              onPressed: widget.onPressed,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
              child: Text(
                widget.text,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface, // Black in light mode, white in dark mode
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class AnimatedImageToCart extends StatefulWidget {
  final String imageUrl;
  final Offset startPosition;
  final Offset endPosition;
  final VoidCallback onAnimationComplete;

  const AnimatedImageToCart({
    required this.imageUrl,
    required this.startPosition,
    required this.endPosition,
    required this.onAnimationComplete,
    super.key,
  });

  @override
  _AnimatedImageToCartState createState() => _AnimatedImageToCartState();
}

class _AnimatedImageToCartState extends State<AnimatedImageToCart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _positionAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _positionAnimation = Tween<Offset>(
      begin: widget.startPosition,
      end: widget.endPosition,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.3,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.addListener(() {
      setState(() {});
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onAnimationComplete();
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _positionAnimation.value.dx,
      top: _positionAnimation.value.dy,
      child: Transform.scale(
        scale: _scaleAnimation.value,
        child: Opacity(
          opacity: _opacityAnimation.value,
          child: Image.network(
            widget.imageUrl,
            width: 50,
            height: 50,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.error),
          ),
        ),
      ),
    );
  }
}
