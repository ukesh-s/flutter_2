import 'package:flutter/material.dart';

void main() {
  runApp(const FruitApp());
}

// ============================================================
// MAIN APP
// ============================================================

class FruitApp extends StatelessWidget {
  const FruitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fruit Basket',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const FruitHomePage(),
    );
  }
}

// ============================================================
// FRUIT MODEL
// ============================================================

class Fruit {
  final String name;
  final String description;
  final double price;
  final String emoji;
  final String category;

  const Fruit({
    required this.name,
    required this.description,
    required this.price,
    required this.emoji,
    required this.category,
  });
}

// ============================================================
// HOME PAGE
// ============================================================

class FruitHomePage extends StatefulWidget {
  const FruitHomePage({super.key});

  @override
  State<FruitHomePage> createState() => _FruitHomePageState();
}

class _FruitHomePageState extends State<FruitHomePage> {
  // ==========================================================
  // FRUIT LIST
  // ==========================================================

  final List<Fruit> fruits = [
    Fruit(
      name: 'Apple',
      description: 'Fresh and sweet red apple',
      price: 120,
      emoji: '🍎',
      category: 'Fresh',
    ),
    Fruit(
      name: 'Banana',
      description: 'Soft, sweet and nutritious',
      price: 60,
      emoji: '🍌',
      category: 'Fresh',
    ),
    Fruit(
      name: 'Orange',
      description: 'Juicy and rich in Vitamin C',
      price: 80,
      emoji: '🍊',
      category: 'Citrus',
    ),
    Fruit(
      name: 'Grapes',
      description: 'Sweet and delicious grapes',
      price: 100,
      emoji: '🍇',
      category: 'Fresh',
    ),
    Fruit(
      name: 'Mango',
      description: 'King of fruits, sweet and juicy',
      price: 150,
      emoji: '🥭',
      category: 'Tropical',
    ),
    Fruit(
      name: 'Watermelon',
      description: 'Refreshing and full of water',
      price: 90,
      emoji: '🍉',
      category: 'Fresh',
    ),
    Fruit(
      name: 'Pineapple',
      description: 'Tasty tropical fruit',
      price: 110,
      emoji: '🍍',
      category: 'Tropical',
    ),
    Fruit(
      name: 'Strawberry',
      description: 'Fresh, red and delicious',
      price: 180,
      emoji: '🍓',
      category: 'Fresh',
    ),
    Fruit(
      name: 'Papaya',
      description: 'Healthy and naturally sweet',
      price: 70,
      emoji: '🥭',
      category: 'Tropical',
    ),
    Fruit(
      name: 'Kiwi',
      description: 'Green and rich in nutrients',
      price: 200,
      emoji: '🥝',
      category: 'Fresh',
    ),
  ];

  // ==========================================================
  // FAVORITES
  // ==========================================================

  final Set<String> favoriteFruits = {};

  // ==========================================================
  // CART
  // ==========================================================

  final Map<String, int> cart = {};

  // ==========================================================
  // SEARCH
  // ==========================================================

  String searchText = '';

  // ==========================================================
  // FILTERED FRUITS
  // ==========================================================

  List<Fruit> get filteredFruits {
    if (searchText.trim().isEmpty) {
      return fruits;
    }

    return fruits.where((fruit) {
      return fruit.name.toLowerCase().contains(searchText.toLowerCase()) ||
          fruit.category.toLowerCase().contains(searchText.toLowerCase());
    }).toList();
  }

  // ==========================================================
  // CART ITEM COUNT
  // ==========================================================

  int get cartCount {
    int count = 0;

    for (final quantity in cart.values) {
      count += quantity;
    }

    return count;
  }

  // ==========================================================
  // CART TOTAL
  // ==========================================================

  double get cartTotal {
    double total = 0;

    for (final fruit in fruits) {
      final quantity = cart[fruit.name] ?? 0;
      total += fruit.price * quantity;
    }

    return total;
  }

  // ==========================================================
  // ADD TO CART
  // ==========================================================

  void addToCart(Fruit fruit) {
    setState(() {
      cart[fruit.name] = (cart[fruit.name] ?? 0) + 1;
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${fruit.name} added to cart'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // ==========================================================
  // REMOVE FROM CART
  // ==========================================================

  void removeFromCart(Fruit fruit) {
    setState(() {
      final currentQuantity = cart[fruit.name] ?? 0;

      if (currentQuantity > 1) {
        cart[fruit.name] = currentQuantity - 1;
      } else {
        cart.remove(fruit.name);
      }
    });
  }

  // ==========================================================
  // FAVORITE
  // ==========================================================

  void toggleFavorite(Fruit fruit) {
    setState(() {
      if (favoriteFruits.contains(fruit.name)) {
        favoriteFruits.remove(fruit.name);
      } else {
        favoriteFruits.add(fruit.name);
      }
    });
  }

  // ==========================================================
  // REORDER FRUITS
  // ==========================================================

  void reorderFruits(int oldIndex, int newIndex) {
    setState(() {
      // Flutter's ReorderableListView needs this adjustment
      // when moving an item downward.
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }

      final Fruit movedFruit = fruits.removeAt(oldIndex);

      fruits.insert(newIndex, movedFruit);
    });
  }

  // ==========================================================
  // OPEN CART
  // ==========================================================

  void openCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return CartPage(
            fruits: fruits,
            cart: cart,
            onAdd: addToCart,
            onRemove: removeFromCart,
          );
        },
      ),
    ).then((_) {
      setState(() {});
    });
  }

  // ==========================================================
  // BUILD HOME PAGE
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      // ========================================================
      // APP BAR
      // ========================================================
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,

        title: const Row(
          children: [
            Text('🍎', style: TextStyle(fontSize: 25)),
            SizedBox(width: 10),
            Text('Fruit Basket', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),

        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: openCart,
                icon: const Icon(Icons.shopping_cart, size: 28),
              ),

              // Cart badge
              if (cartCount > 0)
                Positioned(
                  right: 4,
                  top: 4,
                  child: Container(
                    padding: const EdgeInsets.all(5),

                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),

                    child: Text(
                      '$cartCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),

      // ========================================================
      // BODY
      // ========================================================
      body: Column(
        children: [
          // ======================================================
          // HEADER CONTAINER
          // ======================================================
          Container(
            width: double.infinity,

            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),

            decoration: const BoxDecoration(
              color: Colors.green,

              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const Text(
                  'Fresh Fruits 🍉',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  'Choose your favourite fruits',
                  style: TextStyle(color: Colors.white70, fontSize: 15),
                ),

                const SizedBox(height: 15),

                // ==================================================
                // SEARCH BOX
                // ==================================================
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),

                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchText = value;
                      });
                    },

                    decoration: const InputDecoration(
                      hintText: 'Search fruits...',

                      prefixIcon: Icon(Icons.search, color: Colors.green),

                      border: InputBorder.none,

                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ======================================================
          // REORDER INSTRUCTION
          // ======================================================
          if (searchText.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),

              child: Row(
                children: [
                  Icon(Icons.drag_indicator, color: Colors.grey.shade600),

                  const SizedBox(width: 5),

                  Text(
                    'Press and drag a fruit to rearrange',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                ],
              ),
            ),

          // ======================================================
          // FRUIT LIST
          // ======================================================
          Expanded(
            child: searchText.isNotEmpty
                ? buildSearchList()
                : buildReorderableList(),
          ),
        ],
      ),

      // ========================================================
      // BOTTOM CART BAR
      // ========================================================
      bottomNavigationBar: cartCount == 0
          ? null
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),

              decoration: const BoxDecoration(
                color: Colors.white,

                boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12)],
              ),

              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    // Cart information
                    Column(
                      mainAxisSize: MainAxisSize.min,

                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          '$cartCount item(s)',
                          style: const TextStyle(color: Colors.grey),
                        ),

                        Text(
                          '₹${cartTotal.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    // View cart
                    ElevatedButton.icon(
                      onPressed: openCart,

                      icon: const Icon(Icons.shopping_cart),

                      label: const Text('View Cart'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  // ==========================================================
  // NORMAL SEARCH LIST
  // ==========================================================

  Widget buildSearchList() {
    if (filteredFruits.isEmpty) {
      return const EmptySearchWidget();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(15),

      itemCount: filteredFruits.length,

      itemBuilder: (context, index) {
        final fruit = filteredFruits[index];

        return FruitCard(
          key: ValueKey(fruit.name),

          fruit: fruit,

          isFavorite: favoriteFruits.contains(fruit.name),

          quantity: cart[fruit.name] ?? 0,

          onFavorite: () {
            toggleFavorite(fruit);
          },

          onAdd: () {
            addToCart(fruit);
          },

          onRemove: () {
            removeFromCart(fruit);
          },
        );
      },
    );
  }

  // ==========================================================
  // REORDERABLE LIST
  // ==========================================================

  Widget buildReorderableList() {
    return ReorderableListView.builder(
      padding: const EdgeInsets.all(15),

      itemCount: fruits.length,

      // --------------------------------------------------------
      // REORDER CALLBACK
      // --------------------------------------------------------
      onReorder: reorderFruits,

      // --------------------------------------------------------
      // BUILD EACH ITEM
      // --------------------------------------------------------
      itemBuilder: (context, index) {
        final fruit = fruits[index];

        return FruitCard(
          key: ValueKey(fruit.name),

          fruit: fruit,

          isFavorite: favoriteFruits.contains(fruit.name),

          quantity: cart[fruit.name] ?? 0,

          onFavorite: () {
            toggleFavorite(fruit);
          },

          onAdd: () {
            addToCart(fruit);
          },

          onRemove: () {
            removeFromCart(fruit);
          },
        );
      },
    );
  }
}

// ============================================================
// REUSABLE FRUIT CARD WIDGET
// ============================================================

class FruitCard extends StatelessWidget {
  final Fruit fruit;
  final bool isFavorite;
  final int quantity;

  final VoidCallback onFavorite;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const FruitCard({
    super.key,

    required this.fruit,
    required this.isFavorite,
    required this.quantity,

    required this.onFavorite,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,

      margin: const EdgeInsets.only(bottom: 12),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),

      child: Container(
        padding: const EdgeInsets.all(15),

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            // ==================================================
            // FRUIT IMAGE / EMOJI
            // ==================================================
            Container(
              width: 70,
              height: 70,

              decoration: BoxDecoration(
                color: Colors.green.shade50,

                borderRadius: BorderRadius.circular(15),
              ),

              alignment: Alignment.center,

              child: Text(fruit.emoji, style: const TextStyle(fontSize: 42)),
            ),

            const SizedBox(width: 15),

            // ==================================================
            // FRUIT DETAILS
            // ==================================================
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  // ------------------------------------------------
                  // NAME + FAVORITE
                  // ------------------------------------------------
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          fruit.name,

                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      IconButton(
                        onPressed: onFavorite,

                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,

                          color: isFavorite ? Colors.red : Colors.grey,
                        ),
                      ),
                    ],
                  ),

                  // ------------------------------------------------
                  // DESCRIPTION
                  // ------------------------------------------------
                  Text(
                    fruit.description,

                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),

                  const SizedBox(height: 8),

                  // ------------------------------------------------
                  // PRICE + CART BUTTON
                  // ------------------------------------------------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Text(
                        '₹${fruit.price.toStringAsFixed(0)}',

                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // ------------------------------------------------
                      // ADD BUTTON
                      // ------------------------------------------------
                      if (quantity == 0)
                        ElevatedButton(
                          onPressed: onAdd,

                          child: const Text('Add'),
                        )
                      // ------------------------------------------------
                      // QUANTITY CONTROLS
                      // ------------------------------------------------
                      else
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,

                            borderRadius: BorderRadius.circular(10),
                          ),

                          child: Row(
                            mainAxisSize: MainAxisSize.min,

                            children: [
                              IconButton(
                                onPressed: onRemove,

                                icon: const Icon(Icons.remove, size: 18),
                              ),

                              Text(
                                '$quantity',

                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              IconButton(
                                onPressed: onAdd,

                                icon: const Icon(Icons.add, size: 18),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // ==================================================
            // DRAG INDICATOR
            // ==================================================
            const SizedBox(width: 5),

            const Icon(Icons.drag_indicator, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// EMPTY SEARCH WIDGET
// ============================================================

class EmptySearchWidget extends StatelessWidget {
  const EmptySearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          const Text('🍂', style: TextStyle(fontSize: 60)),

          const SizedBox(height: 10),

          const Text(
            'No fruits found',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 5),

          Text(
            'Try searching for another fruit',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// CART PAGE
// ============================================================

class CartPage extends StatefulWidget {
  final List<Fruit> fruits;

  final Map<String, int> cart;

  final Function(Fruit) onAdd;
  final Function(Fruit) onRemove;

  const CartPage({
    super.key,

    required this.fruits,
    required this.cart,

    required this.onAdd,
    required this.onRemove,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // ==========================================================
  // CART FRUITS
  // ==========================================================

  List<Fruit> get cartFruits {
    return widget.fruits.where((fruit) {
      return (widget.cart[fruit.name] ?? 0) > 0;
    }).toList();
  }

  // ==========================================================
  // TOTAL
  // ==========================================================

  double get total {
    double result = 0;

    for (final fruit in widget.fruits) {
      final quantity = widget.cart[fruit.name] ?? 0;

      result += fruit.price * quantity;
    }

    return result;
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Cart',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),

      body: cartFruits.isEmpty
          ? const EmptyCartWidget()
          : Column(
              children: [
                // ==================================================
                // CART LIST
                // ==================================================
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(15),

                    itemCount: cartFruits.length,

                    itemBuilder: (context, index) {
                      final fruit = cartFruits[index];

                      return CartItem(
                        key: ValueKey(fruit.name),

                        fruit: fruit,

                        quantity: widget.cart[fruit.name] ?? 0,

                        onAdd: () {
                          widget.onAdd(fruit);

                          setState(() {});
                        },

                        onRemove: () {
                          widget.onRemove(fruit);

                          setState(() {});
                        },
                      );
                    },
                  ),
                ),

                // ==================================================
                // TOTAL SECTION
                // ==================================================
                Container(
                  width: double.infinity,

                  padding: const EdgeInsets.all(20),

                  decoration: const BoxDecoration(
                    color: Colors.white,

                    boxShadow: [
                      BoxShadow(blurRadius: 10, color: Colors.black12),
                    ],
                  ),

                  child: Column(
                    children: [
                      // ------------------------------------------------
                      // TOTAL
                      // ------------------------------------------------
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          const Text(
                            'Total',

                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          Text(
                            '₹${total.toStringAsFixed(0)}',

                            style: const TextStyle(
                              fontSize: 22,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      // ------------------------------------------------
                      // PLACE ORDER
                      // ------------------------------------------------
                      SizedBox(
                        width: double.infinity,

                        child: ElevatedButton(
                          onPressed: showOrderDialog,

                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(15),
                          ),

                          child: const Text(
                            'Place Order',

                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  // ==========================================================
  // ORDER DIALOG
  // ==========================================================

  void showOrderDialog() {
    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          title: const Text('Order Placed! 🎉'),

          content: Text(
            'Your order of ₹${total.toStringAsFixed(0)} has been placed successfully.',
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

// ============================================================
// REUSABLE CART ITEM WIDGET
// ============================================================

class CartItem extends StatelessWidget {
  final Fruit fruit;
  final int quantity;

  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const CartItem({
    super.key,

    required this.fruit,
    required this.quantity,

    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),

      child: Container(
        padding: const EdgeInsets.all(12),

        child: Row(
          children: [
            // ==================================================
            // FRUIT
            // ==================================================
            Container(
              width: 55,
              height: 55,

              decoration: BoxDecoration(
                color: Colors.green.shade50,

                borderRadius: BorderRadius.circular(12),
              ),

              alignment: Alignment.center,

              child: Text(fruit.emoji, style: const TextStyle(fontSize: 32)),
            ),

            const SizedBox(width: 12),

            // ==================================================
            // INFORMATION
            // ==================================================
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    fruit.name,

                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    '₹${fruit.price.toStringAsFixed(0)} × $quantity',

                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            // ==================================================
            // QUANTITY
            // ==================================================
            Row(
              mainAxisSize: MainAxisSize.min,

              children: [
                IconButton(
                  onPressed: onRemove,

                  icon: const Icon(Icons.remove_circle_outline),
                ),

                Text(
                  '$quantity',

                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                IconButton(
                  onPressed: onAdd,

                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// EMPTY CART WIDGET
// ============================================================

class EmptyCartWidget extends StatelessWidget {
  const EmptyCartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          const Text('🛒', style: TextStyle(fontSize: 80)),

          const SizedBox(height: 15),

          const Text(
            'Your cart is empty',

            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          Text(
            'Add some delicious fruits!',

            style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },

            child: const Text('Continue Shopping'),
          ),
        ],
      ),
    );
  }
}
