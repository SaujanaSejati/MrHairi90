import 'package:flutter/material.dart';

void main() => runApp(const IlmuQuestApp());

class IlmuQuestApp extends StatelessWidget {
  const IlmuQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IlmuQuest',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5367E8)),
        scaffoldBackgroundColor: const Color(0xFFF5F6FC),
      ),
      home: const WorldScreen(),
    );
  }
}

class WorldScreen extends StatelessWidget {
  const WorldScreen({super.key});

  static const worlds = [
    ('Matematik', 'Selesaikan cabaran nombor dan logik.', Icons.calculate_outlined),
    ('Sains', 'Teroka eksperimen dan alam semula jadi.', Icons.science_outlined),
    ('Bahasa', 'Asah kemahiran bahasa dan kefahaman.', Icons.menu_book_outlined),
    ('Sejarah', 'Jelajah peristiwa dan tamadun.', Icons.account_balance_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IlmuQuest', style: TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          IconButton(
            tooltip: 'Profil pemain',
            onPressed: () => showDialog<void>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Profil pemain'),
                content: const Text('Profil, XP dan lencana akan disambungkan kepada Supabase dalam fasa seterusnya.'),
                actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tutup'))],
              ),
            ),
            icon: const Icon(Icons.account_circle_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                colors: [Color(0xFF5367E8), Color(0xFF8A67E8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('DUNIA ILMU MENANTI', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
                SizedBox(height: 12),
                Text('Pengembaraan bermula di sini.',
                  style: TextStyle(color: Colors.white, fontSize: 27, fontWeight: FontWeight.w800)),
                SizedBox(height: 8),
                Text('Pilih dunia, lengkapkan misi dan tingkatkan ilmu.',
                  style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('Pilih dunia', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: worlds.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.88,
            ),
            itemBuilder: (context, index) {
              final world = worlds[index];
              return Card(
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => MissionScreen(title: world.$1)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(world.$3, size: 40, color: const Color(0xFF5367E8)),
                        const Spacer(),
                        Text(world.$1, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                        const SizedBox(height: 6),
                        Text(world.$2, style: const TextStyle(fontSize: 12)),
                        const SizedBox(height: 10),
                        const Row(children: [Text('Lihat misi'), SizedBox(width: 4), Icon(Icons.arrow_forward, size: 16)]),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          const Text('Versi prototaip: kandungan contoh. Sambungan database, akaun, markah dan dunia 3D akan dibina dalam fasa seterusnya.',
            style: TextStyle(color: Colors.black54, fontSize: 12)),
        ],
      ),
    );
  }
}

class MissionScreen extends StatelessWidget {
  final String title;
  const MissionScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title)),
    body: ListView(
      padding: const EdgeInsets.all(18),
      children: [
        const Text('Misi latihan', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Card(
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.flag_outlined)),
            title: const Text('Misi pengenalan'),
            subtitle: const Text('Kenali asas dan cuba cabaran pertama.'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => showDialog<void>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Misi belum disambungkan'),
                content: const Text('Skrin soalan dan simpanan kemajuan akan diaktifkan selepas database Supabase disambungkan.'),
                actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Faham'))],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
