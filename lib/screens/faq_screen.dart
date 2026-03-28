import 'package:flutter/material.dart';
import '../app_theme.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  static const _items = [
    _FaqItem(
      q: 'C\'est quoi un token ?',
      a: 'Un token est une unité de texte (environ 4 caractères en anglais, 3 en français). '
          '"Bonjour le monde" = ~5 tokens. Les modèles Gemini ont une limite de tokens en entrée '
          '(context window) et en sortie. Gemini 1.5 Pro supporte jusqu\'à 1 million de tokens en entrée.',
    ),
    _FaqItem(
      q: 'Comment obtenir une clé API gratuite ?',
      a: '1. Rendez-vous sur aistudio.google.com\n'
          '2. Connectez-vous avec votre compte Google\n'
          '3. Cliquez sur "Get API key" → "Create API key"\n'
          '4. Copiez la clé et collez-la dans l\'écran Chat de cette app\n\n'
          'La clé est gratuite et donne accès à Gemini 1.5 Flash sans carte bancaire.',
    ),
    _FaqItem(
      q: 'Quelles sont les limites du plan gratuit ?',
      a: 'Gemini 1.5 Flash (gratuit) :\n'
          '• 15 requêtes / minute\n'
          '• 1 million de tokens / jour\n'
          '• 1 500 requêtes / jour\n\n'
          'Gemini 1.5 Pro (gratuit) :\n'
          '• 2 requêtes / minute\n'
          '• 50 millions de tokens / jour\n\n'
          'Au-delà, la facturation à l\'usage s\'applique.',
    ),
    _FaqItem(
      q: 'Erreur 429 — Too Many Requests',
      a: 'Vous avez dépassé la limite de requêtes par minute (15 req/min pour Flash).\n\n'
          'Solutions :\n'
          '• Attendez 1 minute avant de réessayer\n'
          '• Réduisez la fréquence de vos appels\n'
          '• Implémentez un système de retry avec backoff exponentiel\n'
          '• Passez au plan payant pour plus de quota',
    ),
    _FaqItem(
      q: 'Erreur 400 — Bad Request',
      a: 'La requête est mal formée. Causes courantes :\n\n'
          '• Clé API invalide ou manquante\n'
          '• Format JSON incorrect dans le body\n'
          '• Modèle inexistant ou mal orthographié\n'
          '• Contenu bloqué par les filtres de sécurité\n\n'
          'Vérifiez le message d\'erreur dans la réponse pour plus de détails.',
    ),
    _FaqItem(
      q: 'Ne jamais committer sa clé API',
      a: 'Une clé API exposée dans un dépôt Git (même privé) peut être volée et utilisée à vos frais.\n\n'
          'Bonnes pratiques :\n'
          '• Stockez la clé dans une variable d\'environnement : API_KEY=...\n'
          '• Ajoutez .env à votre .gitignore\n'
          '• Sur mobile : utilisez flutter_secure_storage (comme cette app)\n'
          '• Sur serveur : utilisez les secrets du provider cloud\n'
          '• Si une clé est compromise : révoquez-la immédiatement dans AI Studio',
    ),
    _FaqItem(
      q: 'Différence entre AI Studio et Vertex AI',
      a: 'Google AI Studio :\n'
          '• Gratuit, pour le prototypage et l\'expérimentation\n'
          '• Pas de SLA, données peuvent être utilisées pour améliorer les modèles\n'
          '• Idéal pour apprendre et tester\n\n'
          'Vertex AI (Google Cloud) :\n'
          '• Payant, pour la production\n'
          '• SLA 99.9%, isolation des données garantie\n'
          '• Intégration avec l\'écosystème GCP (monitoring, IAM, etc.)\n'
          '• Obligatoire pour les applications d\'entreprise',
    ),
    _FaqItem(
      q: 'Qu\'est-ce que le context window ?',
      a: 'La context window (fenêtre de contexte) est la quantité maximale de texte '
          'que le modèle peut "voir" en une seule requête, input + output combinés.\n\n'
          'Gemini 1.5 Pro : 1 million de tokens (~750 000 mots)\n'
          'Gemini 1.5 Flash : 1 million de tokens\n'
          'Gemini 2.0 Flash : 1 million de tokens\n\n'
          'Un grand context window permet d\'analyser des livres entiers, des vidéos longues '
          'ou de grands codebases en une seule requête.',
    ),
    _FaqItem(
      q: 'Qu\'est-ce que le function calling ?',
      a: 'Le function calling permet au modèle d\'appeler des fonctions définies par vous '
          'pour obtenir des données en temps réel ou effectuer des actions.\n\n'
          'Exemple : vous définissez une fonction get_weather(city), le modèle la '
          'détecte comme nécessaire et vous demande de l\'exécuter avec les bons paramètres.\n\n'
          'Cela permet de construire des agents IA capables d\'interagir avec des APIs, '
          'des bases de données ou n\'importe quel système externe.',
    ),
    _FaqItem(
      q: 'Gemini peut-il analyser des images ?',
      a: 'Oui, Gemini est nativement multimodal. Il supporte :\n\n'
          '• Images (JPEG, PNG, WebP, HEIC)\n'
          '• Vidéos (MP4, MPEG, MOV, etc.)\n'
          '• Audio (WAV, MP3, AIFF, etc.)\n'
          '• Documents PDF\n'
          '• Code source dans 20+ langages\n\n'
          'Pour les images, incluez-les dans le champ "parts" de la requête '
          'avec inlineData (base64) ou fileData (URL Google Files API).',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppTheme>(
      valueListenable: themeNotifier,
      builder: (context, theme, child) => ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: context.tipBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: context.tipBorder),
            ),
            child: Row(
              children: [
                Icon(Icons.help_outline, color: context.accentLight, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Réponses aux questions fréquentes sur l\'API Gemini, les erreurs courantes et les bonnes pratiques.',
                    style: TextStyle(color: context.tipText, height: 1.5),
                  ),
                ),
              ],
            ),
          ),
          ..._items.map((item) => _FaqCard(item: item)),
        ],
      ),
    );
  }
}

class _FaqItem {
  final String q;
  final String a;
  const _FaqItem({required this.q, required this.a});
}

class _FaqCard extends StatefulWidget {
  final _FaqItem item;
  const _FaqCard({required this.item});

  @override
  State<_FaqCard> createState() => _FaqCardState();
}

class _FaqCardState extends State<_FaqCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.accentMid.withValues(alpha: 0.2)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => setState(() => _expanded = !_expanded),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.item.q,
                      style: TextStyle(
                        color: context.accentLight,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    color: context.accentMid,
                    size: 20,
                  ),
                ],
              ),
              if (_expanded) ...[
                const SizedBox(height: 10),
                Text(
                  widget.item.a,
                  style: TextStyle(
                    color: context.onSurface.withValues(alpha: 0.85),
                    fontSize: 13,
                    height: 1.6,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
