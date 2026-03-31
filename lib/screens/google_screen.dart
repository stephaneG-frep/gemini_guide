import 'package:flutter/material.dart';
import '../app_theme.dart';

class GoogleScreen extends StatefulWidget {
  const GoogleScreen({super.key});
  @override
  State<GoogleScreen> createState() => _GoogleScreenState();
}

class _GoogleScreenState extends State<GoogleScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppTheme>(
      valueListenable: themeNotifier,
      builder: (context, theme, child) => Column(
        children: [
          Container(
            color: context.cardBg,
            child: TabBar(
              controller: _tab,
              labelColor: context.primary,
              unselectedLabelColor: context.onSurface.withValues(alpha: 0.5),
              indicatorColor: context.primary,
              tabs: const [
                Tab(text: 'Imagen & Veo'),
                Tab(text: 'Workspace'),
                Tab(text: 'Search Grounding'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tab,
              children: [
                _ImagenTab(),
                _WorkspaceTab(),
                _SearchGroundingTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Tab 1 : Imagen & Veo ────────────────────────────────────────────────────

class _ImagenTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = context.primary;
    final c2 = context.secondary;
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        sectionTitle('Imagen — Génération d\'images', context),
        _InfoCard(
          icon: Icons.image_outlined,
          color: c,
          title: 'Qu\'est-ce qu\'Imagen ?',
          body: 'Imagen est le modèle de génération d\'images de Google DeepMind, '
              'accessible via l\'API Gemini. Imagen 3 offre une qualité '
              'photographique exceptionnelle et une excellente compréhension '
              'des prompts en langage naturel.',
        ),
        const SizedBox(height: 8),
        sectionTitle('Génération via API', context),
        _StepCard(
          step: 1,
          color: c,
          title: 'Imagen 3 — Python',
          child: const CodeBlock(
            code: 'from google import genai\n'
                'from google.genai import types\n\n'
                'client = genai.Client(api_key="votre_cle_gemini")\n\n'
                'response = client.models.generate_images(\n'
                '  model="imagen-3.0-generate-002",\n'
                '  prompt="Un chat astronaute sur la lune, réaliste",\n'
                '  config=types.GenerateImagesConfig(\n'
                '    number_of_images=1,\n'
                '    aspect_ratio="1:1",  # 16:9, 9:16, 4:3\n'
                '  )\n'
                ')\n\n'
                'for img in response.generated_images:\n'
                '    img.image.save("output.png")',
          ),
        ),
        _StepCard(
          step: 2,
          color: c,
          title: 'Gemini + Imagen via chat',
          child: const CodeBlock(
            code: 'response = client.models.generate_content(\n'
                '  model="gemini-2.0-flash-preview-image-generation",\n'
                '  contents="Crée une image d\'un dragon dans les nuages",\n'
                '  config=types.GenerateContentConfig(\n'
                '    response_modalities=["TEXT", "IMAGE"]\n'
                '  )\n'
                ')',
          ),
        ),
        const SizedBox(height: 8),
        sectionTitle('Veo — Génération de vidéos', context),
        _InfoCard(
          icon: Icons.videocam_outlined,
          color: c2,
          title: 'Veo 2 — Vidéos IA',
          body: 'Veo est le modèle de génération vidéo de Google. '
              'Veo 2 produit des vidéos jusqu\'à 8 secondes en haute définition '
              'avec une cohérence temporelle et un réalisme remarquables.',
        ),
        _StepCard(
          step: 3,
          color: c2,
          title: 'Veo 2 — Génération vidéo',
          child: const CodeBlock(
            code: 'operation = client.models.generate_videos(\n'
                '  model="veo-2.0-generate-001",\n'
                '  prompt="Un coucher de soleil sur l\'océan, cinématique",\n'
                '  config=types.GenerateVideoConfig(\n'
                '    aspect_ratio="16:9",\n'
                '    number_of_videos=1\n'
                '  )\n'
                ')\n\n'
                '# Attendre la génération (asynchrone)\nwhile not operation.done:\n'
                '    operation = client.operations.get(operation)\n\n'
                'video = operation.response.generated_videos[0]\n'
                'video.video.save("output.mp4")',
          ),
        ),
        const SizedBox(height: 8),
        sectionTitle('Conseils de prompts', context),
        _InfoCard(
          icon: Icons.tips_and_updates_outlined,
          color: c,
          title: 'Prompts efficaces pour Imagen',
          body: null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _tip(context, c, 'Décrivez le sujet, le style et l\'ambiance'),
              _tip(context, c, '"Ultra-réaliste, éclairage studio, 8K, bokeh"'),
              _tip(context, c, 'Précisez le medium : "aquarelle", "photo argentique"'),
              _tip(context, c, 'Ajoutez l\'angle : "vue aérienne", "portrait en gros plan"'),
              _tip(context, c, 'Évitez les négations — décrivez ce que vous voulez'),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _tip(BuildContext ctx, Color c, String text) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(Icons.arrow_right, color: c, size: 18),
          const SizedBox(width: 4),
          Expanded(child: Text(text,
              style: TextStyle(color: ctx.onSurface.withValues(alpha: 0.75), fontSize: 13))),
        ]),
      );
}

// ── Tab 2 : Google Workspace ────────────────────────────────────────────────

class _WorkspaceTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = context.primary;
    final c2 = context.secondary;
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        sectionTitle('Gemini dans Google Workspace', context),
        _InfoCard(
          icon: Icons.work_outline,
          color: c,
          title: 'Intégration native Google',
          body: 'Gemini est intégré nativement dans toute la suite Google Workspace : '
              'Docs, Sheets, Slides, Gmail, Meet et Drive. '
              'L\'assistant IA est disponible directement dans chaque application '
              'avec un accès à vos données.',
        ),
        const SizedBox(height: 8),
        sectionTitle('Applications Workspace', context),
        _WorkspaceCard(
          icon: Icons.description_outlined,
          color: c,
          app: 'Google Docs',
          features: [
            'Rédiger et reformuler du texte',
            'Résumer des documents longs',
            'Traduire en 40+ langues',
            'Générer des tableaux et listes',
            'Corriger la grammaire et le style',
          ],
        ),
        _WorkspaceCard(
          icon: Icons.table_chart_outlined,
          color: c2,
          app: 'Google Sheets',
          features: [
            'Générer des formules à partir de descriptions',
            'Analyser et résumer des données',
            'Créer des graphiques automatiquement',
            'Classifier et nettoyer des données',
            '"=GEMINI(A1,"traduis en anglais")" — formule IA',
          ],
        ),
        _WorkspaceCard(
          icon: Icons.slideshow_outlined,
          color: c,
          app: 'Google Slides',
          features: [
            'Générer des présentations complètes',
            'Créer des visuels avec Imagen',
            'Suggérer des mises en page',
            'Rédiger le contenu des diapositives',
            'Résumer un document en présentation',
          ],
        ),
        _WorkspaceCard(
          icon: Icons.email_outlined,
          color: c2,
          app: 'Gmail',
          features: [
            'Rédiger des emails professionnels',
            'Résumer de longs fils de discussion',
            'Suggestions de réponses intelligentes',
            'Reformuler selon le ton voulu',
            'Préparer des réponses en un clic',
          ],
        ),
        const SizedBox(height: 8),
        sectionTitle('Workspace via API', context),
        _InfoCard(
          icon: Icons.code_outlined,
          color: c,
          title: 'Google Workspace Events API',
          body: null,
          child: const CodeBlock(
            code: '# Lire et analyser un Google Doc via API\nimport google.generativeai as genai\n\n'
                'genai.configure(api_key="votre_cle")\nmodel = genai.GenerativeModel("gemini-2.0-flash")\n\n'
                '# Charger un fichier depuis Drive\nfile = genai.upload_file("rapport.pdf")\n\n'
                'response = model.generate_content([\n'
                '  file,\n'
                '  "Résume ce rapport en 5 points clés"\n'
                '])\nprint(response.text)',
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

// ── Tab 3 : Search Grounding ────────────────────────────────────────────────

class _SearchGroundingTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = context.primary;
    final c2 = context.secondary;
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        sectionTitle('Google Search Grounding', context),
        _InfoCard(
          icon: Icons.search,
          color: c,
          title: 'Qu\'est-ce que le Search Grounding ?',
          body: 'Le Search Grounding connecte Gemini à Google Search en temps réel. '
              'Le modèle ancre ses réponses sur des résultats de recherche actuels, '
              'réduisant les hallucinations et fournissant des informations récentes '
              'avec des citations vérifiables.',
        ),
        const SizedBox(height: 8),
        sectionTitle('Activation via API', context),
        _StepCard(
          step: 1,
          color: c,
          title: 'Search Grounding — Python',
          child: const CodeBlock(
            code: 'import google.generativeai as genai\n\n'
                'genai.configure(api_key="votre_cle")\n\n'
                'model = genai.GenerativeModel(\n'
                '  model_name="gemini-2.0-flash",\n'
                '  tools=["google_search"]  # Active le grounding\n'
                ')\n\n'
                'response = model.generate_content(\n'
                '  "Quelles sont les dernières avancées en IA en 2025 ?"\n'
                ')\n'
                'print(response.text)',
          ),
        ),
        _StepCard(
          step: 2,
          color: c,
          title: 'Accéder aux sources citées',
          child: const CodeBlock(
            code: '# Récupérer les sources web utilisées\ncandidate = response.candidates[0]\n\n'
                'if candidate.grounding_metadata:\n'
                '  for chunk in candidate.grounding_metadata.grounding_chunks:\n'
                '    print(f"Source : {chunk.web.uri}")\n'
                '    print(f"Titre  : {chunk.web.title}")',
          ),
        ),
        const SizedBox(height: 8),
        sectionTitle('Avantages du Grounding', context),
        _CapabilityCard(
          icon: Icons.verified_outlined,
          color: c,
          title: 'Réduction des hallucinations',
          description: 'En ancrant les réponses sur des sources Google réelles, '
              'le grounding réduit drastiquement les informations inventées '
              'et améliore la fiabilité factuelle.',
        ),
        _CapabilityCard(
          icon: Icons.update_outlined,
          color: c2,
          title: 'Informations en temps réel',
          description: 'Accès aux actualités, prix, événements et données '
              'publiées récemment. Idéal pour les questions sur l\'actualité '
              'ou les marchés financiers.',
        ),
        _CapabilityCard(
          icon: Icons.link_outlined,
          color: c,
          title: 'Citations vérifiables',
          description: 'Chaque affirmation est liée à une source web réelle. '
              'Les URLs et titres des pages sont disponibles dans les métadonnées '
              'de grounding de la réponse.',
        ),
        _CapabilityCard(
          icon: Icons.compare_arrows_outlined,
          color: c2,
          title: 'Grounding vs RAG',
          description: 'Le grounding Google Search est idéal pour les questions générales '
              'et l\'actualité. Le RAG (Retrieval Augmented Generation) '
              'est mieux adapté aux documents privés et bases de données internes.',
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

// ── Shared widgets ──────────────────────────────────────────────────────────

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String? body;
  final Widget? child;

  const _InfoCard({required this.icon, required this.color, required this.title, required this.body, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(width: 36, height: 36,
                decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, color: color, size: 20)),
            const SizedBox(width: 10),
            Expanded(child: Text(title,
                style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14))),
          ]),
          if (body != null) ...[
            const SizedBox(height: 10),
            Text(body!, style: TextStyle(color: context.onSurface.withValues(alpha: 0.8), fontSize: 13, height: 1.5)),
          ],
          if (child != null) ...[const SizedBox(height: 10), child!],
        ],
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final int step;
  final Color color;
  final String title;
  final Widget child;

  const _StepCard({required this.step, required this.color, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(width: 28, height: 28,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.2), shape: BoxShape.circle),
            child: Center(child: Text('$step',
                style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13)))),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(height: 8),
          child,
        ])),
      ]),
    );
  }
}

class _CapabilityCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String description;

  const _CapabilityCard({required this.icon, required this.color, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(width: 36, height: 36,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: color, size: 20)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 4),
          Text(description, style: TextStyle(color: context.onSurface.withValues(alpha: 0.75), fontSize: 13, height: 1.4)),
        ])),
      ]),
    );
  }
}

class _WorkspaceCard extends StatefulWidget {
  final IconData icon;
  final Color color;
  final String app;
  final List<String> features;

  const _WorkspaceCard({required this.icon, required this.color, required this.app, required this.features});

  @override
  State<_WorkspaceCard> createState() => _WorkspaceCardState();
}

class _WorkspaceCardState extends State<_WorkspaceCard> {
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
              Container(width: 36, height: 36,
                  decoration: BoxDecoration(color: c.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
                  child: Icon(widget.icon, color: c, size: 20)),
              const SizedBox(width: 12),
              Expanded(child: Text(widget.app,
                  style: TextStyle(color: c, fontWeight: FontWeight.bold, fontSize: 14))),
              Icon(_expanded ? Icons.expand_less : Icons.expand_more, color: c, size: 20),
            ]),
          ),
        ),
        if (_expanded)
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Divider(color: c.withValues(alpha: 0.2)),
              ...widget.features.map((f) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Icon(Icons.arrow_right, color: c, size: 18),
                      const SizedBox(width: 4),
                      Expanded(child: Text(f,
                          style: TextStyle(color: context.onSurface.withValues(alpha: 0.75), fontSize: 13))),
                    ]),
                  )),
            ]),
          ),
      ]),
    );
  }
}
