import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app_theme.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  static final pendingPrompt = ValueNotifier<String?>('');

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _inputController = TextEditingController();
  final _keyController = TextEditingController();
  final _scrollController = ScrollController();

  String _apiKey = '';
  bool _isLoading = false;
  bool _showKeySetup = true;
  final List<_Msg> _display = [];
  final List<Map<String, dynamic>> _history = [];

  String _model = 'gemini-1.5-flash';
  static const _models = ['gemini-1.5-flash', 'gemini-1.5-pro', 'gemini-2.0-flash'];

  static const _prefKey = 'gemini_api_key';
  static const _historyKey = 'chat_history';
  static const _storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _loadKey();
    ChatScreen.pendingPrompt.addListener(_onPendingPrompt);
  }

  @override
  void dispose() {
    ChatScreen.pendingPrompt.removeListener(_onPendingPrompt);
    _inputController.dispose();
    _keyController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onPendingPrompt() {
    final text = ChatScreen.pendingPrompt.value;
    if (text != null && text.isNotEmpty) {
      _inputController.text = text;
      ChatScreen.pendingPrompt.value = '';
    }
  }

  Future<void> _loadKey() async {
    final saved = await _storage.read(key: _prefKey) ?? '';
    if (saved.isNotEmpty) {
      await _loadHistory();
      setState(() {
        _apiKey = saved;
        _showKeySetup = false;
      });
    }
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_historyKey);
    if (raw != null) {
      final List<dynamic> list = jsonDecode(raw);
      final msgs = list.map((e) => _Msg(
            role: e['role'] as String,
            content: e['content'] as String,
          )).toList();
      final history = list.map((e) => {
            'role': e['role'] == 'assistant' ? 'model' : e['role'],
            'parts': [
              {'text': e['content']}
            ],
          }).toList();
      setState(() {
        _display.addAll(msgs);
        _history.addAll(history);
      });
    }
  }

  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final saveable = _display
        .where((m) => !m.isTyping && m.role != 'error')
        .map((m) => {'role': m.role, 'content': m.content})
        .toList();
    await prefs.setString(_historyKey, jsonEncode(saveable));
  }

  Future<void> _clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }

  Future<void> _saveKey(String key) async {
    await _storage.write(key: _prefKey, value: key.trim());
    setState(() {
      _apiKey = key.trim();
      _showKeySetup = false;
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final text = _inputController.text.trim();
    if (text.isEmpty || _isLoading) return;

    _inputController.clear();
    _history.add({
      'role': 'user',
      'parts': [
        {'text': text}
      ],
    });

    setState(() {
      _display.add(_Msg(role: 'user', content: text));
      _display.add(_Msg(role: 'assistant', content: '', isTyping: true));
      _isLoading = true;
    });
    _scrollToBottom();

    try {
      final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/$_model:streamGenerateContent?key=$_apiKey',
      );

      final request = http.Request('POST', url)
        ..headers['Content-Type'] = 'application/json'
        ..body = jsonEncode({
          'system_instruction': {
            'parts': [
              {'text': 'Tu es Gemini, un assistant IA développé par Google DeepMind. Tu réponds de façon claire, concise et utile.'}
            ],
          },
          'contents': _history,
          'generationConfig': {'maxOutputTokens': 2048},
        });

      final client = http.Client();
      final streamedResponse = await client.send(request).timeout(const Duration(seconds: 60));

      if (streamedResponse.statusCode == 200) {
        final StringBuffer accumulated = StringBuffer();
        final StringBuffer lineBuf = StringBuffer();

        setState(() {
          _display.removeLast();
          _display.add(_Msg(role: 'assistant', content: ''));
          _isLoading = false;
        });

        final completer = Completer<void>();

        streamedResponse.stream.listen(
          (chunk) {
            lineBuf.write(utf8.decode(chunk));
            final lines = lineBuf.toString().split('\n');
            lineBuf.clear();
            if (lines.length > 1) {
              lineBuf.write(lines.last);
            }
            for (int i = 0; i < lines.length - 1; i++) {
              final line = lines[i].trim();
              if (line.isEmpty) continue;
              String jsonStr = line;
              if (jsonStr.startsWith('data:')) {
                jsonStr = jsonStr.substring(5).trim();
              }
              if (jsonStr == '[' || jsonStr == ']') continue;
              if (jsonStr.startsWith(',')) jsonStr = jsonStr.substring(1);
              try {
                final parsed = jsonDecode(jsonStr);
                final text = parsed['candidates']?[0]?['content']?['parts']?[0]?['text'] as String?;
                if (text != null) {
                  accumulated.write(text);
                  setState(() {
                    _display.last = _Msg(role: 'assistant', content: accumulated.toString());
                  });
                  _scrollToBottom();
                }
              } catch (_) {}
            }
          },
          onDone: () {
            client.close();
            final reply = accumulated.toString();
            _history.add({
              'role': 'model',
              'parts': [
                {'text': reply}
              ],
            });
            _saveHistory();
            completer.complete();
          },
          onError: (e) {
            client.close();
            _history.removeLast();
            setState(() {
              _display.removeLast();
              _display.add(_Msg(role: 'error', content: 'Erreur réseau : $e'));
              _isLoading = false;
            });
            completer.complete();
          },
          cancelOnError: true,
        );

        await completer.future;
      } else {
        client.close();
        final body = await streamedResponse.stream.bytesToString();
        final err = jsonDecode(body);
        final msg = err['error']?['message'] ?? 'Erreur ${streamedResponse.statusCode}';
        _history.removeLast();
        setState(() {
          _display.removeLast();
          _display.add(_Msg(role: 'error', content: msg));
          _isLoading = false;
        });
      }
    } catch (e) {
      _history.removeLast();
      setState(() {
        _display.removeLast();
        _display.add(_Msg(role: 'error', content: 'Erreur réseau : $e'));
        _isLoading = false;
      });
    }
    _scrollToBottom();
  }

  Future<void> _confirmClear() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nouvelle conversation'),
        content: const Text('Effacer l\'historique de la conversation ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Effacer'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await _clearHistory();
      setState(() {
        _display.clear();
        _history.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppTheme>(
      valueListenable: themeNotifier,
      builder: (context, themeVal, child) {
        if (_showKeySetup) return _buildKeySetup(context);
        return _buildChat(context);
      },
    );
  }

  Widget _buildKeySetup(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: context.heroGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.chat_bubble_outline, color: Colors.white, size: 36),
                SizedBox(height: 12),
                Text('Chat Gemini',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text(
                  'Discutez directement avec Gemini via l\'API Google.',
                  style: TextStyle(color: Colors.white70, height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('Clé API Google AI',
              style: TextStyle(
                  color: context.accentLight,
                  fontWeight: FontWeight.w600,
                  fontSize: 15)),
          const SizedBox(height: 8),
          TextField(
            controller: _keyController,
            obscureText: true,
            style: TextStyle(
                fontFamily: 'monospace', fontSize: 13, color: context.onSurface),
            decoration: InputDecoration(
              hintText: 'AIzaSy...',
              hintStyle:
                  TextStyle(color: context.onSurface.withValues(alpha: 0.3)),
              filled: true,
              fillColor: context.cardBg,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    BorderSide(color: context.accentMid.withValues(alpha: 0.4)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    BorderSide(color: context.accentMid.withValues(alpha: 0.4)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: context.accentLight),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_keyController.text.trim().isNotEmpty) {
                  _saveKey(_keyController.text.trim());
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: context.accentMid,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Valider',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.tipBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: context.tipBorder),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.lock_outline, color: context.accentLight, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Votre clé est stockée localement sur l\'appareil (Android Keystore / iOS Keychain). Elle n\'est jamais envoyée à un serveur tiers.',
                    style: TextStyle(
                        color: context.tipText, fontSize: 12, height: 1.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChat(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          color: context.cardBg,
          child: Row(
            children: [
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _model,
                  isDense: true,
                  style: TextStyle(
                      color: context.accentLight,
                      fontSize: 11,
                      fontFamily: 'monospace'),
                  dropdownColor: context.cardBg,
                  icon: Icon(Icons.arrow_drop_down,
                      color: context.accentLight, size: 16),
                  items: _models
                      .map((m) => DropdownMenuItem(
                            value: m,
                            child: Text(m),
                          ))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setState(() => _model = v);
                  },
                ),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(Icons.refresh, color: context.accentLight, size: 20),
                onPressed: _confirmClear,
                tooltip: 'Nouvelle conversation',
              ),
              IconButton(
                icon:
                    Icon(Icons.key_outlined, color: context.accentLight, size: 20),
                onPressed: () => setState(() => _showKeySetup = true),
                tooltip: 'Changer la clé API',
              ),
            ],
          ),
        ),
        Expanded(
          child: _display.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.auto_awesome,
                          color: context.accentMid.withValues(alpha: 0.3),
                          size: 60),
                      const SizedBox(height: 12),
                      Text('Commencez la conversation',
                          style: TextStyle(
                              color:
                                  context.onSurface.withValues(alpha: 0.3))),
                    ],
                  ),
                )
              : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(12),
                  itemCount: _display.length,
                  itemBuilder: (context, i) =>
                      _buildMessage(context, _display[i]),
                ),
        ),
        SafeArea(
          top: false,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.cardBg,
              border: Border(top: BorderSide(color: context.drawerDivider)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextField(
                    controller: _inputController,
                    maxLines: 4,
                    minLines: 1,
                    style: TextStyle(color: context.onSurface),
                    decoration: InputDecoration(
                      hintText: 'Message à Gemini...',
                      hintStyle: TextStyle(
                          color: context.onSurface.withValues(alpha: 0.4)),
                      filled: true,
                      fillColor: context.surfaceBg,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  child: IconButton(
                    onPressed: _isLoading ? null : _sendMessage,
                    icon: Icon(
                      Icons.send_rounded,
                      color: _isLoading
                          ? context.accentMid.withValues(alpha: 0.3)
                          : context.accentLight,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: context.accentMid.withValues(alpha: 0.2),
                      padding: const EdgeInsets.all(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMessage(BuildContext context, _Msg msg) {
    if (msg.isTyping) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.only(bottom: 8, right: 60),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: context.cardBg,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const _TypingIndicator(),
        ),
      );
    }

    if (msg.role == 'error') {
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Text(msg.content,
                  style: const TextStyle(color: Colors.red, fontSize: 13)),
            ),
          ],
        ),
      );
    }

    final isUser = msg.role == 'user';
    return GestureDetector(
      onLongPress: () {
        Clipboard.setData(ClipboardData(text: msg.content));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Message copié !'),
            duration: Duration(seconds: 2),
          ),
        );
      },
      child: Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: EdgeInsets.only(
            bottom: 8,
            left: isUser ? 60 : 0,
            right: isUser ? 0 : 60,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            gradient: isUser
                ? LinearGradient(
                    colors: context.heroGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isUser ? null : context.cardBg,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            msg.content,
            style: TextStyle(
              color: isUser ? Colors.white : context.onSurface,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}

class _Msg {
  final String role;
  final String content;
  final bool isTyping;
  const _Msg({required this.role, required this.content, this.isTyping = false});
}

class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator();
  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (ctx, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final phase = (_ctrl.value - i * 0.15).clamp(0.0, 1.0);
            final opacity =
                (phase < 0.5 ? phase * 2 : (1 - phase) * 2).clamp(0.3, 1.0);
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: context.accentLight.withValues(alpha: opacity),
                shape: BoxShape.circle,
              ),
            );
          }),
        );
      },
    );
  }
}
