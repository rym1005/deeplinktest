import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: '딥링크 QR 앱', home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // 장소별 URL 매핑
  final Map<String, String> placeUrls = {
    '강남': 'solpay://event?client_code=gangnam',
    '범계': 'solpay://event?client_code=bumgye',
    '사당': 'solpay://event?client_code=sadang',
  };

  String selectedPlace = '강남'; // 기본 선택값

  String get currentUrl =>
      placeUrls[selectedPlace] ?? 'solpay://event?client_code=gangnam';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('딥링크 QR 앱')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 장소 선택 콤보박스
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedPlace,
                    isExpanded: true,
                    icon: Icon(Icons.arrow_drop_down),
                    items: placeUrls.keys.map((String place) {
                      return DropdownMenuItem<String>(
                        value: place,
                        child: Text(place, style: TextStyle(fontSize: 16)),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedPlace = newValue;
                        });
                      }
                    },
                  ),
                ),
              ),
              SizedBox(height: 24),
              Text(
                '선택된 장소: $selectedPlace',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('딥링크 URL', style: TextStyle(fontSize: 16)),
              SizedBox(height: 8),
              SelectableText(
                currentUrl,
                style: TextStyle(fontSize: 14, color: Colors.blue),
              ),
              SizedBox(height: 24),
              QrImageView(
                data: currentUrl,
                version: QrVersions.auto,
                size: 200.0,
              ),
              SizedBox(height: 24),
              Builder(
                builder: (BuildContext context) {
                  return ElevatedButton(
                    onPressed: () async {
                      try {
                        Uri uri = Uri.parse(currentUrl);

                        // 방법 1: canLaunchUrl 체크 없이 직접 실행
                        await launchUrl(
                          uri,
                          mode: LaunchMode.externalApplication,
                        );

                        // 방법 2: 또는 canLaunchUrl 체크하되 예외 처리
                        /*
                        bool canLaunch = await canLaunchUrl(uri);
                        if (canLaunch) {
                          await launchUrl(uri, mode: LaunchMode.externalApplication);
                        } else {
                          // canLaunchUrl이 false여도 시도해보기
                          await launchUrl(uri, mode: LaunchMode.externalApplication);
                        }
                        */
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('URL을 열 수 없습니다: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    child: Text('딥링크 열기'),
                  );
                },
              ),
              SizedBox(height: 16),
              // 추가 버튼: 브라우저에서 열기
              Builder(
                builder: (BuildContext context) {
                  return ElevatedButton(
                    onPressed: () async {
                      try {
                        Uri uri = Uri.parse(currentUrl);
                        await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('브라우저를 열 수 없습니다: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('앱 내 브라우저에서 열기'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
