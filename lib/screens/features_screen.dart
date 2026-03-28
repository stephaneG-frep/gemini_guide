import 'package:flutter/material.dart';
import '../app_theme.dart';

class FeaturesScreen extends StatelessWidget {
  const FeaturesScreen({super.key});

  static final _features = [
    _Feature(
      icon: Icons.auto_awesome,
      title: 'Multimodal natif',
      description: 'Gemini comprend et génère texte, images, audio, vidéo et code nativement.',
      tips: [
        'Analyse d\'images en haute résolution',
        'Compréhension audio (parole, musique)',
        'Analyse de vidéos jusqu\'à 1 heure',
        'Génération de code dans 20+ langages',
      ],
    ),
    _Feature(
      icon: Icons.memory,
      title: 'Contexte 1 million de tokens',
      description: 'Gemini 1.5 Pro supporte un contexte de 1 million de tokens, le plus large du marché.',
      tips: [
        'Analyse de livres entiers ou bases de code',
        'Conversation avec mémoire longue durée',
        'Traitement de vidéos de 1h+ en une fois',
        'Documents PDF de centaines de pages',
      ],
    ),
    _Feature(
      icon: Icons.speed,
      title: 'Gemini Flash — Ultra-rapide',
      description: 'Gemini 1.5 Flash offre un excellent compromis vitesse/qualité pour les applications.',
      tips: [
        'Latence réduite pour UX réactive',
        'Coût 10x inférieur à Gemini Pro',
        'Idéal pour chatbots et agents',
        'Streaming rapide pour réponses longues',
      ],
    ),
    _Feature(
      icon: Icons.functions,
      title: 'Function Calling',
      description: 'Connectez Gemini à vos APIs et outils externes avec le function calling structuré.',
      tips: [
        'Définition de fonctions en JSON Schema',
        'Appels parallèles de fonctions',
        'Résultats injectés dans le contexte',
        'Construction d\'agents autonomes',
      ],
    ),
    _Feature(
      icon: Icons.search,
      title: 'Grounding & Google Search',
      description: 'Gemini peut se connecter à Google Search pour des réponses à jour et vérifiées.',
      tips: [
        'Informations en temps réel',
        'Citations et sources vérifiables',
        'Réduction des hallucinations',
        'Intégration native via Google AI Studio',
      ],
    ),
    _Feature(
      icon: Icons.code,
      title: 'Code & Raisonnement',
      description: 'Capacités avancées de génération, analyse et exécution de code.',
      tips: [
        'Code Execution pour Python intégré',
        'Debugging et revue de code',
        'Génération de tests unitaires',
        'Explication de code complexe',
      ],
    ),
    _Feature(
      icon: Icons.language,
      title: 'Multilingue',
      description: 'Gemini supporte plus de 40 langues avec d\'excellentes performances en français.',
      tips: [
        'Traduction haute qualité',
        'Compréhension des nuances culturelles',
        'Code-switching naturel',
        'Excellent support du français',
      ],
    ),
    _Feature(
      icon: Icons.cloud,
      title: 'Google AI Studio & Vertex AI',
      description: 'Deux plateformes complémentaires pour utiliser Gemini en production.',
      tips: [
        'AI Studio : prototypage rapide et gratuit',
        'Vertex AI : production enterprise',
        'API REST compatible et SDKs officiels',
        'Quota gratuit généreux pour démarrer',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppTheme>(
      valueListenable: themeNotifier,
      builder: (context, themeVal, child) => ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _features.length,
        itemBuilder: (context, i) => _FeatureCard(
          feature: _features[i],
          color: context.palette[i % context.palette.length],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatefulWidget {
  final _Feature feature;
  final Color color;
  const _FeatureCard({required this.feature, required this.color});
  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: widget.color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: widget.color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(widget.feature.icon, color: widget.color, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.feature.title,
                      style: TextStyle(
                        color: widget.color,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    color: widget.color,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(color: widget.color.withValues(alpha: 0.2)),
                  Text(
                    widget.feature.description,
                    style: TextStyle(
                      color: context.onSurface.withValues(alpha: 0.8),
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...widget.feature.tips.map((tip) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.arrow_right,
                                color: widget.color, size: 18),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                tip,
                                style: TextStyle(
                                  color: context.onSurface.withValues(alpha: 0.7),
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _Feature {
  final IconData icon;
  final String title;
  final String description;
  final List<String> tips;
  const _Feature({
    required this.icon,
    required this.title,
    required this.description,
    required this.tips,
  });
}
