import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
        _buildHero(context),
        const SizedBox(height: 16),
        _buildInfoCard(
          context,
          Icons.info_outline,
          'Google Gemini est la famille de modèles d\'IA multimodaux de Google DeepMind. '
          'Disponible via Google AI Studio et l\'API Gemini, il supporte texte, images, audio et vidéo.',
        ),
        const SizedBox(height: 12),
        sectionTitle('Modèles Gemini', context),
        _ModelCard(
          name: 'Gemini 1.5 Pro',
          id: 'gemini-1.5-pro',
          description: 'Modèle le plus capable. Contexte 1M tokens. Multimodal (texte, image, audio, vidéo).',
          color: context.palette[0],
        ),
        _ModelCard(
          name: 'Gemini 1.5 Flash',
          id: 'gemini-1.5-flash',
          description: 'Rapide et économique. Idéal pour applications à grande échelle.',
          color: context.palette[1],
        ),
        _ModelCard(
          name: 'Gemini 1.5 Flash-8B',
          id: 'gemini-1.5-flash-8b',
          description: 'Très léger, ultra-rapide. Pour tâches simples à fort volume.',
          color: context.palette[2],
        ),
        _ModelCard(
          name: 'Gemini 2.0 Flash',
          id: 'gemini-2.0-flash',
          description: 'Nouvelle génération. Meilleur rapport qualité/vitesse. Multimodal natif.',
          color: context.palette[3],
        ),
        _ModelCard(
          name: 'Gemini Embedding',
          id: 'text-embedding-004',
          description: 'Vecteurs sémantiques 768 dimensions pour RAG et recherche.',
          color: context.palette[4],
        ),
        sectionTitle('Liens utiles', context),
        _LinkCard(
          icon: Icons.web,
          label: 'Google AI Studio',
          subtitle: 'aistudio.google.com',
          url: 'https://aistudio.google.com',
        ),
        _LinkCard(
          icon: Icons.description_outlined,
          label: 'Documentation Gemini',
          subtitle: 'ai.google.dev',
          url: 'https://ai.google.dev',
        ),
        _LinkCard(
          icon: Icons.key_outlined,
          label: 'Obtenir une clé API',
          subtitle: 'aistudio.google.com/apikey',
          url: 'https://aistudio.google.com/apikey',
        ),
      ],
    );
  }

  Widget _buildHero(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: context.heroGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.auto_awesome, color: Colors.white, size: 32),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Google Gemini',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold)),
                    Text('Guide complet de l\'API',
                        style: TextStyle(color: Colors.white70, fontSize: 14)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Explorez l\'API Gemini : installation, exemples de code, prompts et fonctionnalités avancées.',
            style: TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.tipBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.tipBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: context.accentLight, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text,
                style: TextStyle(color: context.tipText, height: 1.5)),
          ),
        ],
      ),
    );
  }
}

class _ModelCard extends StatelessWidget {
  final String name;
  final String id;
  final String description;
  final Color color;
  const _ModelCard({
    required this.name,
    required this.id,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 50,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
                Text(id,
                    style: TextStyle(
                        color: context.accentMid,
                        fontSize: 11,
                        fontFamily: 'monospace')),
                const SizedBox(height: 4),
                Text(description,
                    style: TextStyle(
                        color: context.onSurface.withValues(alpha: 0.8),
                        fontSize: 13,
                        height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LinkCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final String url;
  const _LinkCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => launchUrl(Uri.parse(url)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: context.cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.accentMid.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: context.accentLight, size: 24),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: TextStyle(
                          color: context.accentLight,
                          fontWeight: FontWeight.w600)),
                  Text(subtitle,
                      style: TextStyle(
                          color: context.onSurface.withValues(alpha: 0.6),
                          fontSize: 12)),
                ],
              ),
            ),
            Icon(Icons.open_in_new,
                color: context.accentMid.withValues(alpha: 0.6), size: 16),
          ],
        ),
      ),
    );
  }
}
