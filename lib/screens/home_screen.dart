import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:semar/screens/kuliner_screen.dart';
import 'package:semar/screens/layanan_screnn.dart';
import 'package:semar/screens/sejarah_screen.dart';
import 'package:semar/screens/disukai_screen.dart';
import 'package:semar/screens/destinasi_screen.dart';
import 'package:semar/screens/callcenter_screen.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<NearbyPlace> nearbyPlaces = [];
  bool _isLoading = false;
  List<NewsEvent> newsEvents = [
    NewsEvent(
      title: "Semarang Night Carnival 2025",
      imagePath: "assets/bg/snc.jpg",
      date: "4 Mei 2025",
      location: "Titik 0KM - Balaikota",
      description: "Semarang Night Carnival (SNC) adalah karnaval malam tahunan untuk merayakan HUT Kota Semarang, menampilkan parade kostum, seni budaya, dan hiburan, serta bertujuan mempromosikan budaya dan pariwisata.",
    ),
    NewsEvent(
      title: "Dugderan",
      imagePath: "assets/bg/dugderan.jpeg",
      date: "28 Februari 2025",
      location: "Jl. Pemuda",
      description: "Dugderan adalah tradisi tahunan di Semarang untuk menyambut bulan Ramadan. Perayaan ini diisi dengan pawai budaya, beduk raksasa, kembang api, dan Pasar Rakyat yang menjajakan wahana, kuliner, pakaian, serta mainan tradisional.",
    )
  ];

  @override
  void initState() {
    super.initState();
    _initializeSamplePlaces();
  }

  void _initializeSamplePlaces() {
    setState(() {
      nearbyPlaces = [
        NearbyPlace(
          name: "Lawang Sewu",
          imagePath: "assets/bg/lawang1000.png",
          distance: 1.2,
          rating: 4.7,
        ),
        NearbyPlace(
          name: "Kota Lama",
          imagePath: "assets/bg/kotlam.png",
          distance: 2.5,
          rating: 4.5,
        ),
        NearbyPlace(
          name: "Museum Ronggowarsito",
          imagePath: "assets/bg/muser.png",
          distance: 3.8,
          rating: 4.3,
        ),
      ];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double navbarHeight = 80;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          // Background layers
          Container(
            width: double.infinity,
            height: screenHeight,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/bg/lawang1000.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: screenHeight,
            color: Color(0xFFFFF2DA).withOpacity(0.6),
          ),

          // Main content
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(bottom: navbarHeight + 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header section
                    _buildHeaderSection(),
                    
                    // Menu grid
                    _buildMenuGrid(context),
                    
                    // Gallery section
                    _buildGallerySection(),
                    
                    // Recommended places
                    _buildRecommendedPlaces(),
                    
                    // News & Events
                    _buildNewsEventsSection(),
                  ],
                ),
              ),
            ),
          ),

          // Semar AI Chat Bubble
          Positioned(
            bottom: 80,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => SemarAIChat(),
                );
              },
              backgroundColor: Color(0xFF275E76),
              child: Icon(Icons.chat_bubble_outline, color: Colors.white),
              elevation: 4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Text(
            "SEMAR",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 48,
              fontWeight: FontWeight.w700,
              color: Color(0xFF275E76),
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
          ),
          Transform.translate(
            offset: Offset(0, -12),
            child: Text(
              "Seputar Semarang",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: Color(0xFF275E76),
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildMenuGrid(BuildContext context) {
    return Center(
      child: Container(
        width: 340,
        height: 220,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: GridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: [
            _buildMenuButton(context, "Destinasi", Icons.map, DestinasiScreen()),
            _buildMenuButton(context, "Tempat Bersejarah", Icons.map_outlined, SejarahScreen()),
            _buildMenuButton(context, "Disukai", Icons.favorite, DisukaiScreen()),
            _buildMenuButton(context, "Kuliner", Icons.restaurant, KulinerScreen()),
            _buildMenuButton(context, "Layanan Publik", Icons.help_outline, LayananScreen()),
            _buildMenuButton(context, "Call Center", Icons.phone, CallCenterScreen()),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String title, IconData icon, Widget screen) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => screen)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Color(0xFF7EB7D9),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          SizedBox(height: 6),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF275E76),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGallerySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 16),
          child: Text(
            "Galeri",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF275E76),
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Container(
            height: 150,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildGalleryImage("assets/bg/majt.png"),
                _buildGalleryImage("assets/bg/lumpia.png"),
                _buildGalleryImage("assets/bg/kariadi.png"),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGalleryImage(String assetPath) {
    return Container(
      width: 130,
      margin: EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: AssetImage(assetPath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildRecommendedPlaces() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        width: 340,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Rekomendasi Wisata",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF275E76),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.refresh, color: Color(0xFF275E76)),
                  onPressed: () {
                    setState(() {
                      _isLoading = true;
                    });
                    Future.delayed(Duration(seconds: 1), () {
                      setState(() {
                        _isLoading = false;
                      });
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 12),
            if (_isLoading)
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: CircularProgressIndicator(),
                ),
              )
            else
              Column(
                children: nearbyPlaces.map((place) => _buildPlaceItem(place)).toList(),
              ),
          ],
        ),
      ),
    );
  }

 Widget _buildPlaceItem(NearbyPlace place) {
  return InkWell(
    onTap: () {},
    child: Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              place.imagePath,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  place.name,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF275E76),
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    SizedBox(width: 4),
                    Text(
                      place.rating.toString(),
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(width: 12),
                    Icon(Icons.location_on, size: 16, color: Colors.red),
                    SizedBox(width: 4),
                    Text(
                      "${place.distance.toStringAsFixed(1)} km",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color(0xFF7EB7D9).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "Lihat Detail",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 10,
                      color: Color(0xFF275E76),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildNewsEventsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        width: 340,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Event",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF275E76)),
            ),
            SizedBox(height: 12),
            Column(
              children: newsEvents
                  .map((event) => _buildNewsEventCard(context, event))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsEventCard(BuildContext context, NewsEvent event) {
    return InkWell(
      onTap: () => _showNewsDetail(context, event),
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(
                event.imagePath,
                width: double.infinity,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF275E76)),
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(
                        event.date,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: Colors.grey[600]),
                      ),
                      SizedBox(width: 12),
                      Icon(Icons.location_on, size: 14, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(
                        event.location,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNewsDetail(BuildContext context, NewsEvent event) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  event.imagePath,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 16),
              Text(
                event.title,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF275E76)),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(
                    event.date,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      color: Colors.grey[600]),
                  ),
                  SizedBox(width: 16),
                  Icon(Icons.location_on, size: 16, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(
                    event.location,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      color: Colors.grey[600]),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                "Deskripsi",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF275E76)),
              ),
              SizedBox(height: 8),
              Text(
                event.description,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: Colors.grey[800]),
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF275E76),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Tutup",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NearbyPlace {
  final String name;
  final String imagePath;
  final double distance;
  final double rating;

  NearbyPlace({
    required this.name,
    required this.imagePath,
    required this.distance,
    required this.rating,
  });
}

class NewsEvent {
  final String title;
  final String imagePath;
  final String date;
  final String location;
  final String description;

  NewsEvent({
    required this.title,
    required this.imagePath,
    required this.date,
    required this.location,
    required this.description,
  });
}


class SemarAIChat extends StatefulWidget {
  @override
  _SemarAIChatState createState() => _SemarAIChatState();
}

class _SemarAIChatState extends State<SemarAIChat> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _messages.add(ChatMessage(
      text: "Halo! Saya Semar AI, asisten virtual untuk informasi tentang kota Semarang. Ada yang bisa saya bantu?",
      isUser: false,
    ));
  }

  Future<void> sendToOpenRouter(String question) async {
    setState(() {
      _isLoading = true;
      _messages.add(ChatMessage(text: question, isUser: true));
      _messages.add(ChatMessage(text: '', isUser: false, isLoading: true));
      _scrollToBottom();
    });

    final url = Uri.parse("https://api.openrouter.ai/v1/completions");

    try {
      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer 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',
            },
            body: jsonEncode({
              "model": "gpt-3.5-turbo", // Pastikan OpenRouter mendukung model yang sama
              "messages": [
                {"role": "system", "content": "Kamu adalah Semar AI, asisten lokal untuk informasi seputar kota Semarang."},
                {"role": "user", "content": question},
              ],
              "temperature": 0.7,
              "max_tokens": 500,
            }),
          )
          .timeout(Duration(seconds: 15), onTimeout: () {
            throw TimeoutException("Permintaan ke OpenRouter terlalu lama.");
          });

      if (response.statusCode == 200) {
        final replyText = (jsonDecode(response.body)['choices'][0]['message']['content']).trim();
        setState(() {
          _messages.removeLast();
          _messages.add(ChatMessage(text: replyText, isUser: false));
          _isLoading = false;
          _scrollToBottom();
        });
      } else {
        throw Exception("Gagal menjawab: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      setState(() {
        _messages.removeLast();
        _messages.add(ChatMessage(
          text: "Maaf, terjadi kesalahan saat menghubungi Semar AI. Coba lagi nanti.",
          isUser: false,
        ));
        _isLoading = false;
        _scrollToBottom();
      });
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFF275E76),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.chat, color: Color(0xFF275E76), size: 24),
                ),
                SizedBox(width: 12),
                Text(
                  'Semar AI',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                if (message.isLoading) return _buildLoadingIndicator();
                return _buildMessageBubble(message);
              },
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Tanyakan tentang Semarang...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Material(
                  elevation: 2,
                  borderRadius: BorderRadius.circular(24),
                  color: Color(0xFF275E76),
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: _isLoading ? null : () {
                      final text = _controller.text.trim();
                      if (text.isNotEmpty) {
                        sendToOpenRouter(text);
                        _controller.clear();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Color(0xFF275E76).withOpacity(0.1),
            child: Icon(Icons.chat, color: Color(0xFF275E76), size: 20),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xFF275E76).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 8),
                  Text('Semar AI sedang mengetik...'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isUser)
            CircleAvatar(
              backgroundColor: Color(0xFF275E76).withOpacity(0.1),
              child: Icon(Icons.chat, color: Color(0xFF275E76), size: 20),
            ),
          if (!message.isUser) SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: message.isUser
                    ? Color(0xFF275E76)
                    : Color(0xFF275E76).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: message.isUser ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ),
          if (message.isUser) SizedBox(width: 8),
          if (message.isUser)
            CircleAvatar(
              backgroundColor: Color(0xFF275E76).withOpacity(0.1),
              child: Icon(Icons.person, color: Color(0xFF275E76)),
            ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final bool isLoading;

  ChatMessage({
    required this.text,
    this.isUser = false,
    this.isLoading = false,
  });
}