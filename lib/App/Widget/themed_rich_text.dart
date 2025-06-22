import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemedRichText extends StatelessWidget {
  final InlineSpan text;
  final TextStyle? style;
  final TextAlign? textAlign;
  const ThemedRichText({
    super.key,
    required this.text,
    this.style,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);
    final defaultStyle = TextStyle(
      fontFamily: /* theme.textTheme.bodyLarge?.fontFamily ??*/ GoogleFonts.cairo().fontFamily,
    );

    return RichText(
      textAlign: textAlign ?? TextAlign.start,
      text: TextSpan(
        style: defaultStyle.merge(style),
        children: [text],
      ),
    );
  }
}
