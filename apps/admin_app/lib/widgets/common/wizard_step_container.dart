import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class WizardStepContainer extends StatelessWidget {
  final Widget child;
  final String? title;
  final String? subtitle;

  const WizardStepContainer({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInRight(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Text(
              title!,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(height: 1.1, color: Colors.white),
            ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),
            ),
          ],
          const SizedBox(height: 32),
          child,
        ],
      ),
    );
  }
}
