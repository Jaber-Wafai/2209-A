import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'wallet_page.dart';

const Color primaryGreen = Color(0xFF2D6A4F);
const Color darkGreenText = Color(0xFF1B4332);
const Color lightGreen = Color(0xFFE6F4EA);

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              const _Header(),
              const BannerCarousel(),
              const _SectionTitle(title: 'Shop by Category'),
              const _CategoryGrid(),
              const _SectionTitle(title: 'Best Sellers'),
              const _BestSellers(),
              DigitalWalletSection(),
              const _Footer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 60,
            child: Image.asset('assets/images/baklawati_logo.png', fit: BoxFit.contain),
          ),
          Row(
            children: [
              if (isMobile)
                PopupMenuButton<String>(
                  icon: const Icon(Icons.menu, color: primaryGreen),
                  onSelected: (value) => Navigator.pushNamed(context, '/${value.toLowerCase()}'),
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'Shop', child: Text('Shop')),
                    PopupMenuItem(value: 'About', child: Text('About')),
                    PopupMenuItem(value: 'Contact', child: Text('Contact')),
                  ],
                )
              else ...[
                const _NavItem(title: 'Shop'),
                const _NavItem(title: 'About'),
                const _NavItem(title: 'Contact'),
              ],
              const SizedBox(width: 12),
              IconButton(
                onPressed: () => Navigator.pushNamed(context, '/cart'),
                icon: const Icon(Icons.shopping_cart),
                color: primaryGreen,
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => Navigator.pushNamed(context, '/login'),
                icon: const Icon(Icons.login),
                color: primaryGreen,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String title;
  const _NavItem({required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/${title.toLowerCase()}'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: darkGreenText),
        ),
      ),
    );
  }
}

class BannerCarousel extends StatelessWidget {
  const BannerCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> bannerImages = [
      'assets/images/banner1.png',
      'assets/images/banner2.png',
      'assets/images/banner3.png',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: CarouselSlider(
          items: bannerImages.map((imgPath) {
            return Image.asset(
              imgPath,
              fit: BoxFit.cover,
              width: double.infinity,
            );
          }).toList(),
          options: CarouselOptions(
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            viewportFraction: 1,
            height: 220,
            enlargeCenterPage: false,
            disableCenter: true,
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryGreen)),
    );
  }
}

class _CategoryGrid extends StatelessWidget {
  const _CategoryGrid();

  @override
  Widget build(BuildContext context) {
    final categories = ['Baklava', 'Sweets', 'Gifts'];
    final icons = [Icons.restaurant, Icons.cake, Icons.card_giftcard];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: categories.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 24,
          crossAxisSpacing: 24,
          childAspectRatio: 1.2,
        ),
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(color: lightGreen, borderRadius: BorderRadius.circular(12)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icons[index], size: 40, color: primaryGreen),
                const SizedBox(height: 10),
                Text(categories[index], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: darkGreenText))
              ],
            ),
          );
        },
      ),
    );
  }
}

class _BestSellers extends StatelessWidget {
  const _BestSellers();

  @override
  Widget build(BuildContext context) {
    final products = [
      {'name': 'Classic Baklava', 'price': '15.00'},
      {'name': 'Pistachio Rolls', 'price': '22.00'},
      {'name': 'Chocolate Baklava', 'price': '18.50'},
    ];

    return Container(
      height: 260,
      margin: const EdgeInsets.only(bottom: 40),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        separatorBuilder: (_, __) => const SizedBox(width: 24),
        itemBuilder: (context, index) {
          final product = products[index];
          return Container(
            width: 200,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: lightGreen,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                    ),
                    child: const Center(
                      child: Icon(Icons.star, size: 40, color: primaryGreen),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product['name']!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('\$${product['price']}', style: const TextStyle(fontSize: 14, color: Colors.grey)),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryGreen,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Sepete Ekle'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class DigitalWalletSection extends StatelessWidget {
  DigitalWalletSection({super.key});
  final LocalAuthentication _auth = LocalAuthentication();

  Future<void> _authenticate(BuildContext context) async {
    bool canAuthenticate = await _auth.canCheckBiometrics;
    bool authenticated = false;

    if (!canAuthenticate) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cihazda biyometrik doğrulama desteklenmiyor.')),
      );
      return;
    }

    try {
      authenticated = await _auth.authenticate(
        localizedReason: 'Cüzdanınıza erişmek için parmak izi kullanın',
        options: const AuthenticationOptions(biometricOnly: true, stickyAuth: true),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hata: $e')));
      return;
    }

    if (authenticated) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const WalletPage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kimlik doğrulama başarısız.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: lightGreen,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryGreen),
      ),
      child: Row(
        children: [
          const Icon(Icons.account_balance_wallet, color: primaryGreen, size: 32),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              'Dijital Cüzdanınıza erişmek için tıklayın.',
              style: TextStyle(fontSize: 16, color: darkGreenText),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () => _authenticate(context),
            style: ElevatedButton.styleFrom(backgroundColor: primaryGreen, foregroundColor: Colors.white),
            icon: const Icon(Icons.fingerprint),
            label: const Text('Giriş'),
          ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      color: Colors.grey.shade100,
      child: const Column(
        children: [
          Text('© 2025 Baklawati. All rights reserved.', style: TextStyle(color: darkGreenText)),
          SizedBox(height: 8),
          Text('Made with ❤️ in Türkiye', style: TextStyle(color: darkGreenText)),
        ],
      ),
    );
  }
}