import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/installation_screen.dart';
import 'screens/api_screen.dart';
import 'screens/prompts_screen.dart';
import 'screens/features_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/faq_screen.dart';
import 'screens/playground_screen.dart';
import 'screens/google_screen.dart';
import 'screens/apps_screen.dart';
import 'screens/quiz_screen.dart';
import 'screens/ai_agents_screen.dart';
import 'screens/splash_screen.dart';

// ─── Material themes ──────────────────────────────────────────────────────────
class AppThemes {
  static ThemeData get darkBlue => ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF1565C0),
          secondary: Color(0xFF42A5F5),
          surface: Color(0xFF0A1929),
          onPrimary: Colors.white,
          onSurface: Color(0xFFCCE5FF),
        ),
        scaffoldBackgroundColor: const Color(0xFF0A1929),
        drawerTheme: const DrawerThemeData(backgroundColor: Color(0xFF0D2137)),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0D2137),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        cardTheme: const CardThemeData(color: Color(0xFF0D2137), elevation: 2),
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.all(const Color(0xFF42A5F5)),
          trackColor: WidgetStateProperty.all(const Color(0xFF1565C0)),
        ),
      );

  static ThemeData get blueRose => ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF1565C0),
          secondary: Color(0xFFE91E63),
          surface: Color(0xFFF8F0FF),
          onPrimary: Colors.white,
          onSurface: Color(0xFF1A0050),
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F0FF),
        drawerTheme: const DrawerThemeData(backgroundColor: Color(0xFFECE6F8)),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFECE6F8),
          foregroundColor: Color(0xFF1A0050),
          elevation: 0,
        ),
        cardTheme: const CardThemeData(color: Color(0xFFECE6F8), elevation: 2),
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.all(const Color(0xFFE91E63)),
          trackColor: WidgetStateProperty.all(const Color(0xFFF48FB1)),
        ),
      );
}

// ─── Theme configuration ──────────────────────────────────────────────────────
class ThemeConfig {
  final Color primary;
  final Color accent;
  final Color drawerBg;
  final Color divider;
  final Color selectedTile;
  final Color indicator;
  final Color footerText;
  final Color titleColor;
  final List<Color> headerGradient;
  final List<NavItem> navItems;

  const ThemeConfig({
    required this.primary,
    required this.accent,
    required this.drawerBg,
    required this.divider,
    required this.selectedTile,
    required this.indicator,
    required this.footerText,
    required this.titleColor,
    required this.headerGradient,
    required this.navItems,
  });

  static const darkBlue = ThemeConfig(
    primary: Color(0xFF1565C0),
    accent: Color(0xFF42A5F5),
    drawerBg: Color(0xFF0D2137),
    divider: Color(0xFF1A3A5C),
    selectedTile: Color(0xFF1565C0),
    indicator: Color(0xFF42A5F5),
    footerText: Color(0xFF4A7A9B),
    titleColor: Colors.white,
    headerGradient: [Color(0xFF061220), Color(0xFF0D47A1), Color(0xFF1565C0)],
    navItems: [
      NavItem(icon: Icons.home_outlined,         label: 'Accueil',         color: Color(0xFF42A5F5)),
      NavItem(icon: Icons.download_outlined,     label: 'Installation',    color: Color(0xFF1E88E5)),
      NavItem(icon: Icons.code_outlined,         label: 'API & Code',      color: Color(0xFF1565C0)),
      NavItem(icon: Icons.auto_awesome_outlined, label: 'Prompts',         color: Color(0xFF64B5F6)),
      NavItem(icon: Icons.star_outline,          label: 'Fonctionnalités', color: Color(0xFF0288D1)),
      NavItem(icon: Icons.chat_bubble_outline,   label: 'Chat Gemini',     color: Color(0xFF29B6F6)),
      NavItem(icon: Icons.help_outline,           label: 'FAQ',             color: Color(0xFF4DD0E1)),
      NavItem(icon: Icons.science_outlined,       label: 'Playground',      color: Color(0xFF29B6F6)),
      NavItem(icon: Icons.hub_outlined,           label: 'Google & Imagen',  color: Color(0xFF1E88E5)),
      NavItem(icon: Icons.apps_outlined,          label: 'Applications',     color: Color(0xFF4DD0E1)),
      NavItem(icon: Icons.quiz_outlined,          label: 'Quiz',             color: Color(0xFF29B6F6)),
      NavItem(icon: Icons.smart_toy_outlined,     label: 'IA & Agents',      color: Color(0xFF42A5F5)),
    ],
  );

  static const blueRose = ThemeConfig(
    primary: Color(0xFF1565C0),
    accent: Color(0xFFE91E63),
    drawerBg: Color(0xFFECE6F8),
    divider: Color(0xFFCE93D8),
    selectedTile: Color(0xFF1565C0),
    indicator: Color(0xFFE91E63),
    footerText: Color(0xFF9575CD),
    titleColor: Colors.white,
    headerGradient: [Color(0xFF1565C0), Color(0xFF7B1FA2), Color(0xFFE91E63)],
    navItems: [
      NavItem(icon: Icons.home_outlined,         label: 'Accueil',         color: Color(0xFF1565C0)),
      NavItem(icon: Icons.download_outlined,     label: 'Installation',    color: Color(0xFF7B1FA2)),
      NavItem(icon: Icons.code_outlined,         label: 'API & Code',      color: Color(0xFFE91E63)),
      NavItem(icon: Icons.auto_awesome_outlined, label: 'Prompts',         color: Color(0xFF0288D1)),
      NavItem(icon: Icons.star_outline,          label: 'Fonctionnalités', color: Color(0xFFAD1457)),
      NavItem(icon: Icons.chat_bubble_outline,   label: 'Chat Gemini',     color: Color(0xFF4527A0)),
      NavItem(icon: Icons.help_outline,           label: 'FAQ',             color: Color(0xFF7B1FA2)),
      NavItem(icon: Icons.science_outlined,       label: 'Playground',      color: Color(0xFFE91E63)),
      NavItem(icon: Icons.hub_outlined,           label: 'Google & Imagen',  color: Color(0xFF7B1FA2)),
      NavItem(icon: Icons.apps_outlined,          label: 'Applications',     color: Color(0xFFAD1457)),
      NavItem(icon: Icons.quiz_outlined,          label: 'Quiz',             color: Color(0xFF4527A0)),
      NavItem(icon: Icons.smart_toy_outlined,     label: 'IA & Agents',      color: Color(0xFF7B1FA2)),
    ],
  );
}

// ─── App root ────────────────────────────────────────────────────────────────
void main() {
  runApp(const GeminiGuideApp());
}

class GeminiGuideApp extends StatelessWidget {
  const GeminiGuideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppTheme>(
      valueListenable: themeNotifier,
      builder: (context, theme, _) {
        return MaterialApp(
          title: 'Gemini Guide',
          debugShowCheckedModeBanner: false,
          theme: theme == AppTheme.darkBlue ? AppThemes.darkBlue : AppThemes.blueRose,
          home: const SplashScreen(),
        );
      },
    );
  }
}

// ─── Main scaffold ────────────────────────────────────────────────────────────
class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  static final tabNotifier = ValueNotifier<int>(0);

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    MainScaffold.tabNotifier.addListener(_onTabChange);
  }

  @override
  void dispose() {
    MainScaffold.tabNotifier.removeListener(_onTabChange);
    super.dispose();
  }

  void _onTabChange() {
    setState(() => _currentIndex = MainScaffold.tabNotifier.value);
  }

  static const _screens = [
    HomeScreen(),
    InstallationScreen(),
    ApiScreen(),
    PromptsScreen(),
    FeaturesScreen(),
    ChatScreen(),
    FaqScreen(),
    PlaygroundScreen(),
    GoogleScreen(),
    AppsScreen(),
    QuizScreen(),
    AiAgentsScreen(),
  ];

  static const _titles = [
    'Accueil',
    'Installation',
    'API & Code',
    'Prompts',
    'Fonctionnalités',
    'Chat Gemini',
    'FAQ',
    'Playground',
    'Google & Imagen',
    'Applications',
    'Quiz',
    'IA & Agents',
  ];

  ThemeConfig get _cfg =>
      themeNotifier.value == AppTheme.darkBlue ? ThemeConfig.darkBlue : ThemeConfig.blueRose;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppTheme>(
      valueListenable: themeNotifier,
      builder: (context, themeVal, child) => Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            _titles[_currentIndex],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _cfg.titleColor,
            ),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _cfg.headerGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Switch(
                value: themeNotifier.value == AppTheme.blueRose,
                onChanged: (v) => themeNotifier.value =
                    v ? AppTheme.blueRose : AppTheme.darkBlue,
                activeThumbColor: const Color(0xFFE91E63),
                activeTrackColor: const Color(0xFFF48FB1),
                inactiveThumbColor: const Color(0xFF42A5F5),
                inactiveTrackColor: const Color(0xFF1565C0),
              ),
            ),
          ],
        ),
        drawer: _buildDrawer(context),
        body: _screens[_currentIndex],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final cfg = _cfg;
    return Drawer(
      backgroundColor: cfg.drawerBg,
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: cfg.headerGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/images/mon_logo.jpeg',
                        width: 110,
                        height: 170,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Gemini Guide',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Guide complet Google Gemini AI',
                      style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8), fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Nav items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: cfg.navItems.length,
              itemBuilder: (context, index) {
                final item = cfg.navItems[index];
                final isSelected = _currentIndex == index;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? cfg.selectedTile.withValues(alpha: 0.15)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    leading: Icon(item.icon,
                        color: isSelected ? item.color : item.color.withValues(alpha: 0.6)),
                    title: Text(
                      item.label,
                      style: TextStyle(
                        color: isSelected
                            ? item.color
                            : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                    trailing: isSelected
                        ? Container(
                            width: 4,
                            height: 24,
                            decoration: BoxDecoration(
                              color: cfg.indicator,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          )
                        : null,
                    onTap: () {
                      setState(() => _currentIndex = index);
                      Navigator.pop(context);
                    },
                  ),
                );
              },
            ),
          ),
          Divider(color: cfg.divider, height: 1),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Gemini Guide v2.0',
                style: TextStyle(color: cfg.footerText, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NavItem {
  final IconData icon;
  final String label;
  final Color color;
  const NavItem({required this.icon, required this.label, required this.color});
}
