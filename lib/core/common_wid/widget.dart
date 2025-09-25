import 'dart:ui';

import 'package:ecommerce_flutter/core/theme/app_color.dart';
import 'package:ecommerce_flutter/core/theme/app_font.dart';
import 'package:ecommerce_flutter/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';

class GradientIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final Gradient gradient;

  const GradientIcon(
    this.icon, {
    super.key,
    required this.size,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) {
        return gradient.createShader(
          Rect.fromLTWH(0, 0, size, size),
        );
      },
      child: Icon(
        icon,
        size: size,
        color: Colors.white, // base color, overridden by gradient
      ),
    );
  }
}

class CustomeButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final double width;
  final double height;
  final double borderRadius;
  final bool isLoading; // ✅ Added

  const CustomeButton({
    super.key,
    required this.text,
    required this.onTap,
    this.width = double.infinity,
    this.height = 50,
    this.borderRadius = 16,
    this.isLoading = false, // ✅ Default: not loading
  });

  @override
  Widget build(BuildContext context) {
    final borderRadiusValue = BorderRadius.circular(borderRadius);

    return GestureDetector(
      onTap: isLoading ? null : onTap, // ✅ Disable tap when loading
      child: ClipRRect(
        borderRadius: borderRadiusValue,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            margin: const EdgeInsets.all(8),
            width: width,
            height: height,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: borderRadiusValue,
              color:
                  AppColors.secondary, // replace with AppColors.secondaryLight
              border: Border.all(
                color: AppColors
                    .secondaryDark, // replace with AppColors.secondaryLight
                width: 1.5,
              ),
            ),
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    text,
                    style: const TextStyle(
                      color: Colors.white, // replace with AppColors.secondary
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

double getHeight(double h) {
  return Get.height * h;
}

double getWidth(double w) {
  return Get.width * w;
}

Widget loadImage(String imageUrl, {double? height, double? width}) {
  // if (imageUrl == null || imageUrl.isEmpty || imageUrl == "NA") {
  //   // ✅ If URL missing or invalid, show local placeholder
  //   return Image.asset(
  //     "assets/icons/default.png",
  //     height: getHeight(0.12),
  //     width: getWidth(0.12),
  //     fit: BoxFit.contain,
  //   );
  // }

  return Image.asset(
    "assets/images/logo.png",
    height: height ?? 10,
    width: width ?? 10,
  );
// //  return Image.network(
//     imageUrl,
//     height: getHeight(0.12),
//     width: getWidth(0.12),
//     fit: BoxFit.contain,
//     errorBuilder: (context, error, stackTrace) {
//       // ✅ Fallback on load failure
//       return Image.asset(
//         "assets/icons/default.png",
//         height: getHeight(0.12),
//         width: getWidth(0.12),
//         fit: BoxFit.contain,
//       );
//     },
//     loadingBuilder: (context, child, loadingProgress) {
//       if (loadingProgress == null) return child;
//       // ✅ Show loader with same size
//       return SizedBox(
//         height: getHeight(0.12),
//         width: getWidth(0.12),
//         child: Center(
//           child: CircularProgressIndicator(strokeWidth: 2),
//         ),
//       );
//     },
//   );
}

void showNotificationDialog(
  String title,
  String body,
) {
  showDialog(
    context: Get.context!,
    builder: (context) {
      return Dialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero, // No border radius (square)
        ),
        child: Container(
          width: 300,
          height: 180,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text(body, style: const TextStyle(fontSize: 16)),
              const Spacer(),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("OK"),
              ),
            ],
          ),
        ),
      );
    },
  );
}

/// ✅ Custom Success Widget
Widget successToastWidget(String message) {
  return ToastificationWrapper(
    child: Row(
      children: [
        const Icon(Icons.check_circle, color: Colors.green, size: 28),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            message,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close, size: 20, color: Colors.grey),
          onPressed: () {
            toastification.dismissAll();
          },
        ),
      ],
    ),
  );
}

/// ❌ Custom Failure Widget
Widget errorToastWidget(String message) {
  return ToastificationWrapper(
    child: Row(
      children: [
        const Icon(Icons.error, color: Colors.red, size: 28),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            message,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close, size: 20, color: Colors.grey),
          onPressed: () {
            toastification.dismissAll();
          },
        ),
      ],
    ),
  );
}
