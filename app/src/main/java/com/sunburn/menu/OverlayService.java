package com.sunburn.menu;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.PixelFormat;
import android.os.Build;
import android.os.IBinder;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.WindowManager;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import androidx.core.app.NotificationCompat;

public class OverlayService extends Service {
    private WindowManager windowManager;
    private View overlayView;
    private WindowManager.LayoutParams params;
    private WebView webView;

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public void onCreate() {
        super.onCreate();
        createNotificationChannel();
        startForeground(1, getNotification());

        windowManager = (WindowManager) getSystemService(WINDOW_SERVICE);
        overlayView = LayoutInflater.from(this).inflate(R.layout.overlay_layout, null);

        int type = (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) ? 
                WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY : 
                WindowManager.LayoutParams.TYPE_PHONE;

        params = new WindowManager.LayoutParams(
                WindowManager.LayoutParams.MATCH_PARENT,
                WindowManager.LayoutParams.MATCH_PARENT,
                type,
                WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE | WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN,
                PixelFormat.TRANSLUCENT
        );

        params.gravity = Gravity.TOP | Gravity.START;
        params.x = 0;
        params.y = 0;

        webView = overlayView.findViewById(R.id.webView);
        setupWebView();

        windowManager.addView(overlayView, params);

        // Allow dragging if needed, but since it's MATCH_PARENT, the web content should handle it.
        // If we wanted a smaller draggable window, we'd adjust size and add touch listener.
    }

    private void setupWebView() {
        WebSettings settings = webView.getSettings();
        settings.setJavaScriptEnabled(true);
        settings.setDomStorageEnabled(true);
        settings.setAllowFileAccess(true);
        settings.setAllowContentAccess(true);
        
        webView.setBackgroundColor(Color.TRANSPARENT);
        webView.setWebViewClient(new WebViewClient());
        webView.loadUrl("file:///android_asset/index.html");
    }

    private void createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel serviceChannel = new NotificationChannel(
                    "SunburnOverlayChannel",
                    "Sunburn Overlay Service",
                    NotificationManager.IMPORTANCE_DEFAULT
            );
            NotificationManager manager = getSystemService(NotificationManager.class);
            manager.createNotificationChannel(serviceChannel);
        }
    }

    private Notification getNotification() {
        return new NotificationCompat.Builder(this, "SunburnOverlayChannel")
                .setContentTitle("Sunburn Overlay")
                .setContentText("Running...")
                .setSmallIcon(android.R.drawable.ic_dialog_info)
                .build();
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        if (overlayView != null) windowManager.removeView(overlayView);
    }
}
