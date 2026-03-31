import 'package:flutter/material.dart';
import '../app_theme.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  static final _questions = [
    // ── Fondamentaux ─────────────────────────────────────────────────────
    _Question(
      question: 'Quelle entreprise développe Gemini ?',
      options: ['OpenAI', 'Google DeepMind', 'Anthropic', 'Meta AI'],
      correct: 1,
      explanation: 'Gemini est développé par Google DeepMind, '
          'la division IA de Google issue de la fusion de Google Brain et DeepMind en 2023.',
    ),
    _Question(
      question: 'Quelle est la taille de la fenêtre de contexte de Gemini 1.5 Pro ?',
      options: ['128 000 tokens', '500 000 tokens', '1 000 000 tokens', '2 000 000 tokens'],
      correct: 2,
      explanation: 'Gemini 1.5 Pro dispose d\'une fenêtre de contexte d\'un million (1M) de tokens, '
          'soit environ 2 500 pages de texte ou plus d\'une heure de vidéo. '
          'Gemini 2.0 Pro atteint 2M tokens.',
    ),
    _Question(
      question: 'Quel modèle Gemini est optimisé pour la vitesse et le coût ?',
      options: ['Gemini Ultra', 'Gemini Pro', 'Gemini Flash', 'Gemini Nano'],
      correct: 2,
      explanation: 'Gemini Flash est la variante rapide et économique de Google. '
          'Gemini 2.0 Flash offre d\'excellentes performances pour un coût très faible, '
          'idéal pour les applications à fort volume.',
    ),
    _Question(
      question: 'Qu\'est-ce que le "Search Grounding" de Gemini ?',
      options: [
        'Un moteur de recherche d\'images intégré',
        'La connexion de Gemini à Google Search en temps réel pour ancrer ses réponses',
        'La recherche dans les documents Google Drive',
        'Un plugin de recherche de code GitHub',
      ],
      correct: 1,
      explanation: 'Le Search Grounding connecte Gemini à Google Search pour ancrer '
          'ses réponses sur des résultats web actuels, réduisant les hallucinations '
          'et permettant l\'accès aux informations récentes.',
    ),
    _Question(
      question: 'Comment s\'appelle le modèle de génération d\'images de Google ?',
      options: ['DALL·E', 'Aurora', 'Imagen', 'Lumina'],
      correct: 2,
      explanation: 'Imagen est le modèle de génération d\'images de Google DeepMind. '
          'Imagen 3 est accessible via l\'API Gemini et Google AI Studio.',
    ),
    _Question(
      question: 'Quel modèle Gemini est conçu pour tourner sur les appareils mobiles ?',
      options: ['Gemini Ultra', 'Gemini Pro', 'Gemini Flash', 'Gemini Nano'],
      correct: 3,
      explanation: 'Gemini Nano est le modèle ultra-compact conçu pour fonctionner '
          'directement sur les appareils mobiles (on-device), '
          'sans nécessiter de connexion au cloud.',
    ),
    // ── API & Technique ──────────────────────────────────────────────────
    _Question(
      question: 'Quel est le package Python officiel pour l\'API Gemini ?',
      options: [
        'pip install google-gemini',
        'pip install google-generativeai',
        'pip install gemini-api',
        'pip install google-ai-sdk',
      ],
      correct: 1,
      explanation: 'Le package officiel est "google-generativeai" (ou le nouveau "google-genai"). '
          'Installation : pip install google-generativeai',
    ),
    _Question(
      question: 'Où obtenir gratuitement une clé API Gemini ?',
      options: ['console.cloud.google.com', 'aistudio.google.com', 'gemini.google.com', 'ai.google.dev'],
      correct: 1,
      explanation: 'Google AI Studio (aistudio.google.com) est le portail gratuit '
          'pour obtenir une clé API Gemini et tester les modèles. '
          'Vertex AI est l\'option enterprise sur Google Cloud.',
    ),
    _Question(
      question: 'Comment activer le Search Grounding via l\'API Gemini ?',
      options: [
        'Ajouter search=True dans les paramètres',
        'Utiliser tools=["google_search"] lors de la création du modèle',
        'Appeler un endpoint séparé /v1/search',
        'Activer une option dans les paramètres de sécurité',
      ],
      correct: 1,
      explanation: 'Pour activer le grounding : '
          'model = genai.GenerativeModel(model_name="gemini-2.0-flash", tools=["google_search"]). '
          'Les sources sont ensuite disponibles dans response.candidates[0].grounding_metadata.',
    ),
    _Question(
      question: 'Qu\'est-ce que Gemini peut analyser grâce à ses capacités multimodales ?',
      options: [
        'Texte uniquement',
        'Texte et images uniquement',
        'Texte, images, audio, vidéo et code',
        'Texte, images et PDF uniquement',
      ],
      correct: 2,
      explanation: 'Gemini est nativement multimodal : il traite du texte, des images, '
          'de l\'audio, de la vidéo et du code. Il peut analyser une vidéo entière '
          'ou transcrire et répondre sur un fichier audio.',
    ),
    // ── Google Workspace & Écosystème ────────────────────────────────────
    _Question(
      question: 'Dans quelle application Google peut-on utiliser la formule "=GEMINI()" ?',
      options: ['Google Docs', 'Google Sheets', 'Google Slides', 'Gmail'],
      correct: 1,
      explanation: 'Google Sheets propose des formules IA comme =GEMINI(A1, "traduis en anglais"). '
          'Cette intégration permet d\'utiliser Gemini directement dans les cellules '
          'pour transformer ou analyser des données.',
    ),
    _Question(
      question: 'Qu\'est-ce que Google AI Studio ?',
      options: [
        'L\'application mobile de Gemini',
        'L\'interface web gratuite pour tester et prototyper avec les modèles Gemini',
        'La plateforme enterprise de Google Cloud',
        'Un éditeur de code IA de Google',
      ],
      correct: 1,
      explanation: 'Google AI Studio (aistudio.google.com) est le playground gratuit '
          'de Google pour tester Gemini. Il permet de créer des prompts, '
          'générer du code API et exporter vers Google Colab.',
    ),
    // ── Bonnes pratiques prompts ─────────────────────────────────────────
    _Question(
      question: 'Comment tirer profit des 1M tokens de contexte de Gemini 1.5 Pro ?',
      options: [
        'Envoyer des prompts très courts pour économiser les tokens',
        'Inclure des documents complets, vidéos ou bases de code dans le contexte',
        'Utiliser plusieurs requêtes séparées',
        'Le contexte long ne change pas la qualité des réponses',
      ],
      correct: 1,
      explanation: 'Le contexte long de Gemini permet d\'inclure directement '
          'des PDF complets, du code source entier, ou des transcriptions de réunions. '
          'Plus le contexte est riche et pertinent, meilleures sont les réponses.',
    ),
    _Question(
      question: 'Quelle est la meilleure pratique pour des réponses factuelles avec Gemini ?',
      options: [
        'Demander à Gemini de "tout inventer"',
        'Activer le Search Grounding et demander de citer les sources',
        'Utiliser uniquement Gemini Nano pour plus de précision',
        'Augmenter temperature à 2 pour plus de créativité',
      ],
      correct: 1,
      explanation: 'Pour des réponses factuelles fiables : '
          '1) activez le Search Grounding (tools=["google_search"]) '
          '2) demandez explicitement de "citer vos sources" '
          '3) utilisez temperature=0 pour plus de déterminisme.',
    ),
    _Question(
      question: 'Comment analyser une image avec l\'API Gemini ?',
      options: [
        'Envoyer l\'URL de l\'image dans le prompt texte',
        'Utiliser un endpoint séparé /v1/vision',
        'Passer l\'image dans contents avec PIL ou en base64',
        'Gemini ne supporte pas l\'analyse d\'images via API',
      ],
      correct: 2,
      explanation: 'Avec l\'API Gemini, passez l\'image dans contents : '
          'model.generate_content([image, "Décris cette image"]). '
          'Supports : PIL Image, bytes base64, ou fichier uploadé via genai.upload_file().',
    ),
    _Question(
      question: 'Quel avantage offre Vertex AI par rapport à Google AI Studio pour Gemini ?',
      options: [
        'Vertex AI est gratuit, AI Studio est payant',
        'Vertex AI offre fine-tuning, RAG, conformité enterprise et déploiement production',
        'Vertex AI donne accès à des modèles exclusifs non disponibles ailleurs',
        'Il n\'y a aucune différence entre les deux',
      ],
      correct: 1,
      explanation: 'Vertex AI est la plateforme enterprise : '
          'fine-tuning de Gemini, Vector Search pour le RAG, conformité SOC2/HIPAA/GDPR, '
          'monitoring de production et Agent Builder. '
          'AI Studio est idéal pour le prototypage rapide et gratuit.',
    ),
  ];

  int _index = 0;
  int _score = 0;
  int? _selected;
  bool _answered = false;
  bool _finished = false;

  void _answer(int choice) {
    if (_answered) return;
    setState(() {
      _selected = choice;
      _answered = true;
      if (_questions[_index].correct == choice) _score++;
    });
  }

  void _next() {
    if (_index < _questions.length - 1) {
      setState(() { _index++; _selected = null; _answered = false; });
    } else {
      setState(() => _finished = true);
    }
  }

  void _restart() {
    setState(() { _index = 0; _score = 0; _selected = null; _answered = false; _finished = false; });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppTheme>(
      valueListenable: themeNotifier,
      builder: (context, theme, child) {
        if (_finished) return _ResultPage(score: _score, total: _questions.length, onRestart: _restart);
        final q = _questions[_index];
        final c = context.primary;
        final c2 = context.secondary;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Text('${_index + 1} / ${_questions.length}',
                    style: TextStyle(color: context.onSurface.withValues(alpha: 0.6), fontSize: 13)),
                const SizedBox(width: 12),
                Expanded(child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (_index + 1) / _questions.length,
                    backgroundColor: c.withValues(alpha: 0.15),
                    color: c, minHeight: 6,
                  ),
                )),
                const SizedBox(width: 12),
                Row(children: [
                  Icon(Icons.star, color: c2, size: 16),
                  const SizedBox(width: 4),
                  Text('$_score', style: TextStyle(color: c2, fontWeight: FontWeight.bold, fontSize: 14)),
                ]),
              ]),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: context.cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: c.withValues(alpha: 0.3)),
                ),
                child: Text(q.question, style: TextStyle(
                    color: context.onSurface, fontSize: 16, fontWeight: FontWeight.w600, height: 1.4)),
              ),
              const SizedBox(height: 16),
              ...List.generate(q.options.length, (i) {
                Color borderColor = c.withValues(alpha: 0.2);
                Color bgColor = context.cardBg;
                Color textColor = context.onSurface.withValues(alpha: 0.85);
                IconData? trailingIcon;
                if (_answered) {
                  if (i == q.correct) {
                    borderColor = Colors.green; bgColor = Colors.green.withValues(alpha: 0.12);
                    textColor = Colors.green; trailingIcon = Icons.check_circle_outline;
                  } else if (i == _selected && i != q.correct) {
                    borderColor = Colors.red; bgColor = Colors.red.withValues(alpha: 0.1);
                    textColor = Colors.red.shade300; trailingIcon = Icons.cancel_outlined;
                  }
                }
                return GestureDetector(
                  onTap: () => _answer(i),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: bgColor, borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor),
                    ),
                    child: Row(children: [
                      Container(width: 28, height: 28,
                          decoration: BoxDecoration(
                            color: (_answered && i == q.correct)
                                ? Colors.green.withValues(alpha: 0.2) : c.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Center(child: Text(String.fromCharCode(65 + i),
                              style: TextStyle(
                                  color: (_answered && i == q.correct) ? Colors.green : c,
                                  fontWeight: FontWeight.bold, fontSize: 13)))),
                      const SizedBox(width: 12),
                      Expanded(child: Text(q.options[i], style: TextStyle(color: textColor, fontSize: 14))),
                      if (trailingIcon != null)
                        Icon(trailingIcon,
                            color: i == q.correct ? Colors.green : Colors.red.shade300, size: 20),
                    ]),
                  ),
                );
              }),
              if (_answered) ...[
                const SizedBox(height: 4),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: c.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: c.withValues(alpha: 0.25)),
                  ),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Icon(Icons.info_outline, color: c, size: 18),
                    const SizedBox(width: 8),
                    Expanded(child: Text(q.explanation,
                        style: TextStyle(color: context.onSurface.withValues(alpha: 0.8), fontSize: 13, height: 1.5))),
                  ]),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _next,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: c, foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      _index < _questions.length - 1 ? 'Question suivante →' : 'Voir les résultats',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}

class _ResultPage extends StatelessWidget {
  final int score;
  final int total;
  final VoidCallback onRestart;

  const _ResultPage({required this.score, required this.total, required this.onRestart});

  @override
  Widget build(BuildContext context) {
    final ratio = score / total;
    final c = context.primary;
    final c2 = context.secondary;
    final (emoji, label, comment) = ratio >= 0.9
        ? ('🏆', 'Excellent !', 'Maîtrise parfaite de Gemini & Google AI !')
        : ratio >= 0.7
            ? ('⭐', 'Très bien !', 'Bonne connaissance, quelques points à revoir')
            : ratio >= 0.5
                ? ('👍', 'Pas mal !', 'Continuez à explorer le guide')
                : ('📚', 'À revoir', 'Relisez les sections du guide et réessayez');

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(emoji, style: const TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          Text(label, style: TextStyle(color: c, fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(comment, textAlign: TextAlign.center,
              style: TextStyle(color: context.onSurface.withValues(alpha: 0.7), fontSize: 15)),
          const SizedBox(height: 32),
          Container(
            width: 140, height: 140,
            decoration: BoxDecoration(shape: BoxShape.circle,
                border: Border.all(color: c, width: 4), color: c.withValues(alpha: 0.08)),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('$score / $total',
                  style: TextStyle(color: c, fontSize: 32, fontWeight: FontWeight.bold)),
              Text('${(ratio * 100).round()}%',
                  style: TextStyle(color: c2, fontSize: 16, fontWeight: FontWeight.w500)),
            ]),
          ),
          const SizedBox(height: 32),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(value: ratio,
                backgroundColor: c.withValues(alpha: 0.15), color: c, minHeight: 12),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onRestart,
              icon: const Icon(Icons.refresh),
              label: const Text('Recommencer',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              style: ElevatedButton.styleFrom(
                backgroundColor: c, foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class _Question {
  final String question;
  final List<String> options;
  final int correct;
  final String explanation;

  const _Question({required this.question, required this.options, required this.correct, required this.explanation});
}
