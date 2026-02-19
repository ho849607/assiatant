package com.example.myapplication;

import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;
import androidx.appcompat.app.AppCompatActivity;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Random;

public class MainActivity extends AppCompatActivity {

    private LinearLayout numbersContainer;
    private Button generateButton;
    private final Random random = new Random();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        numbersContainer = findViewById(R.id.numbers_container);
        generateButton = findViewById(R.id.generate_button);

        generateButton.setOnClickListener(v -> generateNumbers());
        generateNumbers();
    }

    private void generateNumbers() {
        List<Integer> pool = new ArrayList<>();
        for (int i = 1; i <= 45; i++) {
            pool.add(i);
        }
        Collections.shuffle(pool, random);
        List<Integer> picked = pool.subList(0, 6);
        Collections.sort(picked);

        numbersContainer.removeAllViews();
        for (int number : picked) {
            TextView ball = new TextView(this);
            int size = (int) (56 * getResources().getDisplayMetrics().density);
            LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(size, size);
            params.setMargins(8, 0, 8, 0);
            ball.setLayoutParams(params);
            ball.setText(String.valueOf(number));
            ball.setTextColor(0xFFFFFFFF);
            ball.setTextSize(18f);
            ball.setTypeface(null, android.graphics.Typeface.BOLD);
            ball.setGravity(android.view.Gravity.CENTER);
            ball.setBackgroundResource(R.drawable.ball_background);
            numbersContainer.addView(ball);
        }
    }
}
