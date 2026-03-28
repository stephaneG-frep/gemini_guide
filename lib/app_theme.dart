import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final themeNotifier = ValueNotifier<AppTheme>(AppTheme.darkBlue);

enum AppTheme { darkBlue, blueRose }

extension AppThemeExt on BuildContext {
  bool get isRose => themeNotifier.value == AppTheme.blueRose;

  Color get primary => Theme.of(this).colorScheme.primary;
  Color get secondary => Theme.of(this).colorScheme.secondary;

  Color get cardBg => isRose ? const Color(0xFFECE6F8) : const Color(0xFF0D2137);
  Color get codeBg => isRose ? const Color(0xFFEDE7F6) : const Color(0xFF061220);
  Color get codeHeader => isRose ? const Color(0xFFD1C4E9) : const Color(0xFF0D2137);
  Color get accentLight => isRose ? const Color(0xFFE91E63) : const Color(0xFF42A5F5);
  Color get accentMid => isRose ? const Color(0xFFAD1457) : const Color(0xFF1565C0);
  Color get surfaceBg => isRose ? const Color(0xFFF8F0FF) : const Color(0xFF0A1929);
  Color get codeText => isRose ? const Color(0xFF4527A0) : const Color(0xFF90CAF9);
  Color get codeBorder => isRose ? const Color(0xFFCE93D8) : const Color(0xFF1A3A5C);
  Color get tipBg => isRose ? const Color(0xFFFCE4EC) : const Color(0xFF0D2137);
  Color get tipBorder => isRose ? const Color(0xFFF48FB1) : const Color(0xFF1565C0);
  Color get tipText => isRose ? const Color(0xFF880E4F) : const Color(0xFF82B1FF);
  Color get drawerDivider => isRose ? const Color(0xFFCE93D8) : const Color(0xFF1A3A5C);
  Color get onSurface => isRose ? const Color(0xFF1A0050) : const Color(0xFFCCE5FF);

  List<Color> get heroGradient => isRose
      ? [const Color(0xFF1565C0), const Color(0xFF7B1FA2), const Color(0xFFE91E63)]
      : [const Color(0xFF061220), const Color(0xFF0D47A1), const Color(0xFF1565C0)];

  List<Color> get palette => isRose
      ? [
          const Color(0xFF1565C0),
          const Color(0xFFE91E63),
          const Color(0xFF7B1FA2),
          const Color(0xFF0288D1),
          const Color(0xFFAD1457),
          const Color(0xFF4527A0),
        ]
      : [
          const Color(0xFF1565C0),
          const Color(0xFF0288D1),
          const Color(0xFF00838F),
          const Color(0xFF1976D2),
          const Color(0xFF0097A7),
          const Color(0xFF0D47A1),
        ];
}

Widget sectionTitle(String text, BuildContext context) => Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: context.accentLight,
        ),
      ),
    );

class CodeBlock extends StatelessWidget {
  final String code;
  final String? title;
  const CodeBlock({super.key, required this.code, this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: context.codeBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.codeBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: context.codeHeader,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title!,
                      style: TextStyle(
                          color: context.accentLight,
                          fontSize: 12,
                          fontWeight: FontWeight.w600)),
                  IconButton(
                    icon: Icon(Icons.copy, size: 16, color: context.accentLight),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: code));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Code copié !'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: SelectableText(
              code,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
                color: context.codeText,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
