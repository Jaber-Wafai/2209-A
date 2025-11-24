import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

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
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: CarouselSlider(
          items: bannerImages.map((img) {
            return Image.asset(
              img,
              fit: BoxFit.cover,
              width: double.infinity,
            );
          }).toList(),
          options: CarouselOptions(
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            enlargeCenterPage: true,
            viewportFraction: 1,
            height: 220,
          ),
        ),
      ),
    );
  }
}
