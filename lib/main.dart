import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final String deepLinkUrl = 'https://www.naver.com/';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '딥링크 QR 앱',
      home: Scaffold(
        appBar: AppBar(
          title: Text('딥링크 QR 앱'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '딥링크 URL',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 8),
                SelectableText(
                  deepLinkUrl,
                  style: TextStyle(fontSize: 16, color: Colors.blue),
                ),
                SizedBox(height: 24),
                QrImageView(
                  data: deepLinkUrl,
                  version: QrVersions.auto,
                  size: 200.0,
                ),
                SizedBox(height: 24),
                Builder(
                  builder: (BuildContext context) {
                    return ElevatedButton(
                      onPressed: () async {
                        try {
                          Uri uri = Uri.parse(deepLinkUrl);

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
                          Uri uri = Uri.parse(deepLinkUrl);
                          await launchUrl(
                            uri,
                            mode: LaunchMode.inAppBrowserView,
                          );
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
      ),
    );
  }
}