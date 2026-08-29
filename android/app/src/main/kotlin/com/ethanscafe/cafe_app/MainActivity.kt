package com.ethanscafe.cafe_app

// local_auth는 FragmentActivity 위에서만 잠금 화면을 띄운다. 평범한 FlutterActivity면
// 확인 요청이 notFragmentActivity로 되돌아와, 잠금을 켜 둬도 아무 일도 일어나지 않는다.
import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity : FlutterFragmentActivity()
