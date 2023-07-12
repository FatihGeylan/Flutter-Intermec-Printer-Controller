package com.example.intermec_printer//package com.example.intermec_printer
//
//import android.app.Activity
//import android.content.res.AssetManager
//import android.os.AsyncTask
//import android.os.Bundle
//import android.util.Log
//import com.honeywell.mobility.print.*
//import java.io.ByteArrayOutputStream
//import java.io.IOException
//import java.io.InputStream
//
//@Suppress("DEPRECATION")
//class PrintActivity : Activity(){
//
//    lateinit var PrinterID: String
//    lateinit var PrinterUri: String
//
//
//    override fun onCreate(savedInstanceState: Bundle?) {
//        super.onCreate(savedInstanceState)
//        intent = getIntent()
//
//        val task: MainActivity.PrinterTask = MainActivity.PrinterTask()
//
//        PrinterID = intent.getStringExtra("PrinterID")!!
//        PrinterUri = intent.getStringExtra("PrinterUri")!!
//
//        task.execute(PrinterID,PrinterUri)
//    }
//
////    private val CHANNEL = "IntermecPrint"
////    var lp: LinePrinter? = null
////    private var jsonCmdAttribStr: String? = null
////    private val TAG = "MyActivity"
////    var sResult: String? = null
//
//    fun NewLine(lineSpace: Int){
//        if (lineSpace != null){
//            lp!!.newLine(lineSpace)
//        }
//    }
//
//    fun Write(index: String){
//        if(index != null) {
//            if(lp != null){
//                lp!!.write(index)
//            }
//            else
//                Log.e(TAG,"Connection must be created before write")
//        }
//        else{
//            Log.e(TAG,"Send Index!")
//        }
//    }
////    class BadPrinterStateException(message: String?) : Exception(message) {
////        companion object {
////            const val serialVersionUID: Long = 1
////        }
////    }
//
////    inner class PrinterTask : AsyncTask<String, Int, String>() {
////
////        private val PROGRESS_CANCEL_MSG = "Printing cancelled\n"
////        private val PROGRESS_COMPLETE_MSG = "Printing completed\n"
////        private val PROGRESS_END_DOC_MSG = "End of document\n"
////        private val PROGRESS_FINISHED_MSG = "Printer connection closed\n"
////        private val PROGRESS_NONE_MSG = "Unknown progress message\n"
////        private val PROGRESS_START_DOC_MSG = "Start printing document\n"
////
////        override fun doInBackground(vararg args: String): String? {
////            val PrinterID = args[0]
////            var PrinterUri = args[1]
////            val msg = "denemedeneem saad"
////            readAssetFiles()
////            val exSettings = LinePrinter.ExtraSettings()
////            exSettings.setContext(this@PrintActivity)
////
////            val progressListener: PrintProgressListener = object : PrintProgressListener {
////                override fun receivedStatus(aEvent: PrintProgressEvent) {
////                    // Publishes updates on the UI thread.
////                    Log.d(TAG, aEvent.getMessageType().toString())
////                }
////            }
////            Log.d(TAG, PrinterUri)
////            Log.d(TAG, PrinterID)
////            try {
////                lp = LinePrinter(
////                    jsonCmdAttribStr,
////                    PrinterID,
////                    PrinterUri,
////                    exSettings
////                )
////
////                // Registers to listen for the print progress events.
////                lp?.addPrintProgressListener(progressListener)
////
////
////
////                //A retry sequence in case the bluetooth socket is temporarily not ready
////                var numtries = 0
////                val maxretry = 2
////                while (numtries < maxretry) {
////                    try {
////                        lp?.connect() // Connects to the printer
////                        break
////                    } catch (ex: LinePrinterException) {
////                        numtries++
////                        Thread.sleep(1000)
////                    }
////                }
////                if (numtries == maxretry) lp?.connect() //Final retry
////
////                // Check the state of the printer and abort printing if there are
////                // any critical errors detected.
////                val results: IntArray? = lp?.status
////                if (results != null) {
////                    for (err in results.indices) {
////                        if (results[err] == 223) {
////                            // Paper out.
////                            throw BadPrinterStateException("Paper out")
////                        } else if (results[err] == 227) {
////                            // Lid open.
////                            throw BadPrinterStateException("Printer lid open")
////                        }
////                    }
////                }
////                getTicketInformationForPrintingTwice()
////                sResult = "Number of bytes sent to printer: " + lp?.bytesWritten
////            } catch (ex: Exception) {
////                if (lp != null) {
////                    Log.d(TAG, "LP null değil dendi la")
////                    lp?.removePrintProgressListener(progressListener)
////                }//
////                else
////                    Log.d(TAG, "LPNİN İCİ BOS KARDESIM BOS")// Stop listening for printer events.
////                sResult = "Unexpected exception: " + ex.message
////                Log.d(TAG, sResult!!)
////                Log.d(TAG, ex.stackTraceToString())
////
////            } finally {
////                try {
////                    if (lp != null)
////                        Log.d(TAG, "LP null değil dendi la")
////                        lp?.disconnect()
////                } catch (e: PrinterException) {
////                    e.printStackTrace()
////                    Log.d(TAG, "LP null dendi")
////                }
////            }
////            return sResult
////        }
////        override fun onPostExecute(result: String?) {
////            super.onPostExecute(result)
////
////            if (result != null) {
////                Log.e(TAG,result)
////            }
////
////        }
////        override fun onProgressUpdate(vararg values: Int?) {
////            super.onProgressUpdate(*values)
////            val progress = values[0]
////
////            when (progress) {
////                PrintProgressEvent.MessageTypes.CANCEL -> Log.d(TAG,PROGRESS_CANCEL_MSG)
////                PrintProgressEvent.MessageTypes.COMPLETE -> Log.d(TAG,PROGRESS_COMPLETE_MSG)
////                PrintProgressEvent.MessageTypes.ENDDOC -> Log.d(TAG,PROGRESS_END_DOC_MSG)
////                PrintProgressEvent.MessageTypes.FINISHED -> Log.d(TAG,PROGRESS_FINISHED_MSG)
////                PrintProgressEvent.MessageTypes.STARTDOC -> Log.d(TAG,PROGRESS_START_DOC_MSG)
////                else -> Log.d(TAG,PROGRESS_NONE_MSG)
////            }
////        }
////    }
////
////    private fun readAssetFiles() {
////        var input: InputStream? = null
////        var output: ByteArrayOutputStream? = null
////        val assetManager: AssetManager = getAssets()
////        val files = arrayOf("printer_profiles.JSON", "honeywell_logo.bmp")
////        var fileIndex = 0
////        var initialBufferSize: Int
////        try {
////            for (filename in files) {
////                input = assetManager.open(filename)
////                initialBufferSize = if (fileIndex == 0) 8000 else 2500
////                output = ByteArrayOutputStream(initialBufferSize)
////                val buf = ByteArray(1024)
////                var len: Int
////                while (input.read(buf).also { len = it } > 0) {
////                    output.write(buf, 0, len)
////                }
////                input.close()
////                input = null
////                output.flush()
////                output.close()
////                when (fileIndex) {
////                    0 -> jsonCmdAttribStr = output.toString()
////                }
////                fileIndex++
////                output = null
////            }
////        } catch (ex: Exception) {
////            Log.w(TAG,"ERROR while reading asset file")
////        } finally {
////            try {
////                if (input != null) {
////                    input.close()
////                    input = null
////                }
////                if (output != null) {
////                    output.close()
////                    output = null
////                }
////            } catch (e: IOException) {
////            }
////        }
////    }
////
////
////    //bileti iki kere yazdırmak için bilgileri tek bir fonksiyon altında topladık, yazıcı özelliklerinde yazdırma sayısını göremedim
////    private fun getTicketInformationForPrintingTwice(){
////        try {
////            lp?.newLine(4)
////
////            lp?.newLine(1)
////            lp?.newLine(2)
////            lp?.setBold(true)
////
////            lp?.write("adssdadsasadsadsa")
////            lp?.newLine(2)
////
////            lp?.write("nbvvnmmngjhhg")
////            lp?.newLine(2)
////
////            lp?.write("sfddffdsfdsdsf")
////            lp?.newLine(2)
////
////            lp?.write("hjjukhkj")
////            lp?.newLine(2)
////
////            lp?.write("erdygfhth")
////            lp?.newLine(2)
////
////            lp?.write("thfjgjguk")
////            lp?.newLine(2)
////
////            lp?.write("fdsdfgdfghf")
////            lp?.newLine(2)
////
////
////
////        } catch (ex: Exception) {
////            Log.v("TAG", ex.message.toString())
////        }
////    }
//}