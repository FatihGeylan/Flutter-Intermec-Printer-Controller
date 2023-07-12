package com.example.intermec_printer//package com.example.intermec_printer
//
//import androidx.annotation.NonNull
//
//import android.app.Activity
//import android.content.Context
//import android.content.Intent
//import android.util.Log
//import java.util.ArrayList
//import io.flutter.embedding.engine.plugins.FlutterPlugin
//import io.flutter.embedding.engine.plugins.activity.ActivityAware
//import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
//import io.flutter.plugin.common.MethodCall
//import io.flutter.plugin.common.MethodChannel
//import io.flutter.plugin.common.MethodChannel.MethodCallHandler
//import io.flutter.plugin.common.MethodChannel.Result
//import androidx.core.content.ContextCompat.startActivity
//
//class Plugin : FlutterPlugin, MethodCallHandler {
//    /// The MethodChannel that will the communication between Flutter and native Android
//    ///
//    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
//    /// when the Flutter Engine is detached from the Activity
//    private var channel: MethodChannel? = null
//    var c: Context? = null
//    @Override
//    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
//        channel = MethodChannel(flutterPluginBinding.getBinaryMessenger(), "IntermecPrint")
//        channel!!.setMethodCallHandler(this)
//        c = flutterPluginBinding.getApplicationContext()
//    }
//
//    @Override
//    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
//        if (call.method.equals("CreatePrinter")) {
//            val PrinterID: String? = call.argument("PrinterID")
//            val PrinterUri: String? = call.argument("PrinterUri")
//            val intent = Intent(c, PrintActivity::class.java)
//            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
//            intent.putExtra("PrinterID", PrinterID)
//            intent.putExtra("PrinterUri", PrinterUri)
//            startActivity(c!!, intent, null)
////        } else if (call.method.equals("Write")) {
////            val deviceName: String = call.argument("deviceName")
////            val deviceBleutoothMacAdress: String = call.argument("deviceBleutoothMacAdress")
////            val commande: ArrayList<String> = call.argument("cmd")
////            Log.d("cmd", commande.toString())
////            val intent = Intent(c, PrintActivity::class.java)
////            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
////            intent.putExtra("deviceName", deviceName)
////            intent.putExtra("deviceBleutoothMacAdress", deviceBleutoothMacAdress)
////            intent.putExtra("cmd", commande)
////            startActivity(c, intent, null)
//        } else {
//            result.notImplemented()
//        }
//    }
//
//    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
//        channel?.setMethodCallHandler(null)
//    }
//
//}