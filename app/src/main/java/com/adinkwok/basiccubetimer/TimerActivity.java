package com.adinkwok.basiccubetimer;

import android.os.Bundle;
import android.os.Handler;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

public class TimerActivity extends AppCompatActivity {
    private static final int sRefreshRate = 50;
    private TapTimer mTapTimer;
    private TextView mTimerText;

    private final Handler handler = new Handler();

    private final View.OnClickListener mTimerClickListener = new View.OnClickListener() {
        @Override
        public void onClick(View view) {
            mTapTimer.tap();
            updateTimerText();
        }
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_timer);

        mTapTimer = new TapTimer();
        View rootView = ((ViewGroup) this
                .findViewById(android.R.id.content)).getChildAt(0);
        rootView.setOnClickListener(mTimerClickListener);
        mTimerText = findViewById(R.id.time_text);
        updateTimerText();
    }

    private void updateTimerText() {
        handler.postDelayed(new Runnable() {
            @Override
            public void run() {
                mTimerText.setText(mTapTimer.getFormattedTime());
                if (mTapTimer.getRunning()) {
                    handler.postDelayed(this, sRefreshRate);
                }
            }
        }, sRefreshRate);
    }

    @Override
    public void onBackPressed() {
        if (mTapTimer.getRunning()) {
            mTapTimer.tap();
        }
    }
}
