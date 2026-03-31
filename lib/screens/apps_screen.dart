import 'package:flutter/material.dart';
import '../app_theme.dart';

class AppsScreen extends StatelessWidget {
  const AppsScreen({super.key});

  static final _apps = [
    _App(
      icon: Icons.chat_bubble_rounded,
      title: 'Gemini — Application officielle',
      category: 'Officiel Google',
      description:
          'L\'application mobile officielle de Google Gemini pour iOS et Android. '
          'Accès à Gemini 2.0 Flash et Pro, génération d\'images Imagen, '
          'intégration Google Workspace et extensions (Maps, YouTube, Search).',
      tips: [
        'iOS : App Store → "Google Gemini"',
        'Android : Play Store → "Gemini" ou remplace Google Assistant',
        'Extensions : Gmail, Docs, Drive, Maps, YouTube, Search',
        'Deep Research : analyse approfondie multi-sources',
        'Gratuit avec limites, Advanced (20\$/mois) pour Gemini Ultra',
      ],
    ),
    _App(
      icon: Icons.search_outlined,
      title: 'Google Search — AI Overviews',
      category: 'Google Officiel',
      description:
          'Gemini est intégré dans Google Search via les "AI Overviews" (anciennement SGE). '
          'Les résumés IA apparaissent automatiquement en haut des résultats '
          'pour les requêtes complexes.',
      tips: [
        'Automatique dans Google Search (google.com)',
        'Disponible sur mobile et desktop',
        'Résumés avec citations des sources',
        'Possibilité de poser des questions de suivi',
        'Désactivable dans les paramètres de recherche',
      ],
    ),
    _App(
      icon: Icons.work_outline,
      title: 'Google Workspace + Gemini',
      category: 'Productivité',
      description:
          'Gemini est intégré dans Docs, Sheets, Slides, Gmail et Meet. '
          'L\'assistant IA génère, résume et analyse le contenu '
          'directement dans vos applications Google.',
      tips: [
        'Google Docs : rédaction, résumé, traduction',
        'Sheets : formules IA, analyse de données',
        'Slides : génération de présentations complètes',
        'Gmail : rédaction et résumé d\'emails',
        'Meet : résumé automatique des réunions',
      ],
    ),
    _App(
      icon: Icons.code_rounded,
      title: 'Google AI Studio',
      category: 'Développement',
      description:
          'Interface web officielle de Google pour tester et prototyper '
          'avec les modèles Gemini. Génération de code, test de prompts, '
          'gestion des clés API et export vers Vertex AI.',
      tips: [
        'Accès : aistudio.google.com',
        'Gratuit avec quota généreux',
        'Test de prompts multimodaux (texte, image, audio, vidéo)',
        'Génération de code API en Python, Node.js, cURL',
        'Export direct vers Google Colab',
      ],
    ),
    _App(
      icon: Icons.cloud_outlined,
      title: 'Vertex AI — Enterprise',
      category: 'Enterprise / Cloud',
      description:
          'Plateforme Google Cloud pour déployer Gemini en production. '
          'Fine-tuning, RAG, agents IA, monitoring et sécurité enterprise. '
          'Idéal pour les applications d\'entreprise à grande échelle.',
      tips: [
        'console.cloud.google.com → Vertex AI',
        'Fine-tuning supervisé de Gemini',
        'Vector Search intégré pour le RAG',
        'Agent Builder pour créer des agents IA',
        'Conformité SOC2, HIPAA, GDPR',
      ],
    ),
    _App(
      icon: Icons.edit_outlined,
      title: 'Cursor avec Gemini',
      category: 'Développement',
      description:
          'Configurez Cursor pour utiliser l\'API Gemini via la compatibilité OpenAI. '
          'Gemini 2.0 Flash est particulièrement rapide et économique '
          'pour l\'assistance au code.',
      tips: [
        'Cursor Settings → Models → Custom',
        'Base URL : https://generativelanguage.googleapis.com/v1beta/openai',
        'Model : gemini-2.0-flash ou gemini-2.0-pro',
        'Clé API : depuis aistudio.google.com',
        'Téléchargement : cursor.sh',
      ],
    ),
    _App(
      icon: Icons.science_outlined,
      title: 'Google Colab + Gemini',
      category: 'Data Science',
      description:
          'Google Colab intègre Gemini nativement pour l\'assistance au code Python, '
          'la génération de cellules et l\'explication de code. '
          'L\'API Gemini s\'utilise aussi directement dans les notebooks.',
      tips: [
        'colab.research.google.com',
        'Bouton "Générer" dans l\'interface Colab',
        'Explication et débogage de code en un clic',
        'pip install google-generativeai disponible',
        'Accès gratuit aux GPU/TPU pour l\'inférence',
      ],
    ),
    _App(
      icon: Icons.extension_outlined,
      title: 'Continue.dev avec Gemini',
      category: 'Développement',
      description:
          'Extension VS Code open source configurable avec l\'API Gemini. '
          'Utilisez Gemini 2.0 Flash pour l\'autocomplétion et le chat '
          'dans votre éditeur à un coût très compétitif.',
      tips: [
        'Extension VS Code : "Continue"',
        'Provider : "gemini" dans config.json',
        'Model : gemini-2.0-flash-exp',
        'Open source : github.com/continuedev/continue',
        'Gratuit avec votre clé API Google AI Studio',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppTheme>(
      valueListenable: themeNotifier,
      builder: (context, theme, child) => ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _apps.length,
        itemBuilder: (context, i) => _AppCard(
          app: _apps[i],
          color: context.palette[i % context.palette.length],
        ),
      ),
    );
  }
}

class _AppCard extends StatefulWidget {
  final _App app;
  final Color color;
  const _AppCard({required this.app, required this.color});

  @override
  State<_AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<_AppCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final c = widget.color;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.withValues(alpha: 0.3)),
      ),
      child: Column(children: [
        InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => setState(() => _expanded = !_expanded),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(children: [
              Container(width: 42, height: 42,
                  decoration: BoxDecoration(color: c.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
                  child: Icon(widget.app.icon, color: c, size: 22)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(widget.app.title, style: TextStyle(color: c, fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: c.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(4)),
                  child: Text(widget.app.category,
                      style: TextStyle(color: c, fontSize: 11, fontWeight: FontWeight.w500)),
                ),
              ])),
              Icon(_expanded ? Icons.expand_less : Icons.expand_more, color: c, size: 20),
            ]),
          ),
        ),
        if (_expanded)
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Divider(color: c.withValues(alpha: 0.2)),
              Text(widget.app.description,
                  style: TextStyle(color: context.onSurface.withValues(alpha: 0.8), fontSize: 13, height: 1.5)),
              const SizedBox(height: 10),
              ...widget.app.tips.map((tip) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Icon(Icons.arrow_right, color: c, size: 18),
                      const SizedBox(width: 4),
                      Expanded(child: Text(tip,
                          style: TextStyle(color: context.onSurface.withValues(alpha: 0.7), fontSize: 13))),
                    ]),
                  )),
            ]),
          ),
      ]),
    );
  }
}

class _App {
  final IconData icon;
  final String title;
  final String category;
  final String description;
  final List<String> tips;

  const _App({required this.icon, required this.title, required this.category, required this.description, required this.tips});
}
