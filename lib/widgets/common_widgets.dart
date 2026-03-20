// lib/widgets/common_widgets.dart

import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

// ── The big stacked "TRUST / ISSUES" title shown at the top of every game screen
class TrustIssuesHeader extends StatelessWidget {
  const TrustIssuesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.coral,
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: const Column(
        children: [
          Text(
            'TRUST',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 3,
              height: 1.0,
            ),
          ),
          Text(
            'ISSUES',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 3,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}

// ── A single settings row on the home screen (white pill card)
// Shows an icon + label on the left and a tappable action text on the right
class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String actionLabel;
  final Color? actionColor;
  final VoidCallback onTap;
  final Widget? trailing; // optional custom trailing widget (e.g. a toggle)

  const SettingsTile({
    super.key,
    required this.icon,
    required this.label,
    required this.actionLabel,
    required this.onTap,
    this.actionColor,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.coral, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
            ),
            trailing ??
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    actionLabel,
                    style: TextStyle(
                      fontSize: 13,
                      color: actionColor ?? AppColors.coral,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

// ── Full-width green button used for primary actions
class BigGreenButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;

  const BigGreenButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        icon: icon != null
            ? Icon(icon, size: 18, color: Colors.white)
            : const SizedBox.shrink(),
        label: Text(label),
        onPressed: onPressed,
      ),
    );
  }
}

// ── Full-width dark/black button (used for "New Round" in mockup)
class BigDarkButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const BigDarkButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkButton,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

// ── White rounded card container
class GameCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;

  const GameCard({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}