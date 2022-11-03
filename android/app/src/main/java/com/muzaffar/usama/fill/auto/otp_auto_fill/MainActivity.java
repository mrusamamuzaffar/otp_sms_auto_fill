package com.muzaffar.usama.fill.auto.otp_auto_fill;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.provider.Telephony;
import android.telephony.SmsMessage;
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.Result;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "otp_auto_fill_flutter";
    Result result;
    MySmsBroadcastReceive mySmsBroadcastReceive = new MySmsBroadcastReceive();

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            this.result = result;
                            if (call.method.equals("getSms")) {
                                try {
                                    registerReceiver(mySmsBroadcastReceive, new IntentFilter(Telephony.Sms.Intents.SMS_RECEIVED_ACTION));
                                }catch (Exception e) {
                                    this.result.success("");
                                }
                            }
                            else if(call.method.equals("unregisterListener")) {
                                try {
                                    unregisterReceiver(mySmsBroadcastReceive);
                                }
                                catch (Exception ignored) {

                                }
                            }
                            else {
                                result.notImplemented();
                            }
                        }
                );
    }

     class MySmsBroadcastReceive extends BroadcastReceiver {

        @Override
        public void onReceive(Context context, Intent intent) {

            try {
                if (Telephony.Sms.Intents.SMS_RECEIVED_ACTION.equals(intent.getAction())) {

                    SmsMessage[] messages = Telephony.Sms.Intents.getMessagesFromIntent(intent);
                    StringBuilder message = new StringBuilder();

                    for (SmsMessage sms : messages) {
                        String msg = sms.getMessageBody();
                        message.append(msg);
                    }

                    result.success(message);
                }
            }catch (Exception e) {
                result.success("");
            }
        }
    }
}