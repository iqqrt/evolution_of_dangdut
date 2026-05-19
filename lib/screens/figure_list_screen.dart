import 'package:flutter/material.dart';
import '../shared.dart';
import '../data.dart'; // Pastikan kDarkBG dan kAmber ada di sini
import 'figure_detail_screen.dart';

class FigureListScreen extends StatelessWidget {
  const FigureListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBG,
      appBar: AppBar(
        backgroundColor: kDarkBG,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Dangdut Figures", 
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemCount: dangdutFigures.length,
        itemBuilder: (context, index) {
          final figure = dangdutFigures[index];
          
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              // LEADING: Thumbnail Tokoh dari Asset
              leading: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: kAmber.withOpacity(0.2), width: 1),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(11),
                  child: Image.asset(
                    figure.imageAsset, // Field baru dari shared.dart
                    width: 55,
                    height: 55,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 55, 
                      height: 55, 
                      color: Colors.white10,
                      child: const Icon(Icons.person, color: Colors.white24),
                    ),
                  ),
                ),
              ),
              title: Text(
                figure.name, 
                style: const TextStyle(
                  color: Colors.white, 
                  fontWeight: FontWeight.bold,
                  fontSize: 16
                )
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  figure.nickname.toUpperCase(), 
                  style: const TextStyle(
                    color: kAmber, 
                    fontSize: 10, 
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1
                  )
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios_rounded, 
                color: kAmber.withOpacity(0.3), 
                size: 16
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FigureDetailScreen(figure: figure),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}