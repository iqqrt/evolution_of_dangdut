import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../shared.dart'; // Pastikan kDarkBG dan kAmber ada di sini

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  // --- PAKAI API KEY DARI GMAIL PRIBADI YANG BARU ---
  // HAPUS key lama ini dan PASTE API KEY BARU KAMU di dalam tanda kutip:
  final String _apiKey = "AIzaSyBShVx7AHQSrT9LRPbUWkW59o1xcLE0s8g"; // <--- GANTI BAGIAN INI

  void _sendMessage() async {
    if (_controller.text.isEmpty) return;

    String userMsg = _controller.text;
    setState(() {
      _messages.add({"role": "user", "text": userMsg});
      _isLoading = true;
    });
    _controller.clear();

    try {
      // 1. Inisialisasi Model pake Library Resmi
      final model = GenerativeModel(
        model: 'gemini-2.5-flash', 
        apiKey: _apiKey,
      );

      // 2. Setting Prompt agar jadi "Bang Jago"
      final prompt = "Lu adalah Bang Jago, pakar sejarah musik dangdut Indonesia. lu paham dan mampu menjelaskan apapun itu yang berhubungan dengan dangdut bahkan hubungan dangdut dengan sains, politik, bahkan sampai ke antropologi. bila ditanya soal hal lain, jawab dan langsun alihkan ke topik dangdut dengan cara yang santai, informatif, dan asyik."
          "Jawab pertanyaan user dengan gaya santai, informatif, dan asyik: $userMsg";
      
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      if (response.text != null) {
        setState(() {
          _messages.add({"role": "bot", "text": response.text!});
        });
      } else {
        setState(() {
          _messages.add({"role": "bot", "text": "Bang Jago lagi gak bisa jawab, bro."});
        });
      }
    } catch (e) {
      // Jika masih 404, coba ganti model di atas ke 'gemini-pro'
      setState(() {
        _messages.add({
          "role": "bot", 
          "text": "Kayaknya lu offlne dah: $e"
        });
      });
      print("Detail Error: $e");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBG,
      appBar: AppBar(
        title: const Text("Tanya Bang Jago", 
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: kDarkBG,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty 
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    bool isUser = _messages[index]["role"] == "user";
                    return _buildChatBubble(isUser, _messages[index]["text"]!);
                  },
                ),
          ),
          if (_isLoading) 
            const LinearProgressIndicator(color: kAmber, backgroundColor: Colors.transparent),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.mic_external_on, size: 80, color: kAmber),
          const SizedBox(height: 15),
          Text("Tanya apa aja soal Dangdut!", 
            style: TextStyle(color: Colors.white.withOpacity(0.5))),
        ],
      ),
    );
  }

  Widget _buildChatBubble(bool isUser, String text) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(15),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isUser ? kAmber : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20).copyWith(
            bottomRight: isUser ? const Radius.circular(0) : const Radius.circular(20),
            bottomLeft: isUser ? const Radius.circular(20) : const Radius.circular(0),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isUser ? kDarkBG : Colors.white, 
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: kDarkBG,
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.white),
              onSubmitted: (_) => _sendMessage(),
              decoration: InputDecoration(
                hintText: "Ketik pesan...",
                hintStyle: const TextStyle(color: Colors.white24),
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30), 
                  borderSide: BorderSide.none
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: _sendMessage,
            child: const CircleAvatar(
              backgroundColor: kAmber,
              radius: 25,
              child: Icon(Icons.send_rounded, color: kDarkBG),
            ),
          ),
        ],
      ),
    );
  }
}