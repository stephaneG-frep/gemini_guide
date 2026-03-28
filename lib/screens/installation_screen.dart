import 'package:flutter/material.dart';
import '../app_theme.dart';

class InstallationScreen extends StatelessWidget {
  const InstallationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppTheme>(
      valueListenable: themeNotifier,
      builder: (context, themeVal, child) => _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        sectionTitle('Installation Python', context),
        _StepCard(
          step: '1',
          title: 'Installer le SDK Python',
          content: 'pip install google-generativeai',
          color: context.palette[0],
        ),
        _StepCard(
          step: '2',
          title: 'Configurer la clé API',
          content: 'import google.generativeai as genai\n\ngenai.configure(api_key="VOTRE_CLE_API")',
          color: context.palette[1],
        ),
        _StepCard(
          step: '3',
          title: 'Premier appel API',
          content: '''import google.generativeai as genai

genai.configure(api_key="VOTRE_CLE_API")

model = genai.GenerativeModel("gemini-1.5-flash")
response = model.generate_content("Explique l'IA en 3 lignes")
print(response.text)''',
          color: context.palette[2],
        ),
        sectionTitle('Installation JavaScript / TypeScript', context),
        _StepCard(
          step: '1',
          title: 'Installer le SDK JS',
          content: 'npm install @google/generative-ai',
          color: context.palette[3],
        ),
        _StepCard(
          step: '2',
          title: 'Premier appel JS',
          content: '''import { GoogleGenerativeAI } from "@google/generative-ai";

const genAI = new GoogleGenerativeAI("VOTRE_CLE_API");
const model = genAI.getGenerativeModel({ model: "gemini-1.5-flash" });

const result = await model.generateContent("Explique l'IA en 3 lignes");
console.log(result.response.text());''',
          color: context.palette[4],
        ),
        sectionTitle('Installation Dart / Flutter', context),
        _StepCard(
          step: '1',
          title: 'Ajouter la dépendance',
          content: 'flutter pub add google_generative_ai',
          color: context.palette[5],
        ),
        _StepCard(
          step: '2',
          title: 'Utiliser dans Flutter',
          content: '''import 'package:google_generative_ai/google_generative_ai.dart';

final model = GenerativeModel(
  model: 'gemini-1.5-flash',
  apiKey: 'VOTRE_CLE_API',
);

final content = [Content.text("Explique l'IA en 3 lignes")];
final response = await model.generateContent(content);
print(response.text);''',
          color: context.palette[0],
        ),
        sectionTitle('Test avec cURL', context),
        _StepCard(
          step: 'cURL',
          title: 'Appel direct HTTP',
          content: r'''curl -X POST \
  "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=VOTRE_CLE" \
  -H "Content-Type: application/json" \
  -d '{"contents": [{"parts": [{"text": "Explique l'\''IA en 3 lignes"}]}]}'  ''',
          color: context.palette[1],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: context.tipBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: context.tipBorder),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.lightbulb_outline, color: context.accentLight, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Obtenez votre clé API gratuitement sur Google AI Studio : aistudio.google.com/apikey',
                  style: TextStyle(color: context.tipText, height: 1.5),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class _StepCard extends StatelessWidget {
  final String step;
  final String title;
  final String content;
  final Color color;
  const _StepCard({
    required this.step,
    required this.title,
    required this.content,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                child: Center(
                  child: Text(step,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(title,
                    style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w600,
                        fontSize: 15)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          CodeBlock(code: content),
        ],
      ),
    );
  }
}
