package com.example.rechentrainer

import android.os.Build
import android.os.Bundle
import androidx.core.view.WindowCompat
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
	override fun onCreate(savedInstanceState: Bundle?) {

		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
			// Disable the Android splash screen fade out animation to avoid
			// a flicker before the similar frame is drawn in Flutter.
			// Aligns the Flutter view vertically with the window.
			//WindowCompat.setDecorFitsSystemWindows(window, false)
			//splashScreen.setOnExitAnimationListener { splashScreenView -> splashScreenView.remove() }
		}

		super.onCreate(savedInstanceState)
	}
}
