import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDanger;
  final Widget? trailing;
  final String? subtitle;

  const MenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDanger = false,
    this.trailing,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: isDanger ? const Color(0xFFFFE5E5) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          onTap: onTap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDanger
                  ? const Color(0xFFFF4D4F).withOpacity(0.1)
                  : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: isDanger ? const Color(0xFFFF4D4F) : Colors.grey[700],
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isDanger ? const Color(0xFFFF4D4F) : Colors.black87,
            ),
          ),
          subtitle: subtitle != null
              ? Text(
            subtitle!,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          )
              : null,
          trailing: trailing ?? const Icon(
            Icons.chevron_right,
            size: 20,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}