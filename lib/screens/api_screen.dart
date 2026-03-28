import 'package:flutter/material.dart';
import '../app_theme.dart';

class ApiScreen extends StatefulWidget {
  const ApiScreen({super.key});
  @override
  State<ApiScreen> createState() => _ApiScreenState();
}

class _ApiScreenState extends State<ApiScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppTheme>(
      valueListenable: themeNotifier,
      builder: (context, themeVal, child) => Column(
        children: [
          Container(
            color: context.isRose ? const Color(0xFFECE6F8) : const Color(0xFF0D2137),
            child: TabBar(
              controller: _tabController,
              indicatorColor: context.accentLight,
              labelColor: context.accentLight,
              unselectedLabelColor: context.onSurface.withValues(alpha: 0.4),
              tabs: const [Tab(text: 'Python'), Tab(text: 'JavaScript'), Tab(text: 'Dart'), Tab(text: 'Functions')],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _PythonExamples(),
                _JsExamples(),
                _DartExamples(),
                _FunctionCallingExamples(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PythonExamples extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        _sectionLabel('Appel simple', context),
        const CodeBlock(
          title: 'Python — Gemini simple',
          code: '''import google.generativeai as genai

genai.configure(api_key="VOTRE_CLE")
model = genai.GenerativeModel("gemini-1.5-flash")

response = model.generate_content("Explique le machine learning")
print(response.text)''',
        ),
        _sectionLabel('Avec contexte système', context),
        const CodeBlock(
          title: 'Python — System instruction',
          code: '''model = genai.GenerativeModel(
    "gemini-1.5-flash",
    system_instruction="Tu es un expert en Python. Réponds toujours avec des exemples de code.",
)

response = model.generate_content("Comment lire un fichier CSV ?")
print(response.text)''',
        ),
        _sectionLabel('Streaming', context),
        const CodeBlock(
          title: 'Python — Streaming',
          code: r'''model = genai.GenerativeModel("gemini-1.5-flash")

response = model.generate_content(
    "Écris un long poème sur l'espace",
    stream=True,
)

for chunk in response:
    print(chunk.text, end="", flush=True)''',
        ),
        _sectionLabel('Chat multi-tours', context),
        const CodeBlock(
          title: 'Python — Chat',
          code: '''model = genai.GenerativeModel("gemini-1.5-pro")
chat = model.start_chat(history=[])

response = chat.send_message("Bonjour, qui es-tu ?")
print(response.text)

response = chat.send_message("Quelles sont tes capacités ?")
print(response.text)''',
        ),
        _sectionLabel('Vision (image + texte)', context),
        const CodeBlock(
          title: 'Python — Multimodal',
          code: '''import PIL.Image

model = genai.GenerativeModel("gemini-1.5-pro")
image = PIL.Image.open("photo.jpg")

response = model.generate_content(["Décris cette image", image])
print(response.text)''',
        ),
      ],
    );
  }
}

class _JsExamples extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        _sectionLabel('Appel simple', context),
        const CodeBlock(
          title: 'JavaScript — Gemini simple',
          code: '''import { GoogleGenerativeAI } from "@google/generative-ai";

const genAI = new GoogleGenerativeAI("VOTRE_CLE");
const model = genAI.getGenerativeModel({ model: "gemini-1.5-flash" });

const result = await model.generateContent("Explique le machine learning");
console.log(result.response.text());''',
        ),
        _sectionLabel('Streaming', context),
        const CodeBlock(
          title: 'JavaScript — Streaming',
          code: r'''const result = await model.generateContentStream(
  "Écris un long poème sur l'espace"
);

for await (const chunk of result.stream) {
  process.stdout.write(chunk.text());
}''',
        ),
        _sectionLabel('Chat multi-tours', context),
        const CodeBlock(
          title: 'JavaScript — Chat',
          code: '''const chat = model.startChat({
  history: [
    { role: "user", parts: [{ text: "Bonjour" }] },
    { role: "model", parts: [{ text: "Bonjour ! Comment puis-je vous aider ?" }] },
  ],
});

const result = await chat.sendMessage("Quelles sont tes capacités ?");
console.log(result.response.text());''',
        ),
      ],
    );
  }
}

class _DartExamples extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        _sectionLabel('SDK officiel Dart', context),
        const CodeBlock(
          title: 'Dart — google_generative_ai',
          code: '''import 'package:google_generative_ai/google_generative_ai.dart';

final model = GenerativeModel(
  model: 'gemini-1.5-flash',
  apiKey: 'VOTRE_CLE',
);

final content = [Content.text('Explique le machine learning')];
final response = await model.generateContent(content);
print(response.text);''',
        ),
        _sectionLabel('Appel HTTP direct', context),
        const CodeBlock(
          title: 'Dart — HTTP',
          code: r'''import 'dart:convert';
import 'package:http/http.dart' as http;

final url = Uri.parse(
  'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=VOTRE_CLE',
);

final response = await http.post(
  url,
  headers: {'Content-Type': 'application/json'},
  body: jsonEncode({
    'contents': [
      {
        'parts': [{'text': 'Explique le machine learning'}],
      }
    ],
  }),
);

final data = jsonDecode(response.body);
print(data['candidates'][0]['content']['parts'][0]['text']);''',
        ),
        _sectionLabel('Intégration Flutter Widget', context),
        const CodeBlock(
          title: 'Dart — Flutter FutureBuilder',
          code: r'''FutureBuilder<String>(
  future: _getGeminiResponse("Dis bonjour en 3 langues"),
  builder: (context, snapshot) {
    if (snapshot.hasData) return Text(snapshot.data!);
    if (snapshot.hasError) return Text("Erreur: ${snapshot.error}");
    return const CircularProgressIndicator();
  },
)''',
        ),
      ],
    );
  }
}

class _FunctionCallingExamples extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        _sectionLabel('Définir une fonction', context),
        const CodeBlock(
          title: 'Python — Définition d\'outil',
          code: r'''import google.generativeai as genai

def get_weather(city: str) -> dict:
    # Votre logique ici (appel API météo, etc.)
    return {"city": city, "temperature": 22, "condition": "Ensoleillé"}

weather_tool = genai.protos.Tool(
    function_declarations=[
        genai.protos.FunctionDeclaration(
            name="get_weather",
            description="Retourne la météo actuelle d'une ville",
            parameters=genai.protos.Schema(
                type=genai.protos.Type.OBJECT,
                properties={
                    "city": genai.protos.Schema(type=genai.protos.Type.STRING),
                },
                required=["city"],
            ),
        )
    ]
)''',
        ),
        _sectionLabel('Appel avec outil', context),
        const CodeBlock(
          title: 'Python — Envoi + réponse',
          code: r'''model = genai.GenerativeModel("gemini-1.5-flash", tools=[weather_tool])
chat = model.start_chat()

response = chat.send_message("Quel temps fait-il à Paris ?")

# Le modèle demande à appeler la fonction
fn_call = response.candidates[0].content.parts[0].function_call
print(fn_call.name)   # "get_weather"
print(fn_call.args)   # {"city": "Paris"}

# Exécuter la fonction et renvoyer le résultat
result = get_weather(**fn_call.args)
response2 = chat.send_message(
    genai.protos.Content(parts=[
        genai.protos.Part(function_response=genai.protos.FunctionResponse(
            name=fn_call.name,
            response={"result": result},
        ))
    ])
)
print(response2.text)  # "Il fait 22°C et ensoleillé à Paris."''',
        ),
        _sectionLabel('Function calling en JavaScript', context),
        const CodeBlock(
          title: 'JavaScript — Function calling',
          code: r'''const tools = [{
  functionDeclarations: [{
    name: "get_weather",
    description: "Retourne la météo actuelle d'une ville",
    parameters: {
      type: "OBJECT",
      properties: {
        city: { type: "STRING", description: "Nom de la ville" },
      },
      required: ["city"],
    },
  }],
}];

const model = genAI.getGenerativeModel({ model: "gemini-1.5-flash", tools });
const chat = model.startChat();

const result = await chat.sendMessage("Quel temps fait-il à Lyon ?");
const call = result.response.functionCalls()[0];

if (call) {
  const apiResult = await getWeather(call.args.city); // votre fonction
  const result2 = await chat.sendMessage([{
    functionResponse: { name: call.name, response: apiResult },
  }]);
  console.log(result2.response.text());
}''',
        ),
        _sectionLabel('Mode automatique', context),
        const CodeBlock(
          title: 'Python — Automatic function calling',
          code: r'''# Avec automatic_function_calling=True, le SDK gère le cycle automatiquement
model = genai.GenerativeModel(
    "gemini-1.5-flash",
    tools=[get_weather],  # passer la fonction Python directement
)

# Le SDK appelle automatiquement get_weather() si nécessaire
response = model.generate_content(
    "Quel temps fait-il à Marseille et à Bordeaux ?",
    tool_config={"function_calling_config": "AUTO"},
)
print(response.text)''',
        ),
      ],
    );
  }
}

Widget _sectionLabel(String text, BuildContext context) => Text(
      text,
      style: TextStyle(color: context.accentLight, fontSize: 14, fontWeight: FontWeight.w600),
    );
