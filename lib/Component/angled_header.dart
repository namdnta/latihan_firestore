import 'package:flutter/material.dart';

/// ===============================
/// Angled Green Header (Reusable)
/// ===============================
class AngledHeader extends StatelessWidget {
  final String title;
  final double height;

  const AngledHeader({super.key, required this.title, this.height = 120});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        children: [
          // Base background
          Container(color: AppColors.background),

          // Back layer (lighter green)
          ClipPath(
            clipper: _BackSlantClipper(),
            child: Container(color: AppColors.primaryGreen.withOpacity(0.65)),
          ),

          // Front layer (main green)
          ClipPath(
            clipper: _FrontSlantClipper(),
            child: Container(color: AppColors.primaryGreen),
          ),

          // Title
          Positioned(
            left: 16,
            top: 24,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ===============================
/// Back Slanted Layer
/// ===============================
class _BackSlantClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height * 0.55);
    path.lineTo(0, size.height * 0.85);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

/// ===============================
/// Front Slanted Layer
/// ===============================
class _FrontSlantClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height * 0.35);
    path.lineTo(0, size.height * 0.65);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

/// ===============================
/// App Colors (contoh)
/// ===============================
class AppColors {
  static const Color primaryGreen = Color(0xFF6B8F71);
  static const Color background = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF2E2E2E);
}
